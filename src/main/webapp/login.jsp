<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaFlix - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel ="stylesheet" href ="CSS/login.css">
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
        <a href="index.html">Home</a>
        <a href="viewSaveMovies.jsp">Saved Movies</a>
        <a href="#">About</a>
        <a href="#">Contact</a>
    </div>
</nav>

<!-- Error Message -->
<% if(request.getAttribute("error") != null) { %>
    <div class="error-message" id="errorMessage">
        <%= request.getAttribute("error") %>
    </div>
<% } %>

<!-- Login Container -->
<div class="login-container">
    <!-- Login Hero Section -->
    <div class="login-hero">
        <h2>Welcome Back to JavaFlix</h2>
        <p>Sign in to access your personal movie collection and discover new recommendations tailored just for you.</p>

        <ul class="benefits-list">
            <li>
                <i class="fas fa-check-circle"></i>
                <span>Access your saved movies</span>
            </li>
            <li>
                <i class="fas fa-check-circle"></i>
                <span>Continue where you left off</span>
            </li>
            <li>
                <i class="fas fa-check-circle"></i>
                <span>Get personalized recommendations</span>
            </li>
            <li>
                <i class="fas fa-check-circle"></i>
                <span>Manage your watchlists</span>
            </li>
        </ul>
    </div>

    <!-- Login Form -->
    <div class="login-form-container">
        <form class="login-form" action="login" method="POST">
            <div class="form-header">
                <h2>Sign In</h2>
                <p>Welcome back! Please enter your details</p>
            </div>

            <div class="form-group">
                <label for="username">Username or Email</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Enter your username or email" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
                <i class="fas fa-eye password-toggle" id="togglePassword"></i>
            </div>

            <div class="remember-forgot">
                <div class="remember-me">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">Remember me</label>
                </div>
                <div class="forgot-password">
                    <a href="forgot-password.jsp">Forgot password?</a>
                </div>
            </div>

            <button type="submit" class="submit-btn">Sign In</button>

            <div class="signup-link">
                Don't have an account? <a href="signup.jsp">Sign up</a>
            </div>

            <div class="social-login">
                <p>Or sign in with</p>
                <div class="social-icons">
                    <div class="social-btn facebook">
                        <i class="fab fa-facebook-f"></i>
                    </div>
                    <div class="social-btn google">
                        <i class="fab fa-google"></i>
                    </div>
                    <div class="social-btn twitter">
                        <i class="fab fa-twitter"></i>
                    </div>
                </div>
            </div>
        </form>
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

        <p class="copyright">&copy; 2025 JavaFlix. All rights reserved.</p>
    </div>
</footer>

<script>
    // Password toggle visibility
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');

    // Toggle function
    function togglePasswordVisibility(field, icon) {
        const type = field.getAttribute('type') === 'password' ? 'text' : 'password';
        field.setAttribute('type', type);
        icon.classList.toggle('fa-eye');
        icon.classList.toggle('fa-eye-slash');
    }

    // Add event listener
    togglePassword.addEventListener('click', function() {
        togglePasswordVisibility(password, this);
    });

    // Hover effect
    togglePassword.addEventListener('mouseenter', function() {
        this.style.color = 'var(--light)';
    });
    togglePassword.addEventListener('mouseleave', function() {
        this.style.color = 'var(--gray)';
    });

    // Error message handling
    document.addEventListener('DOMContentLoaded', function() {
        const errorMessage = document.getElementById('errorMessage');

        if (errorMessage) {
            // Show the error message
            setTimeout(() => {
                errorMessage.classList.add('show');
            }, 100);

            // Hide after 4 seconds
            setTimeout(() => {
                errorMessage.classList.remove('show');
                errorMessage.classList.add('hide');

                // Remove from DOM after animation completes
                setTimeout(() => {
                    errorMessage.remove();
                }, 300);
            }, 4000);
        }
    });

    // Mobile menu toggle
    const hamburger = document.querySelector('.hamburger');
    const navLinks = document.querySelector('.nav-links');

    hamburger.addEventListener('click', () => {
        hamburger.classList.toggle('active');
        navLinks.classList.toggle('active');
    });

    // Close mobile menu when clicking a link
    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
            hamburger.classList.remove('active');
            navLinks.classList.remove('active');
        });
    });

    // Navbar scroll effect
    window.addEventListener('scroll', () => {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
</script>
</body>
</html>