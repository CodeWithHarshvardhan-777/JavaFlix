<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaFlix - <%= request.getAttribute("title") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="assets/css/resultpage.css">
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
        <a href="#">Home</a>
        <a href="saved-movies">Saved Movies</a>
        <a href="#">About</a>
        <a href="#">Contact</a>
    </div>
</nav>

<!-- Movie Details Section -->
<div class="movie-container">
    <div class="movie-poster-container">
        <div class="movie-poster">
            <img src=<%= request.getAttribute("poster") %> alt="Movie Poster">
            <form action="save-movie" method="post" id="saveFormSmall">
                <input type="hidden" name="imdbID" value="<%= request.getAttribute("imdbID") %>">
                <input type="hidden" name="title" value="<%= request.getAttribute("title") %>">
                <input type="hidden" name="poster" value="<%= request.getAttribute("poster") %>">
                <input type="hidden" name="year" value="<%= request.getAttribute("year") %>">
                <input type="hidden" name="type" value="<%= request.getAttribute("type") %>">
                <input type="hidden" name="totalSeasons" value="<%= request.getAttribute("totalSeasons") %>">
                <button type="submit" class="save-btn" id="saveBtnSmall" aria-label="Save movie">
                    <% if (request.getAttribute("isSaved") != null && (Boolean) request.getAttribute("isSaved")) { %>
                        <i class="fas fa-bookmark"></i>
                    <% } else { %>
                        <i class="far fa-bookmark"></i>
                    <% } %>
                </button>
            </form>
        </div>
    </div>

    <div class="movie-details">
        <h1 class="movie-title">
            <%= request.getAttribute("title") %>
            <span class="year">(<%= request.getAttribute("year") %>)</span>
        </h1>

        <div class="movie-meta">
            <span><i class="fas fa-calendar-alt"></i> <%= request.getAttribute("year") %></span>
            <% if (!"series".equalsIgnoreCase((String) request.getAttribute("type"))) { %>
                <span><i class="fas fa-clock"></i> <%= request.getAttribute("runtime") %></span>
            <% } %>
            <span><i class="fas fa-film"></i> <%= request.getAttribute("genre") %></span>
            <% if ("series".equalsIgnoreCase((String) request.getAttribute("type")) && request.getAttribute("totalSeasons") != null) { %>
                            <span><i class="fas fa-tv"></i> <%= request.getAttribute("totalSeasons") %> Seasons</span>
            <% } %>
            <span class="rating-badge">
                <i class="fas fa-star"></i> <%= request.getAttribute("imdb_rate") %>
            </span>
        </div>

        <p class="movie-plot"><span class="label">Plot:</span> <%= request.getAttribute("plot") %></p>

        <div class="details-grid">
            <div class="detail-item">
                <h3><i class="fas fa-calendar-check"></i> Released</h3>
                <p><%= request.getAttribute("released") %></p>
            </div>

                <div class="detail-item">
                    <h3><i class="fas fa-tv"></i> Type</h3>
                    <p><%= request.getAttribute("type") %></p>
                </div>

               <% if ("series".equalsIgnoreCase((String) request.getAttribute("type")) && request.getAttribute("totalSeasons") != null) { %>
                            <div class="detail-item">
                                <h3><i class="fas fa-list-ol"></i> Total Seasons</h3>
                                <p><%= request.getAttribute("totalSeasons") %></p>
                            </div>
                        <% } %>

            <div class="detail-item">
                <h3><i class="fas fa-user-tie"></i> Director</h3>
                <p><%= request.getAttribute("director") %></p>
            </div>

            <div class="detail-item">
                <h3><i class="fas fa-pen"></i> Writer</h3>
                <p><%= request.getAttribute("writer") %></p>
            </div>

            <div class="detail-item">
                <h3><i class="fas fa-users"></i> Actors</h3>
                <p><%= request.getAttribute("actor") %></p>
            </div>

            <div class="detail-item">
                <h3><i class="fas fa-language"></i> Language</h3>
                <p><%= request.getAttribute("language") %></p>
            </div>

            <div class="detail-item">
                <h3><i class="fas fa-globe"></i> Country</h3>
                <p><%= request.getAttribute("country") %></p>
            </div>

            <div class="detail-item">
                <h3><i class="fas fa-trophy"></i> Awards</h3>
                <p><%= request.getAttribute("award") %></p>
            </div>

            <div class="detail-item">
                <h3><i class="fas fa-chart-line"></i> Metascore</h3>
                <p><%= request.getAttribute("metascore") %></p>
            </div>

            <div class="detail-item">
                <h3><i class="fas fa-thumbs-up"></i> IMDb Votes</h3>
                <p><%= request.getAttribute("imdb_vote") %></p>
            </div>

            <% if (request.getAttribute("collection") != null && !((String) request.getAttribute("collection")).isEmpty()) { %>
                <div class="detail-item">
                    <h3><i class="fas fa-money-bill-wave"></i> Box Office</h3>
                    <p><%= request.getAttribute("collection") %></p>
                </div>
            <% } %>
        </div>

        <div class="action-buttons">
            <a href="javascript:history.back()" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Search
            </a>
        </div>
    </div>
</div>

<!-- Footer -->
<footer>
    <div class="footer-content">
        <div class="footer-links">
            <a href="#">Home</a>
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
</script>
</body>
</html>