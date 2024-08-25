<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            width: 80%;
            margin: auto;
            overflow: hidden;
        }
        header {
            background: #4B0052;
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
        .section {
            padding: 20px;
            background: #fff;
            margin-top: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .section h2 {
            margin-top: 0;
            color: #4B0052;
        }
        .section a {
            display: block;
            margin: 10px 0;
            color: #fff;
            text-decoration: none;
            padding: 10px;
            background: #9a4292;
            border-radius: 5px;
            text-align: center;
            transition: background-color 0.3s ease;
        }
        .section a:hover {
            background: #4B0052;
        }
        .login {
            float: right;
            margin-top: 10px;
            color: #fff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            background: #9a4292;
            transition: background-color 0.3s ease;
        }
        .login:hover {
            background: #4B0052;
        }
        .hidden {
            display: none;
        }
    </style>
    <script>
        function showSection(sectionId) {
            const sections = document.querySelectorAll('.section');
            sections.forEach(section => {
                if (section.id === sectionId) {
                    section.classList.remove('hidden');
                } else {
                    section.classList.add('hidden');
                }
            });
        }
    </script>
</head>
<body>
    <header>
        <div class="container">
            <div id="branding">
                <h1>Admin Dashboard</h1>
            </div>
            <nav>
                <a class="login" href="login.jsp">Back</a>
            </nav>
        </div>
    </header>
    <div class="container">
        <div id="dashboardSection" class="section">
            <h2>Welcome, Admin</h2>
            <a href="#" onclick="showSection('mathSection')">Math</a>
            <a href="#" onclick="showSection('scienceSection')">Science</a>
<!--            <a href="#" onclick="showSection('computersSection')">Computers</a>-->
            <a href="#" onclick="showSection('financeSection')">Finance</a>
            <a href="#" onclick="showSection('socialStudiesSection')">Social Studies</a>
<!--            <a href="#" onclick="showSection('healthSection')">Health</a>-->
        </div>
        
        <!-- Math Section -->
        <div id="mathSection" class="section hidden">
            <h2>Math Management</h2>
            <a href="#" onclick="showSection('dashboardSection')">Back to Dashboard</a>
            <a href="admin_mathaddquestion.jsp?subject=math">Add Question</a>
            <a href="admin_mathupdatequestion.jsp?subject=math">Update Question</a>
            <a href="admin_mathdeletequestion.jsp?subject=math">Delete Question</a>
            <a href="admin_mathview.jsp?subject=math">View Questions</a>
        </div>

        <!-- Science Section -->
        <div id="scienceSection" class="section hidden">
            <h2>Science Management</h2>
            <a href="#" onclick="showSection('dashboardSection')">Back to Dashboard</a>
            <a href="admin_scaddquestion.jsp?subject=science">Add Question</a>
            <a href="admin_scupdatequestion.jsp?subject=science">Update Question</a>
            <a href="admin_scdeletequestion.jsp?subject=science">Delete Question</a>
            <a href="admin_scview.jsp?subject=science">View Questions</a>
        </div>

        <!-- Computers Section -->
<!--        <div id="computersSection" class="section hidden">
            <h2>Computers Management</h2>
            <a href="#" onclick="showSection('dashboardSection')">Back to Dashboard</a>
            <a href="admin_comaddquestion.jsp?subject=computers">Add Question</a>
            <a href="admin_comupdatequestion.jsp?subject=computers">Update Question</a>
            <a href="admin_comdeletequestion.jsp?subject=computers">Delete Question</a>
            <a href="admin_comview.jsp?subject=computers">View Questions</a>
        </div>-->

        <!-- Finance Section -->
        <div id="financeSection" class="section hidden">
            <h2>Finance Management</h2>
            <a href="#" onclick="showSection('dashboardSection')">Back to Dashboard</a>
            <a href="admin_addquestion.jsp?subject=finance">Add Question</a>
            <a href="admin_updatequestion.jsp?subject=finance">Update Question</a>
            <a href="admin_deletequestion.jsp?subject=finance">Delete Question</a>
            <a href="admin_view.jsp?subject=finance">View Questions</a>
        </div>

        <!-- Social Studies Section -->
        <div id="socialStudiesSection" class="section hidden">
            <h2>Social Studies Management</h2>
            <a href="#" onclick="showSection('dashboardSection')">Back to Dashboard</a>
            <a href="admin_ssaddquestion.jsp?subject=social_studies">Add Question</a>
            <a href="admin_ssupdatequestion.jsp?subject=social_studies">Update Question</a>
            <a href="admin_ssdeletequestion.jsp?subject=social_studies">Delete Question</a>
            <a href="admin_ssview.jsp?subject=social_studies">View Questions</a>
        </div>

        <!-- Health Section -->
<!--        <div id="healthSection" class="section hidden">
            <h2>Health Management</h2>
            <a href="#" onclick="showSection('dashboardSection')">Back to Dashboard</a>
            <a href="admin_haddquestion.jsp?subject=health">Add Question</a>
            <a href="admin_hupdatequestion.jsp?subject=health">Update Question</a>
            <a href="admin_hdeletequestion.jsp?subject=health">Delete Question</a>
            <a href="admin_hview.jsp?subject=health">View Questions</a>
        </div>-->
    </div>
</body>
</html>
