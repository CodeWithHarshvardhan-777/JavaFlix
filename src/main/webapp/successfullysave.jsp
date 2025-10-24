<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Saved Successfully | JavaFlix</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/successfullysave.css">
</head>
<body>
    <div class="logo">
        <span class="java">Java</span><span class="flix">Flix</span>
    </div>

    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check"></i>
        </div>

        <h1>Movie Saved Successfully!</h1>

        <p>Your movie has been added to your watchlist. You can access it anytime from your profile.</p>

        <div class="movie-card">
            <%
                // Fetch data
                HttpSession session1 = request.getSession(false);
                String movieTitle = (String) request.getAttribute("title");
                String posterUrl = (String) session1.getAttribute("posterUrl");

                // Handle null value
                if (posterUrl == null || posterUrl.equals("N/A")) {
                    posterUrl = "https://via.placeholder.com/180x270/333333/FFFFFF?text=No+Poster";
                }
                if (movieTitle == null) movieTitle = "Untitled Movie";
            %>
            <img src="<%= posterUrl %>" alt="Movie Poster" class="movie-poster">
            <div class="movie-info">
                <div class="movie-title"><%= movieTitle %></div>
                <div class="movie-details">
                    <p>Your movie has been successfully added to your JavaFlix collection. You can now find it in your watchlist it anytime.</p>
                </div>
            </div>
        </div>

        <button class="back-btn" id="goBackBtn">
            <i class="fas fa-arrow-left"></i> Go Back
        </button>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const goBackBtn = document.getElementById('goBackBtn');

            // Main functionality: Go back in browser history
            goBackBtn.addEventListener('click', function() {
                window.history.back();
            });

            // Keyboard shortcut (Esc key to go back)
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    window.history.back();
                }
            });
        });
    </script>
</body>
</html>