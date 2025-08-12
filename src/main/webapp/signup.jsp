<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaFlix - Sign Up</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel = "stylesheet" href = "assets/css/signup.css">
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

<!-- Signup Container -->
<div class="signup-container">
    <!-- Signup Hero Section -->
    <div class="signup-hero">
        <h2>Join JavaFlix Today</h2>
        <p>Create your account to unlock all features and start building your personal movie collection.</p>

        <ul class="benefits-list">
            <li>
                <i class="fas fa-check-circle"></i>
                <span>Save your favorite movies</span>
            </li>
            <li>
                <i class="fas fa-check-circle"></i>
                <span>Get personalized recommendations</span>
            </li>
            <li>
                <i class="fas fa-check-circle"></i>
                <span>Access detailed movie information</span>
            </li>
            <li>
                <i class="fas fa-check-circle"></i>
                <span>Create custom watchlists</span>
            </li>
        </ul>
    </div>

    <!-- Signup Form -->
    <div class="signup-form-container">
        <form class="signup-form" action="sendOtp" method="POST">
            <div class="form-header">
                <h2>Create Account</h2>
                <p>Fill in your details to get started</p>
            </div>

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Enter your username" required>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Create a password" required>
                <i class="fas fa-eye password-toggle" id="togglePassword"></i>
            </div>

            <div class="form-group">
                <label for="confirm-password">Confirm Password</label>
                <input type="password" id="confirm-password" name="confirm-password" class="form-control" placeholder="Confirm your password" required>
            </div>

            <div class="terms-check">
                <input type="checkbox" id="terms" name="terms" required>
                <label for="terms">I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></label>
            </div>

            <button type="submit" class="submit-btn">Sign Up</button>

            <div class="login-link">
                Already have an account? <a href="login.jsp">Log in</a>
            </div>

            <div class="social-login">
                <p>Or sign up with</p>
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
    // Password toggle visibility for both password fields
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');
    const confirmPassword = document.querySelector('#confirm-password');

    // Create toggle for confirm password field
    const confirmToggle = document.createElement('i');
    confirmToggle.className = 'fas fa-eye password-toggle';
    confirmToggle.style.right = '15px';
    confirmToggle.style.top = '40px';
    confirmToggle.style.position = 'absolute';
    confirmToggle.style.cursor = 'pointer';
    confirmToggle.style.color = 'var(--gray)';
    confirmToggle.addEventListener('mouseenter', () => {
        confirmToggle.style.color = 'var(--light)';
    });
    confirmToggle.addEventListener('mouseleave', () => {
        confirmToggle.style.color = 'var(--gray)';
    });

    // Insert the toggle icon after the confirm password field
    const confirmPasswordGroup = document.querySelector('#confirm-password').parentNode;
    confirmPasswordGroup.style.position = 'relative';
    confirmPasswordGroup.appendChild(confirmToggle);

    // Toggle function for both fields
    function togglePasswordVisibility(field, icon) {
        const type = field.getAttribute('type') === 'password' ? 'text' : 'password';
        field.setAttribute('type', type);
        icon.classList.toggle('fa-eye');
        icon.classList.toggle('fa-eye-slash');
    }

    // Add event listeners
    togglePassword.addEventListener('click', function() {
        togglePasswordVisibility(password, this);
    });

    confirmToggle.addEventListener('click', function() {
        togglePasswordVisibility(confirmPassword, this);
    });

    // Hover effects
    [togglePassword, confirmToggle].forEach(icon => {
        icon.addEventListener('mouseenter', function() {
            this.style.color = 'var(--light)';
        });
        icon.addEventListener('mouseleave', function() {
            this.style.color = 'var(--gray)';
        });
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