<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaFlix - <%= request.getAttribute("title") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel ="stylesheet" href ="CSS/resultpage.css">
    <style>

        .alert {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            border-radius: 5px;
            color: white;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            z-index: 2000;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            transform: translateX(120%);
            transition: transform 0.3s ease-out;
            max-width: 350px;
        }

        .alert.show {
            transform: translateX(0);
        }

        .alert-success {
            background-color: #28a745;
            border-left: 5px solid #218838;
        }

        .alert-error {
            background-color: #dc3545;
            border-left: 5px solid #c82333;
        }

        .alert i {
            font-size: 1.2rem;
        }

        .close-alert {
            margin-left: auto;
            cursor: pointer;
            opacity: 0.8;
            transition: opacity 0.2s;
        }

        .close-alert:hover {
            opacity: 1;
        }
    </style>
</head>
<body>
<!-- Alert Sections -->
<% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success" id="successAlert">
        <i class="fas fa-check-circle"></i>
        <span><%= request.getAttribute("success") %></span>
        <span class="close-alert" onclick="closeAlert('successAlert')">&times;</span>
    </div>
<% } %>

<% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error" id="errorAlert">
        <i class="fas fa-exclamation-circle"></i>
        <span><%= request.getAttribute("error") %></span>
        <span class="close-alert" onclick="closeAlert('errorAlert')">&times;</span>
    </div>
<% } %>

<!-- Navbar -->
<nav class="navbar">
    <a href="index.jsp" class="logo">Java<span>Flix</span></a>

    <!-- Hamburger Menu -->
    <div class="hamburger">
        <span class="bar"></span>
        <span class="bar"></span>
        <span class="bar"></span>
    </div>

    <div class="nav-container">
        <!-- Search Bar -->
        <div class="search-container">
            <i class="fas fa-search search-icon"></i>
            <form action="try" method="get" id="searchForm">
                <input type="text" class="search-input" name="query" placeholder="Search movies..." autocomplete="off">
            </form>
        </div>

        <div class="nav-links">
            <a href="javaflix.jsp">Home</a>
            <a href="viewSaveMovies.jsp">Saved Movies</a>
            <a href="#">About</a>
            <a href="#">Contact</a>
        </div>
    </div>
</nav>

<!-- Main Content -->
<main class="main-content">
    <!-- Movie Details Section -->
    <div class="movie-container">
        <div class="movie-poster-container">
            <div class="movie-poster">
                <% String posterUrl = (String) request.getAttribute("poster");
                   boolean hasPoster = posterUrl != null && !posterUrl.equals("N/A"); %>
                <% if (hasPoster) { %>
                    <img src="<%= posterUrl %>" alt="<%= request.getAttribute("title") %> Poster"
                         onerror="this.onerror=null;this.parentElement.innerHTML='<div class=\'poster-error\'><i class=\'fas fa-image\'></i><p>Poster Not Available</p></div>'">
                <% } else { %>
                    <div class="poster-error">
                        <i class="fas fa-image"></i>
                        <p>Poster Not Available</p>
                    </div>
                <% } %>
              <form action="savemovie" method="post" id="saveForm">
                    <%
                        HttpSession sessionObj = request.getSession(false);
                        sessionObj.setAttribute("posterUrl", posterUrl);
                    %>
                    <input type="hidden" name="title" value="<%= request.getAttribute("title") %>">
                    <input type="hidden" name="year" value="<%= request.getAttribute("year") %>">
                    <input type="hidden" name="type" value="<%= request.getAttribute("type") %>">
                    <input type="hidden" name="image" value="<%= request.getAttribute("poster") %>">
                    <input type="hidden" name="runtime" value="<%= request.getAttribute("runtime") %>">
                    <input type="hidden" name="language" value="<%= request.getAttribute("language") %>">
                    <input type="hidden" name="imdb" value="<%= request.getAttribute("imdb_rate") %>">
                    <input type="hidden" name="totalSeasons" value="<%= request.getAttribute("totalSeasons") != null ? request.getAttribute("totalSeasons") : "" %>">
                    <button type="submit" class="save-btn" id="saveBtn" aria-label="<%= request.getAttribute("isSaved") != null && (Boolean) request.getAttribute("isSaved") ? "Remove from saved" : "Save movie" %>">
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
                <span><i class="fas fa-id-card"></i> <span class="imdb-id"><%= request.getAttribute("imdbID") %></span></span>
                <% if (request.getAttribute("rating") != null && !((String) request.getAttribute("rating")).equals("N/A")) { %>
                    <span><span class="rated-badge"><%= request.getAttribute("rating") %></span></span>
                <% } %>
                <span><i class="fas fa-calendar-alt"></i> <%= request.getAttribute("year") %></span>
                <% if (!"series".equalsIgnoreCase((String) request.getAttribute("type")) && request.getAttribute("runtime") != null && !((String) request.getAttribute("runtime")).equals("N/A")) { %>
                    <span><i class="fas fa-clock"></i> <span class="runtime"><%= request.getAttribute("runtime") %></span></span>
                <% } %>
                <% if (request.getAttribute("genre") != null && !((String) request.getAttribute("genre")).equals("N/A")) { %>
                    <span><i class="fas fa-film"></i> <%= request.getAttribute("genre") %></span>
                <% } %>
                <% if ("series".equalsIgnoreCase((String) request.getAttribute("type")) && request.getAttribute("totalSeasons") != null && !((String) request.getAttribute("totalSeasons")).equals("N/A")) { %>
                    <span><i class="fas fa-tv"></i> <%= request.getAttribute("totalSeasons") %> Seasons</span>
                <% } %>
                <% if (request.getAttribute("imdb_rate") != null && !((String) request.getAttribute("imdb_rate")).equals("N/A")) { %>
                    <span class="rating-badge">
                        <i class="fas fa-star"></i> <%= request.getAttribute("imdb_rate") %>/10
                    </span>
                <% } %>
            </div>

            <% if (request.getAttribute("plot") != null && !((String) request.getAttribute("plot")).equals("N/A")) { %>
                <p class="movie-plot"><span class="label">Plot:</span> <%= request.getAttribute("plot") %></p>
            <% } else { %>
                <p class="movie-plot"><span class="label">Plot:</span> No plot information available.</p>
            <% } %>

            <div class="details-grid">
                <% if (request.getAttribute("released") != null && !((String) request.getAttribute("released")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-calendar-check"></i> Released</h3>
                        <p><%= request.getAttribute("released") %></p>
                    </div>
                <% } %>

                <div class="detail-item">
                    <h3><i class="fas fa-tv"></i> Type</h3>
                    <p><%= request.getAttribute("type") %></p>
                </div>

                <% if ("series".equalsIgnoreCase((String) request.getAttribute("type")) && request.getAttribute("totalSeasons") != null && !((String) request.getAttribute("totalSeasons")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-list-ol"></i> Total Seasons</h3>
                        <p><%= request.getAttribute("totalSeasons") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("director") != null && !((String) request.getAttribute("director")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-user-tie"></i> Director</h3>
                        <p><%= request.getAttribute("director") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("writer") != null && !((String) request.getAttribute("writer")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-pen"></i> Writer</h3>
                        <p><%= request.getAttribute("writer") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("actor") != null && !((String) request.getAttribute("actor")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-users"></i> Actors</h3>
                        <p><%= request.getAttribute("actor") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("language") != null && !((String) request.getAttribute("language")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-language"></i> Language</h3>
                        <p><%= request.getAttribute("language") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("country") != null && !((String) request.getAttribute("country")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-globe"></i> Country</h3>
                        <p><%= request.getAttribute("country") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("award") != null && !((String) request.getAttribute("award")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-trophy"></i> Awards</h3>
                        <p><%= request.getAttribute("award") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("metascore") != null && !((String) request.getAttribute("metascore")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-chart-line"></i> Metascore</h3>
                        <p><%= request.getAttribute("metascore") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("imdb_vote") != null && !((String) request.getAttribute("imdb_vote")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-thumbs-up"></i> IMDb Votes</h3>
                        <p><%= request.getAttribute("imdb_vote") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("collection") != null && !((String) request.getAttribute("collection")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-money-bill-wave"></i> Box Office</h3>
                        <p><%= request.getAttribute("collection") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("dvd") != null && !((String) request.getAttribute("dvd")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-compact-disc"></i> DVD Release</h3>
                        <p><%= request.getAttribute("dvd") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("production") != null && !((String) request.getAttribute("production")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-industry"></i> Production</h3>
                        <p><%= request.getAttribute("production") %></p>
                    </div>
                <% } %>

                <% if (request.getAttribute("website") != null && !((String) request.getAttribute("website")).equals("N/A")) { %>
                    <div class="detail-item">
                        <h3><i class="fas fa-globe"></i> Website</h3>
                        <p><a href="<%= request.getAttribute("website") %>" target="_blank" rel="noopener noreferrer" style="color: var(--primary);">Official Site</a></p>
                    </div>
                <% } %>
            </div>

            <div class="action-buttons">
                <a href="javascript:history.back()" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Search
                </a>
                <% if (request.getAttribute("imdbID") != null) { %>
                    <a href="https://www.imdb.com/title/<%= request.getAttribute("imdbID") %>" target="_blank" rel="noopener noreferrer" class="btn btn-secondary">
                        <i class="fab fa-imdb"></i> View on IMDb
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer>
    <div class="footer-content">
        <div class="footer-links">
            <a href="index.jsp">Home</a>
            <a href="#">About</a>
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">Contact</a>
        </div>

        <div class="social-icons">
            <a href="#" aria-label="Facebook"><i class="fab fa-facebook"></i></a>
            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
            <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
            <a href="#" aria-label="GitHub"><i class="fab fa-github"></i></a>
        </div>

        <p class="copyright">&copy; 2025 JavaFlix. All rights reserved.</p>
    </div>
</footer>

<script>
    // Show alerts when page loads
    document.addEventListener('DOMContentLoaded', function() {
        <% if (request.getAttribute("success") != null) { %>
            setTimeout(function() {
                document.getElementById('successAlert').classList.add('show');
            }, 100);
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            setTimeout(function() {
                document.getElementById('errorAlert').classList.add('show');
            }, 100);
        <% } %>
    });

    // Close alert function
    function closeAlert(id) {
        document.getElementById(id).classList.remove('show');
        setTimeout(function() {
            document.getElementById(id).remove();
        }, 300);
    }

    // Auto-close alerts after 5 seconds
    <% if (request.getAttribute("success") != null) { %>
        setTimeout(function() {
            closeAlert('successAlert');
        }, 5000);
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
        setTimeout(function() {
            closeAlert('errorAlert');
        }, 5000);
    <% } %>

    // Hamburger menu functionality
    const hamburger = document.querySelector('.hamburger');
    const navContainer = document.querySelector('.nav-container');

    hamburger.addEventListener('click', () => {
        hamburger.classList.toggle('active');
        navContainer.classList.toggle('active');
    });

    // Close menu when clicking on a link
    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
            hamburger.classList.remove('active');
            navContainer.classList.remove('active');
        });
    });

    // Bookmark animation
    const saveBtn = document.getElementById('saveBtn');
    if (saveBtn) {
        saveBtn.addEventListener('click', function() {
            this.classList.add('animate');
            setTimeout(() => {
                this.classList.remove('animate');
            }, 1000);

            // Toggle bookmark icon
            const icon = this.querySelector('i');
            if (icon.classList.contains('far')) {
                icon.classList.remove('far');
                icon.classList.add('fas');
                this.setAttribute('aria-label', 'Remove from saved');
            } else {
                icon.classList.remove('fas');
                icon.classList.add('far');
                this.setAttribute('aria-label', 'Save movie');
            }
        });
    }

    // Handle poster image error
    document.querySelectorAll('.movie-poster img').forEach(img => {
        img.addEventListener('error', function() {
            this.parentElement.innerHTML = '<div class="poster-error"><i class="fas fa-image"></i><p>Poster Not Available</p></div>';
        });
    });

    // Search functionality
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            const searchInput = this.querySelector('.search-input');
            if (searchInput.value.trim() === '') {
                e.preventDefault();
                searchInput.focus();
                // Add shake animation
                searchInput.style.animation = 'shake 0.5s';
                setTimeout(() => {
                    searchInput.style.animation = '';
                }, 500);
            }
        });
    }

    // Add shake animation for empty search
    const style = document.createElement('style');
    style.textContent = `
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-5px); }
            40%, 80% { transform: translateX(5px); }
        }
    `;
    document.head.appendChild(style);
</script>
</body>
</html>