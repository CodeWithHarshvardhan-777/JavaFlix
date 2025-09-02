<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
     String dispatcher_email = (String) session.getAttribute("newEmail");
      if (dispatcher_email == null || dispatcher_email.isEmpty()) {
          response.sendRedirect("AccessRestricted.html");
          return;
      }
 %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaFlix - OTP Verification</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel ="stylesheet" href ="CSS/emailchangeotp.css">
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

<!-- Success Message -->
<% if(request.getAttribute("success") != null) { %>
    <div class="success-message" id="successMessage">
        <%= request.getAttribute("success") %>
    </div>
<% } %>

<!-- Verification Container -->
<div class="verification-container">
    <!-- Verification Hero Section -->
    <div class="verification-hero">
        <h2>Verify Your Account</h2>
        <p>We've sent a verification code to your email address. Please enter the code below to complete your registration.</p>
    </div>

    <!-- Verification Form -->
    <div class="verification-form-container">
        <form class="verification-form" action="ChangeEmailOtpChecker" method="post">
            <div class="form-header">
                <h2>OTP Verification</h2>
                <p>Enter the 6-digit code sent to your email</p>
            </div>

            <div class="otp-message">
                A verification code has been sent to: <br>
                <strong><%= dispatcher_email %></strong>
            </div>

            <div class="otp-inputs">
                <input type="text" name="digit1" class="otp-input" maxlength="1" pattern="[0-9]" required>
                <input type="text" name="digit2" class="otp-input" maxlength="1" pattern="[0-9]" required>
                <input type="text" name="digit3" class="otp-input" maxlength="1" pattern="[0-9]" required>
                <input type="text" name="digit4" class="otp-input" maxlength="1" pattern="[0-9]" required>
                <input type="text" name="digit5" class="otp-input" maxlength="1" pattern="[0-9]" required>
                <input type="text" name="digit6" class="otp-input" maxlength="1" pattern="[0-9]" required>
            </div>

            <div class="resend-otp">
                Didn't receive the code? <a id="resendLink">Resend OTP</a>
                <span id="countdown" style="display: none;"> (60s)</span>
            </div>

            <button type="submit" class="submit-btn">Verify Account</button>

            <div class="back-to-signup">
                Need to change your email? <a href="signup.jsp">Go back</a>
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
    // Auto-focus and move between OTP inputs
    const otpInputs = document.querySelectorAll('.otp-input');

    otpInputs.forEach((input, index) => {
        // Focus on first input when page loads
        if (index === 0) {
            input.focus();
        }

        // Move to next input when a digit is entered
        input.addEventListener('input', (e) => {
            if (e.target.value.length === 1) {
                if (index < otpInputs.length - 1) {
                    otpInputs[index + 1].focus();
                }
            }
        });

        // Move to previous input when backspace is pressed on empty input
        input.addEventListener('keydown', (e) => {
            if (e.key === 'Backspace' && e.target.value === '' && index > 0) {
                otpInputs[index - 1].focus();
            }
        });
    });

    // Error message handling
    document.addEventListener('DOMContentLoaded', function() {
        const errorMessage = document.getElementById('errorMessage');
        const successMessage = document.getElementById('successMessage');

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

        if (successMessage) {
            // Show the success message
            setTimeout(() => {
                successMessage.classList.add('show');
            }, 100);

            // Hide after 4 seconds
            setTimeout(() => {
                successMessage.classList.remove('show');
                successMessage.classList.add('hide');

                // Remove from DOM after animation completes
                setTimeout(() => {
                    successMessage.remove();
                }, 300);
            }, 4000);
        }
    });

    // Resend OTP functionality (frontend only - shows countdown)
    const resendLink = document.getElementById('resendLink');
    const countdown = document.getElementById('countdown');

    resendLink.addEventListener('click', function(e) {
        e.preventDefault();

        // Disable the resend link
        resendLink.style.pointerEvents = 'none';
        resendLink.style.opacity = '0.5';
        countdown.style.display = 'inline';

        // Start countdown from 60 seconds
        let seconds = 60;
        countdown.textContent = ` (${seconds}s)`;

        const timer = setInterval(() => {
            seconds--;
            countdown.textContent = ` (${seconds}s)`;

            if (seconds <= 0) {
                clearInterval(timer);
                resendLink.style.pointerEvents = 'auto';
                resendLink.style.opacity = '1';
                countdown.style.display = 'none';
            }
        }, 1000);
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