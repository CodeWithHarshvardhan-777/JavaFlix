package com.flix;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;



@WebServlet("/SaveChanges")
public class SaveChanges extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        String userID = (String) session.getAttribute("userID");
        String email = (String) session.getAttribute("email");
        String phone = req.getParameter("phone");
        String bio = req.getParameter("bio");


        final String DB_USER = "root";
        final String DB_PASSWORD = "Harsh$1000Pande";
        final String DB_URL = "jdbc:mysql://localhost:3307/javaflix";

        Connection connection = null;
        PreparedStatement preparedStatement = null;


        try {
            connection = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
            String query = "UPDATE users SET mobile_number = ?, bio = ? WHERE email = ? AND userID = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1,phone);
            preparedStatement.setString(2,bio);
            preparedStatement.setString(3,email);
            preparedStatement.setString(4,userID);
            int i = preparedStatement.executeUpdate();
            if (i > 0) {
                req.setAttribute("success", "Successfully Saved Changes");
            } else {
                req.setAttribute("error", "Error Found During Save Changes");
            }

            RequestDispatcher dispatcher = req.getRequestDispatcher("setting.jsp");
            dispatcher.forward(req,resp);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }
}
