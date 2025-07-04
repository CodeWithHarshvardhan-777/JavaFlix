package com.flix;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/savemovie")
public class savemovies extends HttpServlet {
    Connection connection = null;
    PreparedStatement preparedStatement;
    final String url = "jdbc:mysql://localhost:3307/javaflix";
    final String password = "Harsh$1000Pande";
    final String user = "root";
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession httpSession = req.getSession();
        String imdb = req.getParameter("imdbID");
        String title = req.getParameter("title");
        String image_url = (String) httpSession.getAttribute("url");
        String type = req.getParameter("type");
        String totalSeasons = req.getParameter("totalSeasons");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url,user,password);
            String query = "INSERT INTO movie (url,title,imdb,type,totalseason) VALUES (?,?,?,?,?)";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1,image_url);
            preparedStatement.setString(2,title);
            preparedStatement.setString(3,imdb);
            preparedStatement.setString(4,type);
            preparedStatement.setString(5,totalSeasons);

            preparedStatement.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
