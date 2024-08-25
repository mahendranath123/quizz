<%-- 
    Document   : sign
    Created on : 28-Apr-2024, 5:37:23 pm
    Author     : mahen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sign-up Page</title>
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
            background-color: #682A6A;
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
        input[type="email"],
        input[type="date"],
        input[type="submit"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 5px 0;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .radio-group {
            display: flex;
            align-items: center;
        }

        .radio-group label {
            margin-right: 10px;
            margin-left: 5px;
        }

        input[type="submit"] {
            background-color: #6a1b9a;
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

       .footer {
            background: #333;
            color: #fff;
            padding: 20px 0;
            text-align: center;
            position: relative;
            bottom: 0;
            width: 100%;
        }
        .footer .footer-content {
            display: flex;
            justify-content: space-around;
            padding: 20px;
        }
        .footer .footer-section {
            flex: 1;
            padding: 10px;
        }
        .footer .footer-bottom {
            background: #222;
            color: #aaa;
            padding: 10px 0;
            text-align: center;
        }
        .footer .footer-section h2 {
            margin-bottom: 15px;
        }
        .footer .footer-section ul {
            list-style: none;
            padding: 0;
        }
        .footer .footer-section ul li {
            margin-bottom: 10px;
        }
        .footer .footer-section ul li a {
            color: #bbb;
            text-decoration: none;
        }
        .footer .footer-section ul li a:hover {
            color: #fff;
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
            var name = document.forms["signupForm"]["t1"].value;
            var lastName = document.forms["signupForm"]["t2"].value;
            var password = document.forms["signupForm"]["t3"].value;
            var confirmPassword = document.forms["signupForm"]["t4"].value;
            var email = document.forms["signupForm"]["t5"].value;
            var mobile = document.forms["signupForm"]["t6"].value;
            var birthDate = document.forms["signupForm"]["t7"].value;
            var gender = document.forms["signupForm"]["gender"].value;

            var namePattern = /^[A-Za-z]+$/;
            var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
            var mobilePattern = /^[0-9]{10}$/;

            if (name == "" || lastName == "" || password == "" || confirmPassword == "" || email == "" || mobile == "" || birthDate == "" || gender == "") {
                alert("All fields must be filled out");
                return false;
            }

            if (!namePattern.test(name)) {
                alert("Name must contain only alphabets");
                return false;
            }

            if (!namePattern.test(lastName)) {
                alert("Last Name must contain only alphabets");
                return false;
            }

            if (password != confirmPassword) {
                alert("Passwords do not match");
                return false;
            }

            if (!emailPattern.test(email)) {
                alert("Invalid email format");
                return false;
            }

            if (!mobilePattern.test(mobile)) {
                alert("Invalid mobile number format. It should be 10 digits");
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

        function restrictMobileInput(event) {
            var input = event.target;
            if (input.value.length > 10) {
                input.value = input.value.slice(0, 10);
            }
        }
    </script>
</head>

<body>
    <nav>
        <a href="index.html" class="logo">Quizz</a>
        <ul>
            <li><a href="about.html">About</a></li>
           
            <li><a href="sign.jsp">Signup</a></li>
            <li><a href="login.jsp">Login</a></li>
        </ul>
    </nav>
    <div class="container">
        <h1>Registration Form</h1>
        <form name="signupForm" method="post" onsubmit="return validateForm()">
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
            <% } %>
            <table>
                <tr>
                    <td>Enter a Name</td>
                    <td><input type="text" name="t1" oninput="this.value = this.value.replace(/[^A-Za-z]/g, '')"></td>
                </tr>
                <tr>
                    <td>Enter a Last Name</td>
                    <td><input type="text" name="t2" oninput="this.value = this.value.replace(/[^A-Za-z]/g, '')"></td>
                </tr>
                <tr>
                    <td>Enter a password</td>
                    <td><input type="password" name="t3"></td>
                </tr>
                <tr>
                    <td>Enter a confirm password</td>
                    <td><input type="password" name="t4"></td>
                </tr>
                <tr>
                    <td>Enter an Email id</td>
                    <td><input type="email" name="t5"></td>
                </tr>
                <tr>
                    <td>Enter a mobile no</td>
                    <td><input type="text" name="t6" oninput="restrictMobileInput(event)" maxlength="10"></td>
                </tr>
                <tr>
                    <td>Enter a birth date</td>
                    <td><input type="date" name="t7"></td>
                </tr>
                <tr>
                    <td>Select a gender</td>
                    <td class="radio-group">
                        <label><input type="radio" name="gender" value="Male"> Male</label>
                        <label><input type="radio" name="gender" value="Female"> Female</label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" value="Submit"></td>
                </tr>
            </table>
        </form>
    </div>
    <footer class="footer" id="footer">
        <div class="footer-content">
            <div class="footer-section about">
                <h2>About Us</h2>
                <p>Quizz is an innovative platform designed to enhance learning through engaging quizzes. Our mission is to make learning fun and effective for everyone.</p>
            </div>
            <div class="footer-section links">
                <h2>Quick Links</h2>
                <ul>
                    <li><a href="index.html">Home</a></li>
                    <li><a href="about.html">About</a></li>
                    
                    
                </ul>
            </div>
            <div class="footer-section contact">
                <h2>Contact Us</h2>
                <p>Email: support@quizz.com</p>
                <p>Phone: +123-456-7890</p>
                <p>Address: 123 Learning Street, Quiz City, QC 12345</p>
            </div>
        </div>
        <div class="footer-bottom">
            &copy; 2024 Quizz | Designed by Quizz Team
        </div>
    </footer>

    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <p id="modal-content"></p>
        </div>
    </div>

    <%!
        Connection con;

        public Connection reg() {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz", "root", "root");
                return con;
            } catch (Exception e) {
                System.out.print(e);
                return null;
            }
        }
    %>
    <%
        Connection con = reg();
        String a, b, c, d, e, f, g, cp;
        a = request.getParameter("t1");
        b = request.getParameter("t2");
        c = request.getParameter("t3");
        cp = request.getParameter("t4");
        d = request.getParameter("t5");
        e = request.getParameter("t6");
        f = request.getParameter("t7");
        g = request.getParameter("gender");

        PreparedStatement pstmt = null;
        String errorMessage = null;

        try {
            if (a != null && b != null && c != null && cp != null && d != null && e != null && f != null && g != null) {
                if (!c.equals(cp)) {
                    errorMessage = "Passwords do not match.";
                } else {
                    String namePattern = "^[A-Za-z]+$";
                    String emailPattern = "^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$";
                    String mobilePattern = "^[0-9]{10}$";

                    if (!a.matches(namePattern)) {
                        errorMessage = "Name must contain only alphabets.";
                    } else if (!b.matches(namePattern)) {
                        errorMessage = "Last Name must contain only alphabets.";
                    } else if (!d.matches(emailPattern)) {
                        errorMessage = "Invalid email format.";
                    } else if (!e.matches(mobilePattern)) {
                        errorMessage = "Invalid mobile number format.";
                    } else {
                        String sql = "INSERT INTO reg (name, lastnm, passwd, email, mobileno, birth, gender) VALUES (?, ?, ?, ?, ?, ?, ?)";
                        pstmt = con.prepareStatement(sql);
                        pstmt.setString(1, a);
                        pstmt.setString(2, b);
                        pstmt.setString(3, c);
                        pstmt.setString(4, d);
                        pstmt.setString(5, e);
                        pstmt.setString(6, f);
                        pstmt.setString(7, g);

                        pstmt.executeUpdate();
                        out.println("<script>showModal('Successfully registered');</script>");
                    }
                }
            } else {
                errorMessage = "All fields must be filled out.";
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            errorMessage = "Database error: " + ex.getMessage();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
        }
    %>
</body>

</html>
