package com.flix;

import com.password4j.Hash;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.*;

@WebServlet("/SignUp")
public class SignUpProcess extends HttpServlet {

    public static String GenrateID() {
        final String Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        final SecureRandom secureRandom = new SecureRandom();

        StringBuilder stringBuilder = new StringBuilder(12);
        for (int i = 0; i < 12; i++) {
            stringBuilder.append(Characters.charAt(secureRandom.nextInt(Characters.length())));
        }
        return stringBuilder.toString();
    }
    public static boolean signUp(String userID,String userName, String email, String passcode)
    {

        boolean dataStore = false;
        final String url = "jdbc:mysql://localhost:3307/javaflix";
        final String db_password = "Harsh$1000Pande";
        final String user = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url,user,db_password);
            String query = "INSERT INTO users (userID,username,email,password) VALUES (?,?,?,?)";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            Hash hash = com.password4j.Password.hash(passcode).addRandomSalt().withArgon2();
            String hash_password = hash.getResult();
            preparedStatement.setString(1,userID);
            preparedStatement.setString(2,userName);
            preparedStatement.setString(3,email);
            preparedStatement.setString(4,hash_password);

            int rows = preparedStatement.executeUpdate();
            if(rows > 0)
            {
                dataStore = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dataStore;
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String username = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");
        String email = (String) session.getAttribute("email");
        String userID = GenrateID();
        session.setAttribute("userID",userID);

        if(!signUp(userID,username,email,password))
        {
            resp.sendRedirect("DataBaseError.html");
        }else {
            resp.sendRedirect("javaflix.jsp");
        }
    }
}
