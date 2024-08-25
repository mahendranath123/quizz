<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Student Results</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            transition: transform 0.3s ease;
            transform-origin: top center;
        }
        .container {
            text-align: center;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 900px;
            width: 100%;
            overflow: hidden;
        }
        h1 {
            margin-bottom: 20px;
            color: #333;
            font-size: 2.5rem;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        .score-summary {
            margin: 20px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .score-summary div {
            background: #e9e9e9;
            border-radius: 10px;
            padding: 20px;
            width: 22%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        .score-summary div:hover {
            transform: translateY(-5px);
        }
        .score-summary div h2 {
            margin: 0;
            color: #9a4292;
            font-size: 1.5rem;
        }
        .score-summary div p {
            font-size: 1.2rem;
            margin: 10px 0;
        }
        .report-card {
            margin-top: 20px;
        }
        .report-details table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 20px;
        }
        .report-details th, .report-details td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        .report-details th {
            background: #9a4292;
            color: #fff;
        }
        .report-details tr:nth-child(even) {
            background: #f2f2f2;
        }
        .correct td {
            background-color: #d4edda !important;
            color: #155724;
        }
        .wrong td {
            background-color: #f8d7da !important;
            color: #721c24;
        }
        .correct-answer {
            font-weight: bold;
            color: #155724;
        }
        .selected-correct {
            background-color: #d4edda;
            font-weight: bold;
        }
        .review-button {
            background-color: #9a4292;
            color: white;
            border: none;
            padding: 15px 30px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 20px 2px;
            cursor: pointer;
            border-radius: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        .review-button:hover {
            background-color: #81267a;
            box-shadow: 0 8px 10px rgba(0, 0, 0, 0.2);
        }
        .review-questions {
            display: none;
        }
        /* Media query for zoomed display */
        @media screen and (max-width: 1024px) {
            body {
                transform: scale(1.1); /* Adjust the scale as needed */
            }
        }
        @media screen and (max-width: 1440px) {
            body {
                transform: scale(1.2); /* Adjust the scale as needed */
            }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <%
        String url = "jdbc:mysql://localhost:3306/quiz";
        String user = "root";
        String password = "root";
        int totalQuestions = 0;
        int correctCount = 0;
        int wrongCount = 0;
        List<Map<String, Object>> questionDetails = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to the database successfully.");

            // Get all questions
            PreparedStatement allQuestionsStmt = conn.prepareStatement("SELECT * FROM questions");
            ResultSet allQuestionsRs = allQuestionsStmt.executeQuery();

            // Get user answers
            PreparedStatement userAnswersStmt = conn.prepareStatement(
                "SELECT ua.question_id, ua.selected_option, q.correct_option, q.question, q.opt1, q.opt2, q.opt3, q.opt4 " +
                "FROM questions q " +
                "LEFT JOIN user_answers ua ON q.question_id = ua.question_id AND ua.id IN (SELECT MAX(id) FROM user_answers GROUP BY question_id)"
            );
            ResultSet userAnswersRs = userAnswersStmt.executeQuery();

            while (userAnswersRs.next()) {
                int questionId = userAnswersRs.getInt("question_id");
                String question = userAnswersRs.getString("question");
                int selectedOption = userAnswersRs.getInt("selected_option");
                int correctOption = userAnswersRs.getInt("correct_option");
                String opt1 = userAnswersRs.getString("opt1");
                String opt2 = userAnswersRs.getString("opt2");
                String opt3 = userAnswersRs.getString("opt3");
                String opt4 = userAnswersRs.getString("opt4");

                if (userAnswersRs.wasNull()) {
                    selectedOption = -1; // No answer provided
                }

                Map<String, Object> questionDetail = new HashMap<>();
                questionDetail.put("question", question);
                questionDetail.put("selectedOption", selectedOption);
                questionDetail.put("correctOption", correctOption);
                questionDetail.put("opt1", opt1);
                questionDetail.put("opt2", opt2);
                questionDetail.put("opt3", opt3);
                questionDetail.put("opt4", opt4);

                if (selectedOption == correctOption) {
                    correctCount++;
                } else {
                    wrongCount++;
                }

                questionDetails.add(questionDetail);
                totalQuestions++;
            }

            userAnswersRs.close();
            userAnswersStmt.close();
            allQuestionsRs.close();
            allQuestionsStmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        int percentage = (int) ((double) correctCount / totalQuestions * 100);
    %>
    <div class="container">
        <h1>Scores</h1>
        <div class="score-summary">
            <div>
                <h2>Total Questions</h2>
                <p><%= totalQuestions %></p>
            </div>
            <div>
                <h2>Correct Answers</h2>
                <p><%= correctCount %></p>
            </div>
            <div>
                <h2>Wrong Answers</h2>
                <p><%= wrongCount %></p>
            </div>
            <div>
                <h2>Percentage</h2>
                <p><%= percentage %> %</p>
                <canvas id="scoreChart" width="50" height="50"></canvas>
            </div>
        </div>
        <button class="review-button" onclick="toggleReviewQuestions()">Review Questions</button>
        <div class="report-card">
            <div class="report-details">
                <div class="review-questions">
                    <h2>Review Questions</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Question</th>
                                <th>Selected Option</th>
                                <th>Correct Option</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Map<String, Object> questionDetail : questionDetails) {
                                    String question = (String) questionDetail.get("question");
                                    int selectedOption = (int) questionDetail.get("selectedOption");
                                    int correctOption = (int) questionDetail.get("correctOption");
                                    String opt1 = (String) questionDetail.get("opt1");
                                    String opt2 = (String) questionDetail.get("opt2");
                                    String opt3 = (String) questionDetail.get("opt3");
                                    String opt4 = (String) questionDetail.get("opt4");

                                    String selectedOptionText = "None";
                                    if (selectedOption == 1) selectedOptionText = opt1;
                                    else if (selectedOption == 2) selectedOptionText = opt2;
                                    else if (selectedOption == 3) selectedOptionText = opt3;
                                    else if (selectedOption == 4) selectedOptionText = opt4;

                                    String correctOptionText = "None";
                                    if (correctOption == 1) correctOptionText = opt1;
                                    else if (correctOption == 2) correctOptionText = opt2;
                                    else if (correctOption == 3) correctOptionText = opt3;
                                    else if (correctOption == 4) correctOptionText = opt4;
                            %>
                            <tr class="<%= (selectedOption == correctOption) ? "correct" : "wrong" %>">
                                <td><%= question %></td>
                                <td><%= selectedOptionText %></td>
                                <td><%= correctOptionText %></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script>
        const toggleReviewQuestions = () => {
            const reviewQuestions = document.querySelector('.review-questions');
            reviewQuestions.style.display = reviewQuestions.style.display === 'none' ? 'block' : 'none';
        };

        const ctx = document.getElementById('scoreChart').getContext('2d');
        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Correct', 'Wrong'],
                datasets: [{
                    data: [<%= correctCount %>, <%= wrongCount %>],
                    backgroundColor: ['#28a745', '#dc3545'],
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                }
            }
        });
    </script>
</body>
</html>
