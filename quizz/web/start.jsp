<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Student Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
        }
      nav {
            background-color: #4B0052;
            overflow: hidden;
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }

        nav .logo {
            color: white;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
        }

        nav ul {
            list-style: none;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        nav li {
            margin: 0 15px;
        }

        nav a {
            text-decoration: none;
            color: white;
            font-weight: bold;
            border: 1px solid transparent;
            border-radius: 4px;
            padding: 8px 12px;
        }

        nav a:hover {
            background-color: #4b0082;
        }
        .container {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 900px;
            width: 100%;
            text-align: center;
            margin-top: 80px;
        }
        h1 {
            margin-top: 0;
            color: #333;
            font-size: 2.5em;
        }
        .quiz-list {
            margin-top: 30px;
            text-align: left;
        }
        .quiz-item {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        .quiz-item:hover {
            transform: scale(1.02);
        }
        .quiz-category {
            margin-top: 30px;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .category-item {
            color: white;
            padding: 15px;
            border-radius: 50%;
            text-align: center;
            cursor: pointer;
            width: 80px;
            height: 80px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 14px;
            transition: transform 0.2s;
        }
        .category-item:hover {
            transform: scale(1.1);
        }
        .math { background: #e57373; }
        .science { background: #81c784; }
        .computers { background: #64b5f6; }
        .english { background: #ffb74d; }
        .social-studies { background: #ba68c8; }
        .languages { background: #4db6ac; }
        .career-ed { background: #7986cb; }
        .creative-arts { background: #f06292; }
        .health-pe { background: #aed581; }
    </style>
</head>
<body>
    <nav>
        <a href="index.html" class="logo">Quizz</a>
        <ul>
            <li><a href="login.jsp">Login</a></li>
        </ul>
    </nav>
    </div>
    <div class="container">
        <h1>Pick Your Quiz</h1>
        <div class="quiz-category">
            <a href="math.jsp" class="category-item math">Math</a>
            <a href="science.jsp" class="category-item science">Science</a>

            <a href="question.jsp" class="category-item english">Finance</a>
            <a href="ss.jsp" class="category-item social-studies">Social Studies</a>
        </div>
        <div class="quiz-list" id="quizList">
            
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            loadQuizzes();
        });

        function loadQuizzes() {
            const quizList = document.getElementById('quizList');
            quizList.innerHTML = '';

            <% 
                Connection con = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz", "root", "root");
                    String sql = "SELECT * FROM quizzes";
                    pstmt = con.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        int quizId = rs.getInt("quiz_id");
                        String quizTitle = rs.getString("title");
            %>
                        const quizItem = document.createElement('div');
                        quizItem.className = 'quiz-item';
                        quizItem.innerHTML = '<h3><%= quizTitle %></h3><button onclick="startQuiz(<%= quizId %>)">Start Quiz</button>';
                        quizList.appendChild(quizItem);
            <% 
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                    if (con != null) try { con.close(); } catch (SQLException ignore) {}
                }
            %>
        }

        function startQuiz(quizId) {
            window.location.href = `question.jsp?quizId=${quizId}`;
        }

        function redirectTo(page) {
            window.location.href = page;
        }
    </script>
</body>
</html>
