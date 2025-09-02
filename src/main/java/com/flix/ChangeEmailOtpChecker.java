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

@WebServlet("/ChangeEmailOtpChecker")
public class ChangeEmailOtpChecker extends HttpServlet {

    public static String ChangeEmail(String userID, String password, String newEmail) {
        final String DB_USER = "root";
        final String DB_PASSWORD = "Harsh$1000Pande";
        final String DB_URL = "jdbc:mysql://localhost:3307/javaflix";

        String change = "";

        String query = "SELECT password FROM users WHERE userID = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement preparedStatement = connection.prepareStatement(query)) {

                preparedStatement.setString(1, userID);

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {

                        String hash_password = resultSet.getString("password");

                        boolean isVerified = com.password4j.Password.check(password, hash_password).withArgon2();

                        if (isVerified) {

                            String updateQuery = "UPDATE users SET email = ? WHERE userID = ?";
                            try (PreparedStatement updateStmt = connection.prepareStatement(updateQuery)) {
                                updateStmt.setString(1, newEmail);
                                updateStmt.setString(2, userID);

                                int rows = updateStmt.executeUpdate();
                                if (rows > 0) {
                                    change = "change";
                                }
                            }
                        } else {
                            change = "password_incorrect";
                        }
                    } else {
                        change = "user_not_found";
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return change;
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String otp1 = req.getParameter("digit1");
        String otp2 = req.getParameter("digit2");
        String otp3 = req.getParameter("digit3");
        String otp4 = req.getParameter("digit4");
        String otp5 = req.getParameter("digit5");
        String otp6 = req.getParameter("digit6");

        HttpSession httpSession = req.getSession();

        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(otp1);
        stringBuilder.append(otp2);
        stringBuilder.append(otp3);
        stringBuilder.append(otp4);
        stringBuilder.append(otp5);
        stringBuilder.append(otp6);

        String enter_OTP = stringBuilder.toString();
        String server_OTP = (String) httpSession.getAttribute("otp");

        if (enter_OTP.equals(server_OTP))
        {
            HttpSession session = req.getSession(false);
            String userID = (String) session.getAttribute("userID");
            String newEmail = (String) session.getAttribute("newEmail");
            String password = (String) session.getAttribute("password");

            String result = ChangeEmail(userID, password, newEmail);

            switch (result) {
                case "password_incorrect":
                    req.setAttribute("error", "Password is incorrect.");
                    req.getRequestDispatcher("setting.jsp").forward(req, resp);
                    break;

                case "change":
                default:
                    req.setAttribute("success", "Email changed successfully.");
                    req.getRequestDispatcher("setting.jsp").forward(req, resp);
                    break;
            }
        } else {
            req.setAttribute("error", "Entered OTP is incorrect.");
            req.getRequestDispatcher("emailchangeotp.jsp").forward(req, resp);
        }
    }
}
