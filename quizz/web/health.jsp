<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Health Quiz Page</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e0f7fa;
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
            color: #00796b;
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
            border: 2px solid #00796b;
            transition: all 0.3s ease;
        }
        .question:hover {
            border-color: #004d40;
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
            background: #00796b;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s;
            font-size: 1em;
        }
        button:hover {
            background: #004d40;
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
                    question.querySelector('.options input[type="radio"]').value = 'none'; // Set value to 'none' for unselected questions
                }
            });
            document.getElementById('quizForm').submit();
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Health Quiz</h1>
        <div class="timer" id="timer">00:50</div>
        <form id="quizForm"  method="post">
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
                    String sql = "INSERT INTO healthuser_answers (question_id, selected_option) VALUES (?, ?) ON DUPLICATE KEY UPDATE selected_option = VALUES(selected_option)";
                    pstmt = con.prepareStatement(sql);
                    pstmt.setInt(1, questionId);
                    if (selectedOption == 0) {
                        pstmt.setNull(2, Types.INTEGER); // Handle the case where no option was selected
                    } else {
                        pstmt.setInt(2, selectedOption);
                    }
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
        %>
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                Enumeration<String> parameterNames = request.getParameterNames();
                boolean allInserted = true;
                boolean errorOccurred = false;
                StringBuilder errorMsg = new StringBuilder();

                while (parameterNames.hasMoreElements()) {
                    String paramName = parameterNames.nextElement();
                    if (paramName.startsWith("question")) {
                        int questionId = Integer.parseInt(paramName.replace("question", ""));
                        int selectedOption = request.getParameter(paramName).equals("none") ? 0 : Integer.parseInt(request.getParameter(paramName));
                        try {
                            boolean inserted = saveUserSelection(questionId, selectedOption);
                            if (!inserted) {
                                allInserted = false;
                            }
                        } catch (Exception e) {
                            allInserted = false;
                            errorOccurred = true;
                            errorMsg.append("Error inserting for question ").append(questionId).append(": ").append(e.getMessage()).append("<br>");
                        }
                    }
                }

                if (allInserted) {
                    response.sendRedirect("health_results.jsp"); 
                    return;
                } else {
                    if (errorOccurred) {
                        out.println("<p class='message error'>Insert failed for some answers:<br>" + errorMsg.toString() + "</p>");
                    } else {
                        out.println("<p class='message error'>Insert failed for some answers</p>");
                    }
                }
            }
        %>
        <%
            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                con = getConnection();
                String sql = "SELECT * FROM health_questions";
                pstmt = con.prepareStatement(sql);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    int questionId = rs.getInt("question_id");
                    String question = rs.getString("question");
                    String option1 = rs.getString("opt1");
                    String option2 = rs.getString("opt2");
                    String option3 = rs.getString("opt3");
                    String option4 = rs.getString("opt4");

                    out.println("<div class='question' id='question" + questionId + "'>");
                    out.println("<h3>" + question + "</h3>");
                    out.println("<div class='options'><ul>");
                    out.println("<li><label><input type='radio' name='question" + questionId + "' value='1'> " + option1 + "</label></li>");
                    out.println("<li><label><input type='radio' name='question" + questionId + "' value='2'> " + option2 + "</label></li>");
                    out.println("<li><label><input type='radio' name='question" + questionId + "' value='3'> " + option3 + "</label></li>");
                    out.println("<li><label><input type='radio' name='question" + questionId + "' value='4'> " + option4 + "</label></li>");
                    out.println("</ul></div>");
                    out.println("</div>");
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
        <div style="text-align: center; margin-top: 30px;">
            <button type="button" onclick="submitAnswers()">Submit</button>
        </div>
        </form>
    </div>
</body>
</html>
