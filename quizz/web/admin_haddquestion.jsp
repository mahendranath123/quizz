<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Add Question</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: auto;
            overflow: hidden;
        }
        header {
            background: #9a4292;
            color: #fff;
            padding-top: 30px;
            min-height: 70px;
            border-bottom: #9a4292 3px solid;
        }
        header a {
            color: #fff;
            text-decoration: none;
            text-transform: uppercase;
            font-size: 16px;
        }
        header ul {
            padding: 0;
            list-style: none;
        }
        header li {
            float: left;
            display: inline;
            padding: 0 20px 0 20px;
        }
        header #branding {
            float: left;
        }
        header #branding h1 {
            margin: 0;
        }
        header nav {
            float: right;
            margin-top: 10px;
        }
        .form-container {
            background: #fff;
            padding: 20px;
            margin-top: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-container h2 {
            margin-top: 0;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .form-group textarea {
            height: 150px;
        }
        .form-group button {
            background: #9a4292;
            color: #fff;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .form-group button:hover {
            background: #7d3478;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #333;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .options ul {
            list-style-type: none;
            padding: 0;
        }
        .options ul li {
            background: #9a4292;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 5px;
            color: #fff;
            cursor: pointer;
            transition: background 0.3s, color 0.3s;
        }
        .options ul li:hover {
            background: #7d3478;
        }
        .options ul li.selected {
            background: #28a745;
            color: #fff;
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.options ul li').forEach(option => {
                option.addEventListener('click', function () {
                    document.querySelectorAll('.options ul li').forEach(opt => opt.classList.remove('selected'));
                    this.classList.add('selected');
                    document.getElementById('correctOption').value = this.getAttribute('data-option');
                });
            });
        });
    </script>
</head>
<body>
    <header>
        <div class="container">
            <div id="branding">
                <h1>Admin Dashboard</h1>
            </div>
            
        </div>
    </header>

    <div class="container">
        <div class="form-container">
            <h2>Add New Question</h2>
            <form action="admin_addquestion.jsp" method="post">
                <div class="form-group">
                    <label for="question">Question:</label>
                    <textarea id="question" name="question" required></textarea>
                </div>
                <div class="form-group">
                    <label for="option1">Option 1:</label>
                    <input type="text" id="option1" name="option1" required>
                </div>
                <div class="form-group">
                    <label for="option2">Option 2:</label>
                    <input type="text" id="option2" name="option2" required>
                </div>
                <div class="form-group">
                    <label for="option3">Option 3:</label>
                    <input type="text" id="option3" name="option3" required>
                </div>
                <div class="form-group">
                    <label for="option4">Option 4:</label>
                    <input type="text" id="option4" name="option4" required>
                </div>
                <div class="form-group">
                    <label for="correctOption">Correct Option (1-4):</label>
                    <input type="text" id="correctOption" name="correctOption" required readonly>
                </div>
                <div class="form-group">
                    <button type="submit">Add Question</button>
                </div>
            </form>
            <a class="back-link" href="admin_page.jsp">Back to Dashboard</a>
        </div>
    </div>

    <%!
        
        public Connection connect() {
            Connection con = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz", "root", "root");
            } catch (Exception e) {
                e.printStackTrace();
            }
            return con;
        }    
    %>
    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            Connection con = connect();
            String question = request.getParameter("question");
            String option1 = request.getParameter("option1");
            String option2 = request.getParameter("option2");
            String option3 = request.getParameter("option3");
            String option4 = request.getParameter("option4");
            String correctOption = request.getParameter("correctOption");

            if (con != null && question != null && option1 != null && option2 != null && option3 != null && option4 != null && correctOption != null) {
                String sql = "INSERT INTO  health_questions(question, opt1, opt2, opt3, opt4, optcorrect) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setString(1, question);
                    pstmt.setString(2, option1);
                    pstmt.setString(3, option2);
                    pstmt.setString(4, option3);
                    pstmt.setString(5, option4);
                    pstmt.setString(6, correctOption);

                    pstmt.executeUpdate();
                    out.println("Question added successfully.");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    out.println("Database error: " + ex.getMessage());
                } finally {
                    try {
                        con.close();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
            } else {
                out.println("Please fill in all fields.");
            }
        }
    %>
</body>
</html>
