package com.flix;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginProcess extends HttpServlet {

    public static String FetchUserName(String email) {
        final String DB_USER = "root";
        final String DB_PASSWORD = "Harsh$1000Pande";
        final String DB_URL = "jdbc:mysql://localhost:3307/javaflix";

        String username = "";

        String query = "SELECT username FROM users WHERE email = ?";

        try  {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    username = resultSet.getString("username");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
             username = "error";
        }

        return username;
    }

    public static String FetchUserID(String email) {
        final String DB_USER = "root";
        final String DB_PASSWORD = "Harsh$1000Pande";
        final String DB_URL = "jdbc:mysql://localhost:3307/javaflix";

        String userID = "";

        String query = "SELECT userID FROM users WHERE email = ?";

        try  {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    userID = resultSet.getString("userID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            userID = "error";
        }

        return userID;
    }

    public static String checkLogin(String email, String password) {
        final String DB_USER = "root";
        final String DB_PASSWORD = "Harsh$1000Pande";
        final String DB_URL = "jdbc:mysql://localhost:3307/javaflix";

        String status = "error";

        String query = "SELECT password FROM users WHERE email = ?";

        try  {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    String storedHash = resultSet.getString("password");
                    boolean isVerified = com.password4j.Password.check(password,storedHash).withArgon2();

                    if (isVerified) {
                        status = "user_found";
                    } else {
                        status = "wrong_password";
                    }
                } else {
                    status = "email_notFound";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            status = "error";
        }

        return status;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("username");
        String password = req.getParameter("password");

        String result = checkLogin(email, password);

        switch (result) {
            case "user_found":
                HttpSession session = req.getSession(false);
                String username = FetchUserName(email);
                String userID = FetchUserID(email);
                if(username.equals("error"))
                {
                    req.setAttribute("error", "Error During Find Username.");
                    break;
                }
                if (userID.equals("error"))
                {
                    req.setAttribute("error", "Error During Find UserID.");
                    break;
                }
                session.setAttribute("username",username);
                session.setAttribute("userID",userID);
                session.setAttribute("email",email);
                resp.sendRedirect("javaflix.jsp");
                return;

            case "email_notFound":
                req.setAttribute("error", "Email is not registered.");
                break;

            case "wrong_password":
                req.setAttribute("error", "Incorrect password.");
                break;

            case "error":
            default:
                req.setAttribute("error", "Server error. Please try again later.");
                break;
        }

        RequestDispatcher dispatcher = req.getRequestDispatcher("login.jsp");
        dispatcher.forward(req, resp);
    }
}
