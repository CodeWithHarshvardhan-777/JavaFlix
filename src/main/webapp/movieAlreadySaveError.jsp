<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Already Saved | JavaFlix</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
     <link rel ="stylesheet" href ="CSS/movieAlreadySaveError.css">
</head>
<body>
    <div class="logo">
        <span class="java">Java</span><span class="flix">Flix</span>
    </div>

    <div class="info-container">
        <div class="info-icon">
            <i class="fas fa-info-circle"></i>
        </div>

        <h1>Movie Already Saved</h1>

        <p>This movie is already in your watchlist. You can find it in your profile anytime.</p>

        <div class="movie-info-box">
            <%
                // Get movie data from request attributes with null safety
                HttpSession session1 = request.getSession();
                String movieTitle = (String) request.getAttribute("title");
                String posterUrl = (String) session1.getAttribute("posterUrl");
                String rating = (String) request.getAttribute("rating");
                String genre = (String) request.getAttribute("genre");

                // Set default
                if (movieTitle == null) movieTitle = "Unknown Movie";
                if (posterUrl == null || posterUrl.trim().isEmpty()) {
                    posterUrl = "https://via.placeholder.com/120x180/333/666?text=No+Image";
                }
                if (rating == null) rating = "N/A";
                if (genre == null) genre = "Not specified";
            %>
            <img src="<%= posterUrl %>" alt="<%= movieTitle %> Poster" class="movie-poster"
                 onerror="this.src='https://via.placeholder.com/120x180/333/666?text=No+Image'">
            <div class="movie-details">
                <h3><%= movieTitle %></h3>
                <div class="rating">
                    <i class="fas fa-star"></i> <%= rating %>
                </div>
                <div class="genre"><%= genre %></div>
                <span class="already-saved-badge">
                    <i class="fas fa-check"></i> Already in Watchlist
                </span>
            </div>
        </div>

        <div class="suggestion-info">
            <p><strong>Looking for something else?</strong></p>
            <p>Browse our collection to find other great movies to add to your watchlist.</p>
        </div>

        <div class="action-buttons">
            <button class="btn btn-primary" id="goBackBtn">
                <i class="fas fa-arrow-left"></i> Go Back
            </button>

            <a href="watchlist.jsp" class="btn btn-watchlist">
                <i class="fas fa-list"></i> View Watchlist
            </a>

            <a href="browse.jsp" class="btn btn-secondary">
                <i class="fas fa-compass"></i> Browse Movies
            </a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const goBackBtn = document.getElementById('goBackBtn');

            // Go back in browser history
            goBackBtn.addEventListener('click', function() {
                if (window.history.length > 1) {
                    window.history.back();
                } else {
                    window.location.href = 'index.jsp';
                }
            });

            // Keyboard shortcut (Esc key to go back)
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    if (window.history.length > 1) {
                        window.history.back();
                    } else {
                        window.location.href = 'index.jsp';
                    }
                }
            });
        });
    </script>
</body>
</html>