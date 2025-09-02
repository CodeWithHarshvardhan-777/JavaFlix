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
            ps.executeUpdate();
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
        --dark: #141414;
        --light: #f4f4f4;
        --gray: #999;
        --dark-gray: #222;
        --imdb-yellow: #f5c518;
        --card-bg: #1a1a1a;
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
        padding: 15px 30px;
        background: var(--dark);
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(0,0,0,0.3);
    }

    .logo {
        font-size: 22px;
        font-weight: 700;
        color: white;
    }

    .logo span {
        color: var(--primary);
    }

    .nav-links {
        display: flex;
        gap: 20px;
    }

    .nav-links a {
        color: white;
        text-decoration: none;
        font-weight: 500;
        font-size: 14px;
        transition: color 0.3s;
    }

    .nav-links a:hover {
        color: var(--primary);
    }

    /* Hamburger Menu */
    .hamburger {
        display: none;
        cursor: pointer;
        flex-direction: column;
        gap: 4px;
    }

    .bar {
        width: 22px;
        height: 2px;
        background-color: white;
        transition: all 0.3s ease;
    }

    .hamburger.active .bar:nth-child(1) {
        transform: translateY(6px) rotate(45deg);
    }

    .hamburger.active .bar:nth-child(2) {
        opacity: 0;
    }

    .hamburger.active .bar:nth-child(3) {
        transform: translateY(-6px) rotate(-45deg);
    }

    /* Page Header */
    .page-header {
        background: linear-gradient(135deg, rgba(229,9,20,0.8) 0%, rgba(20,20,20,0.9) 100%);
        padding: 90px 30px 40px;
        margin-top: 60px;
        text-align: center;
    }

    .page-header-content h1 {
        font-size: 1.8rem;
        margin-bottom: 10px;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
    }

    .page-header-content p {
        font-size: 0.95rem;
        color: var(--gray);
        max-width: 500px;
        margin: 0 auto;
        line-height: 1.5;
    }

    /* Movie Grid */
    .movie-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 20px;
        padding: 30px;
        max-width: 1200px;
        margin: 0 auto;
    }

    .movie-card {
        background-color: var(--card-bg);
        border-radius: 8px;
        overflow: hidden;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }

    .movie-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.3);
    }

    .movie-poster-container {
        position: relative;
        width: 100%;
        height: 280px;
        overflow: hidden;
    }

    .movie-poster {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
    }

    .movie-card:hover .movie-poster {
        transform: scale(1.04);
    }

    .remove-btn {
        position: absolute;
        top: 8px;
        right: 8px;
        background: rgba(229, 9, 20, 0.9);
        border: none;
        border-radius: 50%;
        width: 32px;
        height: 32px;
        color: white;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 12px;
    }

    .remove-btn:hover {
        background: var(--primary);
        transform: scale(1.1);
    }

    .movie-info {
        padding: 15px;
    }

    .movie-title {
        font-size: 1rem;
        font-weight: 600;
        margin-bottom: 8px;
        color: white;
        line-height: 1.3;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .movie-meta {
        display: flex;
        gap: 6px;
        margin-bottom: 10px;
        flex-wrap: wrap;
    }

    .movie-year, .movie-runtime, .movie-language {
        font-size: 0.75rem;
        color: var(--gray);
        background: rgba(255,255,255,0.1);
        padding: 3px 6px;
        border-radius: 3px;
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
        gap: 4px;
        color: var(--imdb-yellow);
        font-weight: 600;
        font-size: 0.85rem;
    }

    .movie-type {
        background: var(--primary);
        color: white;
        padding: 3px 6px;
        border-radius: 3px;
        font-size: 0.75rem;
        font-weight: 500;
    }

    /* Empty State & Error Messages */
    .empty-state, .error-message {
        grid-column: 1 / -1;
        text-align: center;
        padding: 40px 20px;
        background: var(--card-bg);
        border-radius: 8px;
        margin: 10px 0;
    }

    .empty-state i, .error-message i {
        font-size: 2.5rem;
        margin-bottom: 15px;
        color: var(--gray);
    }

    .empty-state h2, .error-message h2 {
        font-size: 1.4rem;
        margin-bottom: 10px;
        color: white;
    }

    .empty-state p, .error-message p {
        color: var(--gray);
        margin-bottom: 20px;
        max-width: 400px;
        margin-left: auto;
        margin-right: auto;
        line-height: 1.5;
        font-size: 0.9rem;
    }

    .btn {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background: var(--primary);
        color: white;
        padding: 8px 16px;
        border-radius: 4px;
        text-decoration: none;
        font-weight: 600;
        font-size: 0.9rem;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
    }

    .btn:hover {
        background: #f40612;
        transform: translateY(-1px);
    }

    .error-message i {
        color: var(--primary);
    }

    /* Footer */
    footer {
        background-color: #000;
        padding: 30px 0 15px;
        margin-top: 40px;
    }

    .footer-content {
        max-width: 1000px;
        margin: 0 auto;
        padding: 0 30px;
        text-align: center;
    }

    .footer-logo {
        font-size: 1.5rem;
        font-weight: 700;
        margin-bottom: 15px;
        color: white;
    }

    .footer-logo span {
        color: var(--primary);
    }

    .footer-links {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        gap: 15px;
        margin-bottom: 20px;
        font-size: 0.85rem;
    }

    .footer-links a {
        color: var(--gray);
        text-decoration: none;
        transition: color 0.3s;
    }

    .footer-links a:hover {
        color: var(--primary);
    }

    .social-icons {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-bottom: 20px;
    }

    .social-icons a {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background: rgba(255,255,255,0.1);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--gray);
        transition: all 0.3s;
        font-size: 0.9rem;
    }

    .social-icons a:hover {
        background: var(--primary);
        color: white;
        transform: translateY(-2px);
    }

    .copyright {
        color: var(--gray);
        font-size: 0.8rem;
    }

    /* Responsive Design */
    @media (max-width: 1024px) {
        .movie-grid {
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            padding: 25px;
        }
    }

    @media (max-width: 768px) {
        .navbar {
            padding: 12px 20px;
        }

        .hamburger {
            display: flex;
            z-index: 1001;
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
            gap: 25px;
            transition: right 0.3s;
            z-index: 1000;
        }

        .nav-links.active {
            right: 0;
        }

        .page-header {
            padding: 80px 20px 30px;
        }

        .page-header-content h1 {
            font-size: 1.6rem;
        }

        .movie-grid {
            padding: 20px;
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
        }

        .movie-poster-container {
            height: 220px;
        }

        .footer-content {
            padding: 0 20px;
        }

        .footer-links {
            flex-direction: column;
            gap: 10px;
        }
    }

    @media (max-width: 576px) {
        .movie-grid {
            grid-template-columns: repeat(2, 1fr);
        }

        .page-header-content h1 {
            font-size: 1.4rem;
        }

        .page-header-content p {
            font-size: 0.85rem;
        }

        .empty-state, .error-message {
            padding: 30px 15px;
        }

        .empty-state i, .error-message i {
            font-size: 2rem;
        }

        .empty-state h2, .error-message h2 {
            font-size: 1.2rem;
        }

        .footer-logo {
            font-size: 1.3rem;
        }
    }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="logo">
            <i class="fas fa-film"></i>Java<span>Flix</span>
        </div>

        <!-- Hamburger Menu -->
        <div class="hamburger">
            <span class="bar"></span>
            <span class="bar"></span>
            <span class="bar"></span>
        </div>

        <div class="nav-links">
            <a href="javaflix.html">Home</a>
            <a href="javaflix.html">Search Movie</a>
            <a href="#">About</a>
            <a href="#">Contact</a>
        </div>
    </nav>

    <!-- Page Header -->
    <div class="page-header">
        <div class="page-header-content">
            <h1>Your Saved Movies</h1>
            <p>All your favorite movies in one place. Click on any movie to view details or remove it from your collection.</p>
        </div>
    </div>

    <!-- Movie Grid -->
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
                preparedStatement = conn.prepareStatement(query);
                preparedStatement.setString(1, userID);
                rs = preparedStatement.executeQuery();

                while(rs.next()) {
                    hasData = true;
                    String imageUrl = rs.getString("image");
                    if (imageUrl == null || imageUrl.trim().isEmpty()) {
                        imageUrl = "https://via.placeholder.com/300x450?text=No+Poster";
                    }

                    String runtime = rs.getString("runtime");
    %>
<div class="movie-card">
    <div class="movie-poster-container">
        <img src="<%= imageUrl %>" alt="<%= rs.getString("title") %>" class="movie-poster"
             onerror="this.src='https://via.placeholder.com/300x450?text=No+Poster'">
             <form method="post" action="" style="position:absolute; top:10px; right:10px;">
                         <button class="remove-btn" type="submit" name="deleteId" value="<%= rs.getString("id") %>">
                             <i class="fas fa-trash"></i>
                         </button>
                     </form>
    </div>
    <div class="movie-info">
        <h3 class="movie-title"><%= rs.getString("title") %></h3>
        <div class="movie-meta">
            <span class="movie-year"><%= rs.getString("year") != null ? rs.getString("year") : "N/A" %></span>
            <span class="movie-runtime"><%= runtime %></span>
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
    %>
        <div class="error-message">
            <i class="fas fa-exclamation-triangle"></i>
            <h2>Error Loading Movies</h2>
            <p>We encountered an issue while loading your saved movies. Please try again later.</p>
            <button class="btn" onclick="window.location.reload()"><i class="fas fa-sync-alt"></i> Try Again</button>
        </div>
    <%
                e.printStackTrace();
            } finally {
                if(rs != null) try { rs.close(); } catch(Exception e) {}
                if(preparedStatement != null) try { preparedStatement.close(); } catch(Exception e) {}
                if(conn != null) try { conn.close(); } catch(Exception e) {}
            }
        }
    %>
    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-logo">Java<span>Flix</span></div>

            <div class="footer-links">
                <a href="homepage.jsp">Home</a>
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
        // Hamburger menu functionality
        const hamburger = document.querySelector('.hamburger');
        const navLinks = document.querySelector('.nav-links');

        hamburger.addEventListener('click', () => {
            hamburger.classList.toggle('active');
            navLinks.classList.toggle('active');
        });

        // Close menu when clicking on a link
        document.querySelectorAll('.nav-links a').forEach(link => {
            link.addEventListener('click', () => {
                hamburger.classList.remove('active');
                navLinks.classList.remove('active');
            });
        });

        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>