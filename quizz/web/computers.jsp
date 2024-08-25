<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Computers Quiz</title>
    <style>
        /* Styling as provided in the original code */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #1a1a1a;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }
        .container {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-width: 900px;
            width: 90%;
            transition: transform 0.3s ease-in-out;
        }
        h1 {
            margin-top: 0;
            color: #444;
            font-size: 2.5em;
            font-weight: bold;
            text-align: center;
        }
        .timer {
            font-size: 1.5em;
            color: #d9534f;
            text-align: center;
            margin-bottom: 20px;
        }
        .question {
            text-align: left;
            margin-bottom: 25px;
            background: #f9f9f9;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: 2px solid #429a9a;
            transition: all 0.3s ease;
        }
        .question:hover {
            border-color: #34787d;
            transform: scale(1.02);
        }
        .options ul {
            list-style-type: none;
            padding: 0;
        }
        .options ul li {
            margin-bottom: 10px;
        }
        .message {
            margin-top: 20px;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
        }
        .message.success {
            background-color: #dff0d8;
            color: #3c763d;
        }
        .message.error {
            background-color: #f2dede;
            color: #a94442;
        }
        button {
            background: #429a9a;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s;
            font-size: 1em;
        }
        button:hover {
            background: #34787d;
            transform: scale(1.05);
        }
        @media (max-width: 600px) {
            .container {
                width: 100%;
                padding: 20px;
            }
            h1 {
                font-size: 2em;
            }
        }
    </style>
    <script>
        let timerInterval;

        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.options input[type="radio"]').forEach(option => {
                option.addEventListener('click', function () {
                    const questionElement = this.closest('.question');
                    questionElement.querySelectorAll('.options input[type="radio"]').forEach(input => input.classList.remove('selected'));
                    this.classList.add('selected');
                });
            });

            // Initialize the timer
            const totalTime = 50; // 50 seconds
            startTimer(totalTime, document.getElementById('timer'));

            function startTimer(duration, display) {
                let timer = duration, minutes, seconds;
                timerInterval = setInterval(function () {
                    minutes = parseInt(timer / 60, 10);
                    seconds = parseInt(timer % 60, 10);

                    minutes = minutes < 10 ? "0" + minutes : minutes;
                    seconds = seconds < 10 ? "0" + seconds : seconds;

                    display.textContent = minutes + ":" + seconds;

                    if (--timer < 0) {
                        clearInterval(timerInterval);
                        alert("Time's up! The quiz will now be submitted.");
                        submitAnswers();
                    }
                }, 1000);
            }
        });

        function submitAnswers() {
            const questions = document.querySelectorAll('.question');
            questions.forEach(question => {
                const selectedOption = question.querySelector('.options input[type="radio"]:checked');
                if (!selectedOption) {
                    question.querySelector('.options input[type="hidden"]').value = 'none'; // Set value to 'none' for unselected questions
                }
            });
            document.getElementById('quizForm').submit();
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Computer Science Questions</h1>
        <div class="timer" id="timer">00:50</div>
        <form id="quizForm" method="post">
        <%!
            public Connection getConnection() throws SQLException, ClassNotFoundException {
                Class.forName("com.mysql.cj.jdbc.Driver");
                return DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz", "root", "root");
            }

            public boolean saveUserSelection(int questionId, int selectedOption) throws SQLException, ClassNotFoundException {
                Connection con = null;
                PreparedStatement pstmt = null;
                boolean success = false;

                try {
                    con = getConnection();
                    // Check if the question_id exists in computer_questions table
                    String checkSql = "SELECT question_id FROM computer_questions WHERE question_id = ?";
                    pstmt = con.prepareStatement(checkSql);
                    pstmt.setInt(1, questionId);
                    ResultSet rs = pstmt.executeQuery();
                    if (!rs.next()) {
                        throw new SQLException("Question ID " + questionId + " does not exist in computer_questions table.");
                    }
                    rs.close();
                    pstmt.close();

                    // Insert the answer
                    String sql = "INSERT INTO computeruser_answers (question_id, selected_option) VALUES (?, ?) ON DUPLICATE KEY UPDATE selected_option = VALUES(selected_option)";
                    pstmt = con.prepareStatement(sql);
                    pstmt.setInt(1, questionId);
                    pstmt.setInt(2, selectedOption);
                    int affectedRows = pstmt.executeUpdate();
                    success = affectedRows > 0;
                } catch (SQLException e) {
                    e.printStackTrace();
                    throw e;
                } finally {
                    if (pstmt != null) pstmt.close();
                    if (con != null) con.close();
                }

                return success;
            }

            public void ensureTablesExist() throws SQLException, ClassNotFoundException {
                Connection con = null;
                Statement stmt = null;
                try {
                    con = getConnection();
                    stmt = con.createStatement();
                    // Ensuring tables exist
                    String createQuestionsTable = "CREATE TABLE IF NOT EXISTS computer_questions (" +
                                                  "question_id INT PRIMARY KEY, " +
                                                  "question VARCHAR(255), " +
                                                  "opt1 VARCHAR(255), " +
                                                  "opt2 VARCHAR(255), " +
                                                  "opt3 VARCHAR(255), " +
                                                  "opt4 VARCHAR(255))";
                    String createUserAnswersTable = "CREATE TABLE IF NOT EXISTS computeruser_answers (" +
                                                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                                    "question_id INT, " +
                                                    "selected_option INT, " +
                                                    "FOREIGN KEY (question_id) REFERENCES computer_questions(question_id) " +
                                                    "ON DELETE CASCADE)";
                    stmt.executeUpdate(createQuestionsTable);
                    stmt.executeUpdate(createUserAnswersTable);
                } catch (SQLException e) {
                    e.printStackTrace();
                    throw e;
                } finally {
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                }
            }
        %>
        <%
            try {
                ensureTablesExist();
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                out.println("<p class='message error'>Error: " + e.getMessage() + "</p>");
                return;
            }

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                Enumeration<String> parameterNames = request.getParameterNames();
                boolean allInserted = true;
                boolean errorOccurred = false;
                StringBuilder errorMsg = new StringBuilder();

                while (parameterNames.hasMoreElements()) {
                    String paramName = parameterNames.nextElement();
                    if (paramName.startsWith("question")) {
                        String paramValue = request.getParameter(paramName);

                        if (paramValue == null || paramValue.isEmpty() || "none".equals(paramValue)) {
                            continue;  // Skip processing this question if it wasn't answered
                        }

                        int questionId = Integer.parseInt(paramName.replace("question", ""));
                        int selectedOption = Integer.parseInt(paramValue);

                        try {
                            boolean inserted = saveUserSelection(questionId, selectedOption);
                            if (!inserted) {
                                allInserted = false;
                                errorMsg.append("Failed to save answer for question ID: ").append(questionId).append("<br>");
                            }
                        } catch (SQLException | ClassNotFoundException e) {
                            errorOccurred = true;
                            errorMsg.append("Error: ").append(e.getMessage()).append("<br>");
                        }
                    }
                }

                if (allInserted && !errorOccurred) {
                    response.sendRedirect("computers_results.jsp");
                } else {
                    out.println("<p class='message error'>");
                    out.println("Some answers could not be saved:<br>");
                    out.println(errorMsg.toString());
                    out.println("</p>");
                }
            }

            Connection con = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                con = getConnection();
                stmt = con.createStatement();
                String sql = "SELECT * FROM computer_questions";
                rs = stmt.executeQuery(sql);

                while (rs.next()) {
                    int questionId = rs.getInt("question_id");
                    String question = rs.getString("question");
                    String opt1 = rs.getString("opt1");
                    String opt2 = rs.getString("opt2");
                    String opt3 = rs.getString("opt3");
                    String opt4 = rs.getString("opt4");
        %>
                    <div class="question">
                        <h3><%= question %></h3>
                        <div class="options">
                            <ul>
                                <li><input type="radio" name="question<%= questionId %>" value="1"> <%= opt1 %></li>
                                <li><input type="radio" name="question<%= questionId %>" value="2"> <%= opt2 %></li>
                                <li><input type="radio" name="question<%= questionId %>" value="3"> <%= opt3 %></li>
                                <li><input type="radio" name="question<%= questionId %>" value="4"> <%= opt4 %></li>
                            </ul>
                            <input type="hidden" name="question<%= questionId %>" value="none"> <!-- Hidden input for default value -->
                        </div>
                    </div>
        <%
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                out.println("<p class='message error'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            }
        %>
            <div class="submit-button">
                <button type="button" onclick="submitAnswers()">Submit Answers</button>
            </div>
        </form>
    </div>
</body>
</html>
