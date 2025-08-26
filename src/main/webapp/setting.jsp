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
       <link rel ="stylesheet" href ="CSS/setting.css">
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