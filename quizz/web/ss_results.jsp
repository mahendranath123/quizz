<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Social Studies Quiz Results</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
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

            // Get user answers and correct answers for the social studies quiz
            PreparedStatement userAnswersStmt = conn.prepareStatement(
                "SELECT ssq.question_id, ssq.question, ssq.correct_option, ssq.opt1, ssq.opt2, ssq.opt3, ssq.opt4, COALESCE(ua.selected_option, 0) AS selected_option " +
                "FROM social_studies_questions ssq " +
                "LEFT JOIN ssuser_answers ua ON ssq.question_id = ua.question_id AND ua.user_answer_id = (SELECT MAX(user_answer_id) FROM ssuser_answers WHERE question_id = ssq.question_id)"
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

                Map<String, Object> questionDetail = new HashMap<>();
                questionDetail.put("question", question);
                questionDetail.put("selectedOption", selectedOption);
                questionDetail.put("correctOption", correctOption);
                questionDetail.put("opt1", opt1);
                questionDetail.put("opt2", opt2);
                questionDetail.put("opt3", opt3);
                questionDetail.put("opt4", opt4);

                String selectedOptionText = "None";
                if (selectedOption != 0) {
                    switch (selectedOption) {
                        case 1: selectedOptionText = opt1; break;
                        case 2: selectedOptionText = opt2; break;
                        case 3: selectedOptionText = opt3; break;
                        case 4: selectedOptionText = opt4; break;
                    }
                }

                questionDetail.put("selectedOptionText", selectedOptionText);

                if (selectedOption == 0 || selectedOption != correctOption) {
                    wrongCount++;
                } else {
                    correctCount++;
                }

                questionDetails.add(questionDetail);
                totalQuestions++;
            }

            userAnswersRs.close();
            userAnswersStmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        int percentage = (int) ((double) correctCount / totalQuestions * 100);
    %>
    <div class="container">
        <h1>Social Studies Quiz Results</h1>
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
                <div class="review-questions" style="display:none;">
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
                                    String selectedOptionText = (String) questionDetail.get("selectedOptionText");
                                    int correctOption = (int) questionDetail.get("correctOption");
                                    String correctOptionText = "";
                                    switch (correctOption) {
                                        case 1: correctOptionText = (String) questionDetail.get("opt1"); break;
                                        case 2: correctOptionText = (String) questionDetail.get("opt2"); break;
                                        case 3: correctOptionText = (String) questionDetail.get("opt3"); break;
                                        case 4: correctOptionText = (String) questionDetail.get("opt4"); break;
                                    }

                                    String rowClass = (selectedOptionText.equals(correctOptionText)) ? "correct" : "wrong";
                            %>
                            <tr class="<%= rowClass %>">
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
        function toggleReviewQuestions() {
            const reviewQuestions = document.querySelector('.review-questions');
            reviewQuestions.style.display = reviewQuestions.style.display === 'block' ? 'none' : 'block';
        }

        document.addEventListener('DOMContentLoaded', (event) => {
            const ctx = document.getElementById('scoreChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Correct', 'Wrong'],
                    datasets: [{
                        label: 'Score',
                        data: [<%= correctCount %>, <%= wrongCount %>],
                        backgroundColor: ['#36a2eb', '#ff6384']
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top',
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
