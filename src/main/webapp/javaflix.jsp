<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaFlix - Discover Movies</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel = "stylesheet" href = "assets/css/homepage.css">
</head>
<body>
<!-- Loading Animation -->
<div class="loader-wrapper">
    <span class="loader"></span>
</div>

<!-- Navbar -->
<nav class="navbar">
    <div class="logo">
        <i class="fas fa-film"></i>
        <span class="java">Java</span><span class="flix">Flix</span>
    </div>

    <!-- Hamburger Menu -->
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

        <%-- Check if user is logged in --%>
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
        <div class="auth-buttons">
            <a href="login.jsp" class="login-btn"><i class="fas fa-sign-in-alt"></i> Login</a>
            <a href="signup.jsp" class="signup-btn"><i class="fas fa-user-plus"></i> Sign Up</a>
        </div>
        <% } %>
    </div>
</nav>

<!-- Hero Section with Search -->
<section class="hero">
    <h1>Discover Your Next Favorite Movie</h1>
    <p>Search through thousands of movies, save your favorites, and get detailed information about cast, ratings, and more.</p>

    <form id="searchForm" class="search-container" action="try" method="GET">
        <input type="text" id="searchInput" name="query" class="search-bar" placeholder="Search for movies..." required>
        <button type="submit" class="search-btn"><i class="fas fa-search"></i> Search</button>
    </form>
</section>

<!-- Features Section -->
<section class="features">
    <h2 class="section-title">Why Choose JavaFlix</h2>

    <div class="features-grid">
        <div class="feature-card">
            <div class="feature-icon">
                <i class="fas fa-film"></i>
            </div>
            <h3>Extensive Database</h3>
            <p>Access information on thousands of movies from various genres and eras.</p>
        </div>

        <div class="feature-card">
            <div class="feature-icon">
                <i class="fas fa-bookmark"></i>
            </div>
            <h3>Save Favorites</h3>
            <p>Create your personal collection by saving movies to watch later.</p>
        </div>

        <div class="feature-card">
            <div class="feature-icon">
                <i class="fas fa-info-circle"></i>
            </div>
            <h3>Detailed Information</h3>
            <p>Get comprehensive details about each movie including cast, crew, and ratings.</p>
        </div>
    </div>
</section>

<!-- Call to Action Section -->
<section class="cta-section">
    <div class="cta-content">
        <h2>Ready to explore?</h2>
        <p>Start your cinematic journey today and discover movies you'll love.</p>
        <a href="#searchForm" class="cta-btn">Search Movies Now</a>
    </div>
</section>

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
            <a href="#"><i class="fab fa-facebook-f"></i></a>
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-github"></i></a>
        </div>

        <p class="copyright">&copy; 2025 JavaFlix. All rights reserved.</p>
    </div>
</footer>

<script>
    // Wait for the page to load
    window.addEventListener('load', function() {
        // Hide loader and show content
        setTimeout(function() {
            document.querySelector('.loader-wrapper').classList.add('hidden');
            document.body.classList.add('loaded');

            // Clear the search input on page load/refresh
            document.getElementById('searchInput').value = '';
        }, 1000); // Adjust timing as needed
    });

    // Hamburger menu functionality
    const hamburger = document.querySelector('.hamburger');
    const navLinks = document.querySelector('.nav-links');

    hamburger.addEventListener('click', () => {
        hamburger.classList.toggle('active');
        navLinks.classList.toggle('active');

        // Toggle body overflow when menu is open
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

    // Navbar background change on scroll
    window.addEventListener('scroll', () => {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // Close menu when clicking outside
    document.addEventListener('click', (e) => {
        if (!navLinks.contains(e.target) && !hamburger.contains(e.target)) {
            hamburger.classList.remove('active');
            navLinks.classList.remove('active');
            document.body.style.overflow = '';
        }
    });

    // Profile dropdown functionality
    const profileBtn = document.getElementById('profileBtn');
    const profileDropdown = document.getElementById('profileDropdown');

    if (profileBtn && profileDropdown) {
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            profileDropdown.classList.toggle('active');
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', () => {
            profileDropdown.classList.remove('active');
        });

        // Prevent dropdown from closing when clicking inside it
        profileDropdown.addEventListener('click', (e) => {
            e.stopPropagation();
        });
    }

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();

            const targetId = this.getAttribute('href');
            if (targetId === '#') return;

            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80,
                    behavior: 'smooth'
                });
            }
        });
    });
</script>
</body>
</html>