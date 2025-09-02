<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
final String DB_URL = "jdbc:mysql://localhost:3307/javaflix";
final String DB_USER = "root";
final String DB_PASSWORD = "Harsh$1000Pande";

Connection connection = null;
PreparedStatement preparedStatement = null;
ResultSet resultSet = null;

String mobile = "";
String bio = "";
String username = "";
String email = "";
String userID = (String) session.getAttribute("userID");

String successMsg = (String) request.getAttribute("success");
String errorMsg = (String) request.getAttribute("error");
try {
    connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

    String query = "SELECT * FROM users WHERE userID = ?";
    preparedStatement = connection.prepareStatement(query);

    preparedStatement.setString(1, userID);

    resultSet = preparedStatement.executeQuery();

    if (resultSet.next()) {
        mobile = resultSet.getString("mobile_number");
        bio = resultSet.getString("bio");
        username = resultSet.getString("username");
        email = resultSet.getString("email");
    }

} catch (Exception e) {
    throw new RuntimeException(e);
} finally {
    try {
        if (resultSet != null) resultSet.close();
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaFlix - Settings</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
                   :root {
                       --primary: #e50914;
                       --dark: #141414;
                       --light: #f4f4f4;
                       --gray: #999;
                       --dark-gray: #222;
                       --imdb-yellow: #f5c518;
                   }

                   * {
                       margin: 0;
                       padding: 0;
                       box-sizing: border-box;
                       font-family: 'Poppins', sans-serif;
                   }

                   body {
                       background-color: var(--dark);
                       color: var(--light);
                       min-height: 100vh;
                   }

                   /* Navbar */
                   .navbar {
                       display: flex;
                       justify-content: space-between;
                       align-items: center;
                       padding: 20px 50px;
                       background: linear-gradient(to bottom, rgba(0,0,0,0.9) 0%, rgba(0,0,0,0) 100%);
                       position: fixed;
                       width: 100%;
                       top: 0;
                       z-index: 1000;
                       transition: background 0.3s;
                   }

                   .navbar.scrolled {
                       background: var(--dark);
                       box-shadow: 0 2px 10px rgba(0,0,0,0.5);
                   }

                   .logo {
                       font-size: 28px;
                       font-weight: 700;
                       color: white;
                   }

                   .logo span.java {
                       color: white;
                   }

                   .logo span.flix {
                       color: var(--primary);
                   }

                   .nav-links {
                       display: flex;
                       align-items: center;
                       gap: 30px;
                   }

                   .nav-links a {
                       color: white;
                       text-decoration: none;
                       font-weight: 500;
                       transition: color 0.3s;
                   }

                   .nav-links a:hover {
                       color: var(--primary);
                   }

                   /* Profile Container */
                   .profile-container {
                       position: relative;
                   }

                   .profile-btn {
                       display: flex;
                       align-items: center;
                       gap: 10px;
                       background: none;
                       border: none;
                       color: white;
                       cursor: pointer;
                       padding: 5px 10px;
                       border-radius: 4px;
                       transition: background-color 0.3s;
                   }

                   .profile-btn:hover {
                       background-color: rgba(255, 255, 255, 0.1);
                   }

                   .profile-image {
                       width: 35px;
                       height: 35px;
                       border-radius: 50%;
                       background-color: var(--primary);
                       display: flex;
                       align-items: center;
                       justify-content: center;
                       font-weight: bold;
                   }

                   .profile-dropdown {
                       position: absolute;
                       top: 100%;
                       right: 0;
                       background-color: var(--dark);
                       border-radius: 5px;
                       box-shadow: 0 5px 15px rgba(0,0,0,0.5);
                       width: 180px;
                       padding: 10px 0;
                       opacity: 0;
                       visibility: hidden;
                       transform: translateY(10px);
                       transition: all 0.3s;
                       z-index: 1001;
                   }

                   .profile-dropdown.active {
                       opacity: 1;
                       visibility: visible;
                       transform: translateY(0);
                   }

                   .profile-dropdown a {
                       display: flex;
                       align-items: center;
                       gap: 10px;
                       padding: 10px 15px;
                       color: var(--light);
                       text-decoration: none;
                       transition: background-color 0.3s;
                   }

                   .profile-dropdown a:hover {
                       background-color: rgba(255, 255, 255, 0.1);
                   }

                   .profile-dropdown a.active {
                       color: var(--primary);
                   }

                   /* Hamburger Menu */
                   .hamburger {
                       display: none;
                       cursor: pointer;
                       z-index: 1001;
                       background: none;
                       border: none;
                   }

                   .bar {
                       display: block;
                       width: 25px;
                       height: 3px;
                       margin: 5px auto;
                       background-color: white;
                       transition: all 0.3s ease;
                   }

                   .hamburger.active .bar:nth-child(2) {
                       opacity: 0;
                   }

                   .hamburger.active .bar:nth-child(1) {
                       transform: translateY(8px) rotate(45deg);
                   }

                   .hamburger.active .bar:nth-child(3) {
                       transform: translateY(-8px) rotate(-45deg);
                   }

                   /* Main Content */
                   .main-content {
                       padding: 120px 50px 50px;
                       max-width: 1200px;
                       margin: 0 auto;
                   }

                   .settings-header {
                       display: flex;
                       align-items: center;
                       gap: 15px;
                       margin-bottom: 40px;
                   }

                   .settings-header h1 {
                       font-size: 2.5rem;
                   }

                   .settings-header i {
                       font-size: 2rem;
                       color: var(--primary);
                   }

                   /* Settings Container */
                   .settings-container {
                       display: flex;
                       gap: 40px;
                   }

                   /* Settings Sidebar */
                   .settings-sidebar {
                       flex: 0 0 250px;
                   }

                   .settings-menu {
                       list-style: none;
                       background-color: rgba(0, 0, 0, 0.3);
                       border-radius: 8px;
                       overflow: hidden;
                   }

                   .settings-menu li {
                       border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                   }

                   .settings-menu li:last-child {
                       border-bottom: none;
                   }

                   .settings-menu a {
                       display: flex;
                       align-items: center;
                       gap: 15px;
                       padding: 15px 20px;
                       color: var(--light);
                       text-decoration: none;
                       transition: all 0.3s;
                   }

                   .settings-menu a:hover {
                       background-color: rgba(255, 255, 255, 0.1);
                       color: var(--primary);
                   }

                   .settings-menu a.active {
                       background-color: var(--primary);
                       color: white;
                   }

                   /* Settings Content */
                   .settings-content {
                       flex: 1;
                   }

                   .settings-section {
                       background-color: rgba(0, 0, 0, 0.3);
                       border-radius: 8px;
                       padding: 30px;
                       margin-bottom: 30px;
                   }

                   .settings-section h2 {
                       display: flex;
                       align-items: center;
                       gap: 10px;
                       margin-bottom: 25px;
                       font-size: 1.5rem;
                   }

                   .settings-section h2 i {
                       color: var(--primary);
                   }

                   /* User Info */
                   .user-info {
                       display: flex;
                       align-items: center;
                       gap: 20px;
                       margin-bottom: 30px;
                   }

                   .user-avatar {
                       width: 80px;
                       height: 80px;
                       border-radius: 50%;
                       background-color: var(--primary);
                       display: flex;
                       align-items: center;
                       justify-content: center;
                       font-size: 2rem;
                       font-weight: bold;
                   }

                   .user-details h3 {
                       font-size: 1.5rem;
                       margin-bottom: 5px;
                   }

                   .user-details p {
                       color: var(--gray);
                       font-size: 0.9rem;
                   }

                   /* Forms */
                   .form-row {
                       display: flex;
                       gap: 20px;
                       margin-bottom: 20px;
                   }

                   .form-group {
                       flex: 1;
                       margin-bottom: 20px;
                   }

                   .form-group label {
                       display: block;
                       margin-bottom: 8px;
                       font-weight: 500;
                   }

                   .form-control {
                       width: 100%;
                       padding: 12px 15px;
                       background-color: #333;
                       border: 1px solid #444;
                       border-radius: 5px;
                       color: white;
                       font-size: 1rem;
                       transition: all 0.3s;
                   }

                   .form-control:focus {
                       outline: none;
                       border-color: var(--primary);
                       background-color: #444;
                   }

                   textarea.form-control {
                       resize: vertical;
                       min-height: 100px;
                   }

                   /* Button Group */
                   .btn-group {
                       display: flex;
                       gap: 15px;
                       margin-top: 20px;
                   }

                   .btn {
                       padding: 12px 25px;
                       border-radius: 5px;
                       font-weight: 600;
                       cursor: pointer;
                       transition: all 0.3s;
                       border: none;
                   }

                   .btn {
                       background-color: var(--primary);
                       color: white;
                   }

                   .btn:hover {
                       background-color: #f40612;
                       transform: translateY(-2px);
                   }

                   .btn-outline {
                       background-color: transparent;
                       border: 1px solid var(--gray);
                       color: var(--light);
                   }

                   .btn-outline:hover {
                       border-color: var(--primary);
                       color: var(--primary);
                       transform: translateY(-2px);
                   }

                   /* Danger Zone */
                   .danger-zone {
                       border: 1px solid rgba(229, 9, 20, 0.3);
                   }

                   .danger-zone h3 {
                       display: flex;
                       align-items: center;
                       gap: 10px;
                       color: var(--primary);
                       margin-bottom: 10px;
                   }

                   .danger-zone p {
                       color: var(--gray);
                       margin-bottom: 20px;
                   }

                   /* Notifications */
                   .notification {
                       position: fixed;
                       top: 100px;
                       right: 20px;
                       padding: 15px 25px;
                       border-radius: 5px;
                       box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                       z-index: 1100;
                       display: flex;
                       align-items: center;
                       gap: 10px;
                       opacity: 0;
                       transform: translateX(100%);
                       transition: all 0.3s ease;
                       max-width: 350px;
                   }

                   .notification.show {
                       opacity: 1;
                       transform: translateX(0);
                   }

                   .notification.success {
                       background-color: #4CAF50;
                       color: white;
                   }

                   .notification.error {
                       background-color: var(--primary);
                       color: white;
                   }

                   .close-btn {
                       margin-left: auto;
                       cursor: pointer;
                       font-weight: bold;
                       font-size: 1.2rem;
                   }

                   /* Responsive Design */
                   @media (max-width: 992px) {
                       .settings-container {
                           flex-direction: column;
                       }

                       .settings-sidebar {
                           flex: 0 0 auto;
                       }
                   }

                   @media (max-width: 768px) {
                       .navbar {
                           padding: 15px 20px;
                       }

                       .hamburger {
                           display: block;
                       }

                       .nav-links {
                           position: fixed;
                           top: 0;
                           right: -100%;
                           width: 70%;
                           height: 100vh;
                           background-color: var(--dark);
                           flex-direction: column;
                           align-items: center;
                           justify-content: center;
                           gap: 40px;
                           transition: right 0.3s;
                           z-index: 1000;
                       }

                       .nav-links.active {
                           right: 0;
                       }

                       .main-content {
                           padding: 100px 20px 30px;
                       }

                       .form-row {
                           flex-direction: column;
                           gap: 0;
                       }

                       .notification {
                           top: 80px;
                           right: 10px;
                           max-width: calc(100% - 20px);
                       }
                   }

                   @media (max-width: 576px) {
                       .user-info {
                           flex-direction: column;
                           text-align: center;
                       }

                       .btn-group {
                           flex-direction: column;
                       }

                       .btn {
                           width: 100%;
                       }
                   }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar">
    <div class="logo">
        <i class="fas fa-film"></i>
        <span class="java">Java</span><span class="flix">Flix</span>
    </div>

    <button class="hamburger">
        <span class="bar"></span>
        <span class="bar"></span>
        <span class="bar"></span>
    </button>

    <div class="nav-links">
        <a href="javaflix.jsp">Home</a>
        <a href="CheckSession">Saved Movies</a>
        <a href="#">About</a>
        <a href="#">Contact</a>

        <% if (username != null) { %>
        <div class="profile-container">
            <button class="profile-btn" id="profileBtn">
                <div class="profile-image" id="profileImage">
                    <%= username.substring(0, 1).toUpperCase() %>
                </div>
                <span class="profile-name"><%= username %></span>
            </button>
            <div class="profile-dropdown" id="profileDropdown">
                <a href="profile.jsp"><i class="fas fa-user"></i> Profile</a>
                <a href="settings.jsp" class="active"><i class="fas fa-cog"></i> Settings</a>
                <a href="Logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
        <% } %>
    </div>
</nav>


<% if (successMsg != null) { %>
<div class="notification success" id="successNotification">
    <i class="fas fa-check-circle"></i>
    <span><%= successMsg %></span>
    <span class="close-btn" onclick="document.getElementById('successNotification').classList.remove('show')">&times;</span>
</div>
<% } %>

<% if (errorMsg != null) { %>
<div class="notification error" id="errorNotification">
    <i class="fas fa-exclamation-circle"></i>
    <span><%= errorMsg %></span>
    <span class="close-btn" onclick="document.getElementById('errorNotification').classList.remove('show')">&times;</span>
</div>
<% } %>

<!-- Main Content -->
<main class="main-content">
    <div class="settings-header">
        <h1>Account Settings</h1>
        <i class="fas fa-cog"></i>
    </div>

    <div class="settings-container">
        <!-- Settings Sidebar -->
        <aside class="settings-sidebar">
            <ul class="settings-menu">
                <li><a href="#profile" class="active"><i class="fas fa-user"></i> Profile</a></li>
                <li><a href="#account"><i class="fas fa-lock"></i> Account Security</a></li>
                <li><a href="#notifications"><i class="fas fa-bell"></i> Notifications</a></li>
                <li><a href="#privacy"><i class="fas fa-shield-alt"></i> Privacy</a></li>
                <li><a href="#billing"><i class="fas fa-credit-card"></i> Billing</a></li>
            </ul>
        </aside>

        <!-- Settings Content -->
        <div class="settings-content">
            <!-- Profile Section -->
            <section id="profile" class="settings-section">
                <h2><i class="fas fa-user"></i> Profile Information</h2>

                <div class="user-info">
                    <div class="user-avatar">
                        <%= username.substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="user-details">
                        <h3><%= username %></h3>
                        <p>Member since <%= new java.util.Date().toString() %></p>
                    </div>
                </div>

                <form id="profileForm" method="post" action="SaveChanges">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="userId">User ID</label>
                            <input type="text" id="userId" class="form-control" value="<%= userID != null ? userID : "N/A" %>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" class="form-control" value="<%= username %>" readonly>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" class="form-control" value="<%= email %>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="form-control" value="<%= (mobile != null ? mobile : "") %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="bio">Bio</label>
                        <textarea id="bio" name="bio" class="form-control" rows="4" placeholder="Tell us about yourself..."><%= bio != null ? bio : "" %></textarea>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn">Save Changes</button>
                        <button type="reset" class="btn btn-outline">Cancel</button>
                    </div>
                </form>
            </section>

            <!-- Change Email Section -->
            <section id="changeEmail" class="settings-section">
                <h2><i class="fas fa-envelope"></i> Change Email</h2>

                <form id="emailForm" method="post" action="ChangeEmail">
                    <div class="form-group">
                        <label for="currentEmail">Current Email</label>
                        <input type="email" id="currentEmail" name="currentEmail"  class="form-control" value="<%= email %>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="newEmail">New Email</label>
                        <input type="email" id="newEmail" name="newEmail" class="form-control" placeholder="Enter new email address" required>
                    </div>

                    <div class="form-group">
                        <label for="emailPassword">Current Password</label>
                        <input type="password" id="emailPassword" name="password" class="form-control" placeholder="Enter your password to confirm changes" required>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn">Update Email</button>
                    </div>
                </form>
            </section>

            <!-- Danger Zone -->
            <section class="settings-section danger-zone">
                <h3><i class="fas fa-exclamation-triangle"></i> Danger Zone</h3>
                <p>These actions are irreversible. Please proceed with caution.</p>

                <div class="btn-group">
                    <form method="post" action="DeactivateAccount" style="display: inline;">
                        <button type="submit" class="btn btn-outline">Deactivate Account</button>
                    </form>
                    <form method="post" action="DeleteAccount" style="display: inline;">
                        <button type="submit" class="btn btn-outline">Delete Account</button>
                    </form>
                </div>
            </section>
        </div>
    </div>
</main>


<script>
    // Hamburger menu functionality
    const hamburger = document.querySelector('.hamburger');
    const navLinks = document.querySelector('.nav-links');

    hamburger.addEventListener('click', () => {
        hamburger.classList.toggle('active');
        navLinks.classList.toggle('active');

        if (navLinks.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = '';
        }
    });

    // Close menu when clicking on a link
    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
            hamburger.classList.remove('active');
            navLinks.classList.remove('active');
            document.body.style.overflow = '';
        });
    });

    // Profile dropdown functionality
    const profileBtn = document.getElementById('profileBtn');
    const profileDropdown = document.getElementById('profileDropdown');

    if (profileBtn && profileDropdown) {
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            profileDropdown.classList.toggle('active');
        });

        document.addEventListener('click', () => {
            profileDropdown.classList.remove('active');
        });

        profileDropdown.addEventListener('click', (e) => {
            e.stopPropagation();
        });
    }

    // Show notifications if they exist
    window.addEventListener('DOMContentLoaded', () => {
        const successNotification = document.getElementById('successNotification');
        const errorNotification = document.getElementById('errorNotification');

        if (successNotification) {
            successNotification.classList.add('show');
            setTimeout(() => {
                successNotification.classList.remove('show');
            }, 5000);
        }

        if (errorNotification) {
            errorNotification.classList.add('show');
            setTimeout(() => {
                errorNotification.classList.remove('show');
            }, 5000);
        }
    });
</script>
</body>
</html>