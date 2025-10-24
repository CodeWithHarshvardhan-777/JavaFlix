<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String Dburl = "jdbc:mysql://localhost:3307/javaflix";
    String DbUser = "root";
    String DbPass = "Harsh$1000Pande";

    String deleteId = request.getParameter("deleteId");
    if (deleteId != null && !deleteId.isEmpty()) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DriverManager.getConnection(Dburl, DbUser, DbPass);
            ps = conn.prepareStatement("DELETE FROM movies WHERE id = ?");
            ps.setString(1, deleteId);
            int i = ps.executeUpdate();
            if( i != 0)
            {
            response.sendRedirect("viewSaveMovies.jsp");
            return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saved Movies | JavaFlix</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
    :root {
        --primary: #e50914;
        --primary-dark: #b80710;
        --dark: #141414;
        --light: #f4f4f4;
        --gray: #999;
        --dark-gray: #222;
        --imdb-yellow: #f5c518;
        --card-bg: #1a1a1a;
        --card-hover: #242424;
        --success: #2ecc71;
        --transition: all 0.3s ease;
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

    .loader-wrapper {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: var(--dark);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
        transition: opacity 0.5s ease, visibility 0.5s ease;
    }

    .loader-wrapper.hidden {
        opacity: 0;
        visibility: hidden;
        pointer-events: none;
    }

    .loader {
        width: 48px;
        height: 48px;
        border: 5px solid var(--primary);
        border-bottom-color: transparent;
        border-radius: 50%;
        display: inline-block;
        box-sizing: border-box;
        animation: rotation 1s linear infinite;
    }

    @keyframes rotation {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

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
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .logo .flix { color: var(--primary); }

    .nav-links {
        display: flex;
        gap: 30px;
        align-items: center;
    }

    .nav-links a {
        color: white;
        text-decoration: none;
        font-weight: 500;
        transition: color 0.3s;
    }

    .nav-links a:hover { color: var(--primary); }

    .profile-container {
        position: relative;
    }

    .profile-btn {
        display: flex;
        align-items: center;
        gap: 10px;
        background: none;
        border: none;
        cursor: pointer;
        color: white;
        padding: 5px;
        border-radius: 20px;
        transition: background 0.3s;
    }

    .profile-btn:hover {
        background: rgba(255, 255, 255, 0.1);
    }

    .profile-image {
        width: 36px;
        height: 36px;
        background-color: var(--primary);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: white;
        font-size: 14px;
    }

    .profile-name {
        font-weight: 500;
    }

    .profile-dropdown {
        position: absolute;
        top: 50px;
        right: 0;
        background-color: var(--dark-gray);
        border-radius: 5px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.5);
        width: 200px;
        overflow: hidden;
        display: none;
        z-index: 1001;
    }

    .profile-dropdown.active {
        display: block;
    }

    .profile-dropdown a {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px 20px;
        color: white;
        text-decoration: none;
        transition: background 0.3s;
        border: none;
        width: 100%;
        background: none;
        font-size: 14px;
    }

    .profile-dropdown a:hover {
        background-color: #333;
    }

    .profile-dropdown a i {
        width: 16px;
        text-align: center;
    }

    .hamburger {
        display: none;
        cursor: pointer;
        background: none;
        border: none;
        z-index: 1001;
    }

    .bar {
        display: block;
        width: 25px;
        height: 3px;
        margin: 5px auto;
        background-color: white;
        transition: all 0.3s ease;
    }

    .hamburger.active .bar:nth-child(2) { opacity: 0; }
    .hamburger.active .bar:nth-child(1) { transform: translateY(8px) rotate(45deg); }
    .hamburger.active .bar:nth-child(3) { transform: translateY(-8px) rotate(-45deg); }

    .page-header {
        padding: 180px 50px 100px;
        text-align: center;
        background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
                    url('https://assets.nflxext.com/ffe/siteui/vlv3/9d3533b2-0e2b-40b2-95e0-ecd7979cc88b/a3873901-5b7c-46eb-b9fa-12fea5197bd3/IN-en-20240311-popsignuptwoweeks-perspective_alpha_website_large.jpg') no-repeat center center/cover;
        min-height: 50vh;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }

    .page-header-content h1 {
        font-size: 3rem;
        margin-bottom: 20px;
        max-width: 800px;
        line-height: 1.2;
    }

    .page-header-content p {
        font-size: 1.2rem;
        max-width: 600px;
        margin-bottom: 40px;
        opacity: 0.9;
    }

    .movie-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 30px;
        padding: 50px;
        max-width: 1400px;
        margin: 0 auto;
    }

    .movie-card {
        background-color: var(--card-bg);
        border-radius: 12px;
        overflow: hidden;
        transition: var(--transition);
        box-shadow: 0 6px 18px rgba(0,0,0,0.4);
        position: relative;
        cursor: pointer;
    }

    .movie-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 12px 25px rgba(0,0,0,0.6);
        background-color: var(--card-hover);
    }

    .movie-poster-container {
        position: relative;
        width: 100%;
        height: 300px;
        overflow: hidden;
    }

    .movie-poster {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s ease;
    }

    .movie-card:hover .movie-poster { transform: scale(1.08); }

    .movie-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(to bottom, rgba(0,0,0,0) 0%, rgba(0,0,0,0.8) 100%);
        opacity: 0;
        transition: var(--transition);
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .movie-card:hover .movie-overlay { opacity: 1; }

    .movie-actions {
        display: flex;
        gap: 10px;
        transform: translateY(20px);
        transition: var(--transition);
    }

    .movie-card:hover .movie-actions { transform: translateY(0); }

    .action-btn {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(0,0,0,0.8);
        color: white;
        border: none;
        cursor: pointer;
        transition: var(--transition);
        font-size: 18px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    }

    .action-btn:hover {
        background: var(--primary);
        transform: scale(1.15);
    }

    .view-btn {
        background: rgba(32, 201, 151, 0.9);
    }

    .view-btn:hover {
        background: #20c997;
        transform: scale(1.15);
    }

    .remove-btn {
        background: rgba(229, 9, 20, 0.9);
    }

    .remove-btn:hover {
        background: var(--primary-dark);
        transform: scale(1.15);
    }

    .movie-info { padding: 18px; }

    .movie-title {
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 12px;
        color: white;
        line-height: 1.3;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        min-height: 2.6em;
        transition: var(--transition);
    }

    .movie-card:hover .movie-title { color: var(--primary); }

    .movie-meta {
        display: flex;
        gap: 8px;
        margin-bottom: 12px;
        flex-wrap: wrap;
    }

    .movie-year, .movie-runtime, .movie-language {
        font-size: 0.75rem;
        color: var(--gray);
        background: rgba(255,255,255,0.1);
        padding: 3px 6px;
        border-radius: 4px;
    }

    .movie-details {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 12px;
    }

    .imdb-rating {
        display: flex;
        align-items: center;
        gap: 5px;
        color: var(--imdb-yellow);
        font-weight: 600;
        font-size: 0.85rem;
    }

    .movie-type {
        background: var(--primary);
        color: white;
        padding: 3px 8px;
        border-radius: 4px;
        font-size: 0.75rem;
        font-weight: 500;
    }

    .empty-state, .error-message {
        grid-column: 1 / -1;
        text-align: center;
        padding: 60px 30px;
        background: var(--card-bg);
        border-radius: 10px;
        margin: 20px 0;
    }

    .empty-state i, .error-message i {
        font-size: 3rem;
        margin-bottom: 20px;
        color: var(--gray);
    }

    .empty-state h2, .error-message h2 {
        font-size: 1.8rem;
        margin-bottom: 15px;
        color: white;
    }

    .empty-state p, .error-message p {
        color: var(--gray);
        margin-bottom: 30px;
        max-width: 500px;
        margin-left: auto;
        margin-right: auto;
        line-height: 1.6;
        font-size: 1rem;
    }

    .btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: var(--primary);
        color: white;
        padding: 12px 24px;
        border-radius: 5px;
        text-decoration: none;
        font-weight: 600;
        font-size: 1rem;
        transition: var(--transition);
        border: none;
        cursor: pointer;
    }

    .btn:hover {
        background: #f40612;
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
    }

    .error-message i { color: var(--primary); }

    footer {
        background-color: #000;
        padding: 50px 0 25px;
        margin-top: 50px;
    }

    .footer-content {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 50px;
    }

    .footer-logo {
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 20px;
        color: white;
        text-align: center;
    }

    .footer-logo span { color: var(--primary); }

    .footer-links {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        gap: 20px;
        margin-bottom: 30px;
        font-size: 0.9rem;
    }

    .footer-links a {
        color: var(--gray);
        text-decoration: none;
        transition: color 0.3s;
    }

    .footer-links a:hover { color: var(--primary); }

    .social-icons {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-bottom: 30px;
    }

    .social-icons a {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: rgba(255,255,255,0.1);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--gray);
        transition: all 0.3s;
        font-size: 1.1rem;
    }

    .social-icons a:hover {
        background: var(--primary);
        color: white;
        transform: translateY(-3px);
    }

    .copyright {
        color: var(--gray);
        font-size: 0.9rem;
        text-align: center;
    }

    .toast {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: var(--success);
        color: white;
        padding: 15px 25px;
        border-radius: 5px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        z-index: 2100;
        display: flex;
        align-items: center;
        gap: 10px;
        transform: translateY(100px);
        opacity: 0;
        transition: var(--transition);
    }

    .toast.show {
        transform: translateY(0);
        opacity: 1;
    }

    @media (max-width: 1024px) {
        .movie-grid {
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            padding: 40px;
        }
    }

    @media (max-width: 768px) {
        .navbar { padding: 15px 20px; }
        .hamburger { display: block; }
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
        }
        .nav-links.active { right: 0; }
        .profile-container { margin-top: 20px; }
        .profile-dropdown {
            position: static;
            width: 100%;
            margin-top: 15px;
            text-align: center;
        }
        .page-header { padding: 150px 20px 80px; }
        .page-header-content h1 { font-size: 2.2rem; }
        .page-header-content p { font-size: 1rem; }
        .movie-grid {
            padding: 30px;
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
        }
        .movie-poster-container { height: 240px; }
        .footer-content { padding: 0 20px; }
        .footer-links { flex-direction: column; gap: 15px; }
    }

    @media (max-width: 576px) {
        .movie-grid {
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            padding: 20px;
        }
        .page-header-content h1 { font-size: 1.8rem; }
        .page-header-content p { font-size: 0.9rem; }
        .empty-state, .error-message { padding: 40px 20px; }
        .empty-state i, .error-message i { font-size: 2.5rem; }
        .empty-state h2, .error-message h2 { font-size: 1.5rem; }
        .footer-logo { font-size: 1.5rem; }
        .profile-name {
            display: none;
        }
    }
    </style>
</head>
<body>
    <!-- Loader with immediate fallback -->
    <div class="loader-wrapper" id="loaderWrapper">
        <div class="loader"></div>
    </div>

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
            <a href="javaflix.jsp">Search Movie</a>
            <a href="#">About</a>
            <a href="#">Contact</a>

            <% if (session != null && session.getAttribute("username") != null) { %>
                <div class="profile-container">
                    <button class="profile-btn" id="profileBtn">
                        <div class="profile-image" id="profileImage">
                            <%= ((String)session.getAttribute("username")).substring(0, 1).toUpperCase() %>
                        </div>
                        <span class="profile-name"><%= session.getAttribute("username") %></span>
                    </button>
                    <div class="profile-dropdown" id="profileDropdown">
                        <a href="profile.jsp"><i class="fas fa-user"></i> Profile</a>
                        <a href="setting.jsp"><i class="fas fa-cog"></i> Settings</a>
                        <a href="Logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </div>
            <% } else { %>
                <a href="login.jsp" class="btn" style="padding: 8px 16px; font-size: 0.9rem;">Login</a>
            <% } %>
        </div>
    </nav>

    <div class="page-header">
        <div class="page-header-content">
            <h1>Your Saved Movies</h1>
            <p>All your favorite movies in one place. Click on any movie to view details or remove it from your collection.</p>
        </div>
    </div>

    <div class="movie-grid">
    <%
        String url = "jdbc:mysql://localhost:3307/javaflix";
        String dbUser = "root";
        String dbPass = "Harsh$1000Pande";
        String userID = (String) session.getAttribute("userID");

        if (userID == null) {
    %>
        <div class="empty-state">
            <i class="fas fa-exclamation-circle"></i>
            <h2>Authentication Required</h2>
            <p>Please log in to view your saved movies.</p>
            <a href="login.jsp" class="btn"><i class="fas fa-sign-in-alt"></i> Login</a>
        </div>
    <%
        } else {
            String query = "SELECT * FROM movies WHERE userID = ?";
            Connection conn = null;
            PreparedStatement preparedStatement = null;
            ResultSet rs = null;
            boolean hasData = false;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, dbUser, dbPass);

                // Test connection
                if (conn != null && !conn.isClosed()) {
                    preparedStatement = conn.prepareStatement(query);
                    preparedStatement.setString(1, userID);
                    rs = preparedStatement.executeQuery();

                    while(rs.next()) {
                        hasData = true;
                        String imageUrl = rs.getString("image");
                        if (imageUrl == null || imageUrl.trim().isEmpty()) {
                            imageUrl = "https://via.placeholder.com/300x450/1a1a1a/ffffff?text=No+Poster";
                        }

                        String runtime = rs.getString("runtime");
                        String language = rs.getString("language");
                        String movieId = rs.getString("id");
    %>
        <div class="movie-card" data-movie-id="<%= movieId %>">
            <div class="movie-poster-container">
                <img src="<%= imageUrl %>" alt="<%= rs.getString("title") %>" class="movie-poster"
                     onerror="this.src='https://via.placeholder.com/300x450/1a1a1a/ffffff?text=No+Poster'">
                <div class="movie-overlay">
                    <div class="movie-actions">
                        <form method="GET" action="try" style="display: inline;">
                            <input type="hidden" name="query" value="<%= rs.getString("title") %>">
                            <button type="submit" class="action-btn view-btn" title="View Details">
                                <i class="fas fa-eye"></i>
                            </button>
                        </form>
                        <form method="post" action="" style="display: inline;">
                            <input type="hidden" name="deleteId" value="<%= rs.getString("id") %>">
                            <button type="submit" class="action-btn remove-btn" onclick="showToast()" title="Remove Movie">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="movie-info">
                <h3 class="movie-title"><%= rs.getString("title") %></h3>
                <div class="movie-meta">
                    <span class="movie-year"><%= rs.getString("year") != null ? rs.getString("year") : "N/A" %></span>
                    <span class="movie-runtime"><%= runtime != null ? runtime : "N/A" %></span>
                    <% if (language != null && !language.isEmpty()) { %>
                        <span class="movie-language"><%= language %></span>
                    <% } %>
                </div>
                <div class="movie-details">
                    <span class="imdb-rating">
                        <i class="fas fa-star"></i> <%= rs.getString("imdb") != null ? rs.getString("imdb") : "N/A" %>
                    </span>
                    <span class="movie-type"><%= rs.getString("type") != null ? rs.getString("type") : "N/A" %></span>
                </div>
            </div>
        </div>
    <%
                    }
                } else {
                    throw new SQLException("Database connection failed");
                }

                if (!hasData) {
    %>
        <div class="empty-state">
            <i class="fas fa-bookmark"></i>
            <h2>Your Watchlist is Empty</h2>
            <p>You haven't saved any movies to your collection yet. Start browsing and save your favorites to watch later.</p>
            <a href="javaflix.jsp" class="btn"><i class="fas fa-film"></i> Browse Movies</a>
        </div>
    <%
                }
            } catch(Exception e) {
                System.out.println("Database error: " + e.getMessage());
    %>
        <div class="error-message">
            <i class="fas fa-exclamation-triangle"></i>
            <h2>Error Loading Movies</h2>
            <p>We encountered an issue while loading your saved movies: <%= e.getMessage() %></p>
            <button class="btn" onclick="window.location.reload()"><i class="fas fa-sync-alt"></i> Try Again</button>
        </div>
    <%
            } finally {
                if(rs != null) try { rs.close(); } catch(Exception e) {}
                if(preparedStatement != null) try { preparedStatement.close(); } catch(Exception e) {}
                if(conn != null) try { conn.close(); } catch(Exception e) {}
            }
        }
    %>
    </div>

    <div class="toast" id="toast">
        <i class="fas fa-check-circle"></i>
        <span>Movie removed successfully!</span>
    </div>

    <footer>
        <div class="footer-content">
            <div class="footer-logo">Java<span>Flix</span></div>
            <div class="footer-links">
                <a href="javaflix.jsp">Home</a>
                <a href="#">About Us</a>
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Contact Us</a>
                <a href="#">FAQ</a>
            </div>
            <div class="social-icons">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-youtube"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
            <p class="copyright">&copy; 2025 JavaFlix. All Rights Reserved.</p>
        </div>
    </footer>

    <script>
        // Enhanced loader with multiple fallbacks
        console.log('Script initialization started');

        const loaderWrapper = document.getElementById('loaderWrapper');
        const toast = document.getElementById('toast');

        // Method 1: DOM Content Loaded
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM content loaded');
            hideLoader();
        });

        // Method 2: Window Load
        window.addEventListener('load', function() {
            console.log('Window fully loaded');
            hideLoader();
        });

        // Method 3: Error handling
        window.addEventListener('error', function(e) {
            console.error('Global error caught:', e.error);
            hideLoader();
        });

        // Method 4: Fallback timeout
        setTimeout(hideLoader, 3000); // Max 3 seconds

        function hideLoader() {
            console.log('Hiding loader');
            if (loaderWrapper && !loaderWrapper.classList.contains('hidden')) {
                loaderWrapper.classList.add('hidden');
                console.log('Loader hidden successfully');
            }
        }

        // Force hide loader if still visible after 5 seconds (ultimate fallback)
        setTimeout(function() {
            if (loaderWrapper && !loaderWrapper.classList.contains('hidden')) {
                console.log('Forcing loader hide after timeout');
                loaderWrapper.classList.add('hidden');
            }
        }, 5000);

        // Hamburger menu
        const hamburger = document.querySelector('.hamburger');
        const navLinks = document.querySelector('.nav-links');

        if (hamburger && navLinks) {
            hamburger.addEventListener('click', () => {
                hamburger.classList.toggle('active');
                navLinks.classList.toggle('active');
            });
        }

        // Profile dropdown
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
        }

        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.navbar');
            if (navbar) {
                navbar.classList.toggle('scrolled', window.scrollY > 50);
            }
        });

        // Close menu on link click
        document.querySelectorAll('.nav-links a').forEach(link => {
            link.addEventListener('click', () => {
                if (hamburger && navLinks) {
                    hamburger.classList.remove('active');
                    navLinks.classList.remove('active');
                }
            });
        });

        // Toast notification function
        function showToast() {
            console.log('Delete button clicked');
            if (toast) {
                toast.classList.add('show');
                setTimeout(() => {
                    toast.classList.remove('show');
                }, 3000);
            }
        }

        // Initialize page - hide loader immediately if everything is ready
        if (document.readyState === 'complete') {
            hideLoader();
        }

        // Add click event to movie cards for direct viewing
        document.querySelectorAll('.movie-card').forEach(card => {
            card.addEventListener('click', function(e) {
                // Don't trigger if the click was on action buttons
                if (!e.target.closest('.action-btn')) {
                    const movieId = this.getAttribute('data-movie-id');
                    if (movieId) {
                        // Redirect to movie details page
                        window.location.href = 'movieDetails.jsp?movieId=' + movieId;
                    }
                }
            });
        });
    </script>
</body>
</html>