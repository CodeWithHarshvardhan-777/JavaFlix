<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaFlix - Saved Movies</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary: #e50914;
            --dark: #141414;
            --light: #f4f4f4;
            --gray: #999;
            --dark-gray: #222;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dark);
            color: var(--light);
            line-height: 1.6;
        }

        /* Navbar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 50px;
            background-color: rgba(0, 0, 0, 0.8);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }

        .logo {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
        }

        .logo span {
            color: var(--light);
        }

        .nav-links {
            display: flex;
            gap: 30px;
        }

        .nav-links a {
            color: var(--light);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        /* Hamburger Menu */
        .hamburger {
            display: none;
            cursor: pointer;
            z-index: 1001;
        }

        .hamburger .bar {
            display: block;
            width: 25px;
            height: 3px;
            margin: 5px auto;
            background-color: var(--light);
            transition: all 0.3s ease-in-out;
        }

        /* Main Content */
        .main-content {
            padding: 120px 50px 50px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .section-title {
            font-size: 2.5rem;
            margin-bottom: 40px;
            color: var(--light);
        }

        /* Saved Movies Grid */
        .movies-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 30px;
        }

        .movie-card {
            background-color: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
        }

        .movie-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .movie-poster {
            width: 100%;
            height: 330px;
            object-fit: cover;
        }

        .movie-info {
            padding: 15px;
        }

        .movie-title {
            font-size: 1.1rem;
            margin-bottom: 8px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .movie-year {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 12px;
        }

        .remove-btn {
            background-color: var(--primary);
            color: white;
            border: none;
            border-radius: 4px;
            padding: 8px 12px;
            width: 100%;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .remove-btn:hover {
            background-color: #f40612;
        }

        .empty-state {
            text-align: center;
            padding: 50px 0;
        }

        .empty-icon {
            font-size: 5rem;
            color: var(--gray);
            margin-bottom: 20px;
        }

        .empty-state h2 {
            font-size: 2rem;
            margin-bottom: 15px;
        }

        .empty-state p {
            color: var(--gray);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto 30px;
        }

        .browse-link {
            display: inline-block;
            background-color: var(--primary);
            color: white;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 4px;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .browse-link:hover {
            background-color: #f40612;
        }

        /* Footer */
        footer {
            background-color: #000;
            padding: 50px 20px;
            text-align: center;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-links {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
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
            margin-bottom: 30px;
        }

        .social-icons a {
            color: var(--light);
            font-size: 1.5rem;
            margin: 0 10px;
            transition: color 0.3s;
        }

        .social-icons a:hover {
            color: var(--primary);
        }

        .copyright {
            color: var(--gray);
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .logo {
                font-size: 1.5rem;
            }

            .hamburger {
                display: block;
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

            .nav-links {
                position: fixed;
                top: 0;
                left: -100%;
                gap: 0;
                flex-direction: column;
                background-color: rgba(0, 0, 0, 0.9);
                width: 100%;
                height: 100vh;
                text-align: center;
                transition: 0.3s;
                padding-top: 80px;
            }

            .nav-links.active {
                left: 0;
            }

            .nav-links a {
                margin: 16px 0;
                font-size: 1.2rem;
            }

            .main-content {
                padding: 100px 20px 30px;
            }

            .section-title {
                font-size: 2rem;
            }

            .movies-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 15px;
            }

            .movie-poster {
                height: 225px;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="logo">Java<span>Flix</span></div>

        <!-- Hamburger Menu -->
        <div class="hamburger">
            <span class="bar"></span>
            <span class="bar"></span>
            <span class="bar"></span>
        </div>

        <div class="nav-links">
            <a href="homepage.jsp">Home</a>
            <a href="saved.jsp" class="active">Saved Movies</a>
            <a href="#">About</a>
            <a href="#">Contact</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <h1 class="section-title">Your Saved Movies</h1>

        <%-- Check if there are saved movies --%>
        <%
            // This would typically come from your servlet as a request attribute
            java.util.List<com.yourpackage.Movie> savedMovies =
                (java.util.List<com.yourpackage.Movie>) request.getAttribute("savedMovies");

            if (savedMovies == null || savedMovies.isEmpty()) {
        %>
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-bookmark"></i>
                    </div>
                    <h2>No Saved Movies Yet</h2>
                    <p>You haven't saved any movies to your collection. Browse our catalog and save your favorites to watch later.</p>
                    <a href="homepage.jsp" class="browse-link">Browse Movies</a>
                </div>
        <%
            } else {
        %>
                <div class="movies-grid">
                    <%-- Loop through saved movies --%>
                    <%
                        for (com.yourpackage.Movie movie : savedMovies) {
                    %>
                            <div class="movie-card">
                                <img src="<%= movie.getPosterPath() %>" alt="<%= movie.getTitle() %>" class="movie-poster" onerror="this.src='https://via.placeholder.com/300x450?text=No+Poster'">
                                <div class="movie-info">
                                    <h3 class="movie-title"><%= movie.getTitle() %></h3>
                                    <p class="movie-year"><%= movie.getReleaseYear() %></p>
                                    <form action="RemoveMovieServlet" method="post">
                                        <input type="hidden" name="movieId" value="<%= movie.getId() %>">
                                        <button type="submit" class="remove-btn">
                                            <i class="fas fa-trash-alt"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </div>
                    <%
                        }
                    %>
                </div>
        <%
            }
        %>
    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-links">
                <a href="homepage.jsp">Home</a>
                <a href="#">About</a>
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Contact</a>
            </div>

            <div class="social-icons">
                <a href="#"><i class="fab fa-facebook"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-github"></i></a>
            </div>

            <p class="copyright">&copy; 2025 JavaFlix. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Hamburger menu functionality only (no movie-related JS)
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
    </script>
</body>
</html>