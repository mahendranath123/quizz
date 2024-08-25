<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>View Math Questions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            height: 100vh;
            overflow: auto;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .container {
            text-align: center;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            max-width: 900px;
            width: 100%;
            margin-top: 20px;
            overflow: auto;
        }

        h1 {
            margin: 0;
            padding: 20px 0;
            color: #333;
            font-size: 2em;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 20px;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: #9a4292;
            color: #fff;
            position: sticky;
            top: 0;
            z-index: 2;
        }

        tr:nth-child(even) {
            background: #f2f2f2;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>All Math Questions</h1>
        <table>
            <thead>
                <tr>
                    <th>Question Number</th>
                    <th>Question</th>
                    <th>Option 1</th>
                    <th>Option 2</th>
                    <th>Option 3</th>
                    <th>Option 4</th>
                    <th>Correct Option</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String url = "jdbc:mysql://localhost:3306/quiz";
                    String user = "root";
                    String password = "root";

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        try (Connection conn = DriverManager.getConnection(url, user, password);
                             Statement stmt = conn.createStatement();
                             ResultSet rs = stmt.executeQuery("SELECT * FROM math_questions")) {
                            
                            while (rs.next()) {
                                int questionId = rs.getInt("question_id");
                                String question = rs.getString("question");
                                String option1 = rs.getString("opt1");
                                String option2 = rs.getString("opt2");
                                String option3 = rs.getString("opt3");
                                String option4 = rs.getString("opt4");
                                String correctOption = rs.getString("correct_option");
                %>
                <tr>
                    <td><%= questionId %></td>
                    <td><%= question %></td>
                    <td><%= option1 %></td>
                    <td><%= option2 %></td>
                    <td><%= option3 %></td>
                    <td><%= option4 %></td>
                    <td><%= correctOption %></td>
                </tr>
                <%
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
        <a class="back-link" href="admin_page.jsp">Back to Dashboard</a>
    </div>
</body>
</html>