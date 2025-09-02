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
import java.sql.ResultSet;


@WebServlet("/ChangeEmail")
public class ChangeEmail extends HttpServlet {

    public static String checkLogin(String email, String password) {
        final String DB_USER = "root";
        final String DB_PASSWORD = "Harsh$1000Pande";
        final String DB_URL = "jdbc:mysql://localhost:3307/javaflix";

        String status = "error";

        String query = "SELECT password FROM users WHERE email = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    String storedHash = resultSet.getString("password");
                    boolean isVerified = com.password4j.Password.check(password, storedHash).withArgon2();

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
            String current_Email = req.getParameter("currentEmail");
            String new_Email = req.getParameter("newEmail");
            String password = req.getParameter("password");

            String result = checkLogin(current_Email,password);

            switch (result)
            {
                case "wrong_password":
                    req.setAttribute("error","Incorrect Password");
                    RequestDispatcher requestDispatcher = req.getRequestDispatcher("setting.jsp");
                    requestDispatcher.forward(req,resp);
                    break;

                case "email_notFound":
                    req.setAttribute("error","Email is Not Register");
                    RequestDispatcher requestDispatcher2 = req.getRequestDispatcher("setting.jsp");
                    requestDispatcher2.forward(req,resp);
                    break;

                case "user_found":
                default:
                    if(current_Email.equals(new_Email))
                    {
                        req.setAttribute("error","Enter Another Email");
                        RequestDispatcher requestDispatcher3 = req.getRequestDispatcher("setting.jsp");
                        requestDispatcher3.forward(req,resp);
                        return;
                    }
                    String otp = Otp.GenrateOtp();
                    HttpSession session = req.getSession(false);
                    session.setAttribute("currentEmail",current_Email);
                    session.setAttribute("newEmail",new_Email);
                    session.setAttribute("password",password);
                    session.setAttribute("otp",otp);
                    if(Email.sendVerificationOTP(new_Email,otp))
                    {
                        req.setAttribute("success","OTP sent successfully");
                        RequestDispatcher requestDispatcher4 = req.getRequestDispatcher("emailchangeotp.jsp");
                        requestDispatcher4.forward(req,resp);
                        return;
                    }
                    break;
            }

    }
}
