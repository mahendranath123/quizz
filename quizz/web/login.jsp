<%-- 
    Document   : login
    Created on : 04-Jun-2024, 5:13:28 pm
    Author     : mahen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login Page</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: #F3F3F3;
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
            padding: 2rem;
            margin-top: 80px;
            text-align: center;
            flex: 1;
        }

        h1 {
            color: #5a5a5a;
            margin-bottom: 20px;
            font-size: 2.5rem;
        }

        form {
            background-color: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: 0 auto;
        }

        table {
            width: 100%;
            margin-bottom: 1.5rem;
        }

        td {
            padding: 10px;
            text-align: left;
        }

        input[type="text"],
        input[type="password"],
        input[type="submit"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 5px 0;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type="submit"] {
            background-color: #4B0052;
            color: white;
            border: none;
            cursor: pointer;
            width: calc(100% - 20px);
        }

        input[type="submit"]:hover {
            background-color: #4b0082;
        }

        .error-message {
            color: red;
            font-weight: bold;
            margin-bottom: 15px;
        }

        footer {
            background-color: black;
            color: white;
            text-align: center;
            padding: 20px 0;
            margin-top: auto;
        }

        footer p {
            margin: 5px 0;
        }

        footer a {
            color: #FFD700;
            text-decoration: none;
        }

        footer a:hover {
            text-decoration: underline;
        }

        .social-media {
            margin: 10px 0;
        }

        .social-media a {
            margin: 0 10px;
            text-decoration: none;
            color: #FFD700;
            display: inline-block;
        }

        .social-media a img {
            width: 30px;
            height: 30px;
            vertical-align: middle;
        }

        .social-media a:hover img {
            filter: brightness(0.8);
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1001;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            border-radius: 8px;
            text-align: center;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
    <script>
        function validateForm() {
            var email = document.forms["loginForm"]["t1"].value;
            var password = document.forms["loginForm"]["p1"].value;
            var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
            var passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

            if (email == "" || password == "") {
                alert("All fields must be filled out");
                return false;
            }

            if (!emailPattern.test(email)) {
                alert("Invalid email format");
                return false;
            }

            if (!passwordPattern.test(password)) {
                alert("Password must be at least 8 characters long, contain letters and numbers");
                return false;
            }

            return true;
        }

        function showModal(message) {
            var modal = document.getElementById("myModal");
            var modalContent = document.getElementById("modal-content");
            modalContent.innerText = message;
            modal.style.display = "block";
        }

        function closeModal() {
            var modal = document.getElementById("myModal");
            modal.style.display = "none";
        }
    </script>
</head>
<body>
    <nav>
        <a href="index.html" class="logo">Quizz</a>
        <ul>
            <li><a href="sign.jsp">Sign up</a></li>
        </ul>
    </nav>

    <div class="container">
        <h1>Login</h1>
        <form method="post" onsubmit="return validateForm()" name="loginForm">
            <table>
                <tr>
                    <td><label for="email">Email:</label></td>
                    <td><input type="text" id="email" name="t1"></td>
                </tr>
                <tr>
                    <td><label for="password">Password:</label></td>
                    <td><input type="password" id="password" name="p1"></td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" value="Login"></td>
                </tr>
            </table>
        </form>
    </div>

    

<%!
    Connection con;

    public Connection reg() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz", "root", "root");
            System.out.println("Connection established!");
            return con;
        } catch (Exception e) {
            System.out.print(e);
            return null;
        }
    }
%>
<%
    String email = request.getParameter("t1");
    String password = request.getParameter("p1");
    Connection con = reg();

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        if (email != null && password != null) {
            if (email.equals("admin@gmail.com") && password.equals("admin123")) {
                request.setAttribute("message", "Valid username and password");
                response.sendRedirect("admin_page.jsp");
            } else {
                String sql = "SELECT * FROM reg WHERE email = ? AND passwd = ?";
                pstmt = con.prepareStatement(sql);
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    request.setAttribute("message", "Valid username and password");
                    response.sendRedirect("start.jsp");
                } else {
                    request.setAttribute("message", "Invalid username or password");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }
        } else {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</body>
</html>
