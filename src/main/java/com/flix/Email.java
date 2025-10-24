package com.flix;

import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
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
import java.util.Properties;

@WebServlet("/sendOtp")
public class Email extends HttpServlet {


    public static boolean checkEmail(String email)
    {

        boolean emailFound = false;
        final String url = "jdbc:mysql://localhost:3307/javaflix";
        final String password = "Harsh$1000Pande";
        final String user = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url,user,password);
            String query = "SELECT email FROM users WHERE email = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1,email);
            ResultSet resultSet = preparedStatement.executeQuery();
            if(resultSet.next())
            {
                emailFound = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emailFound;
    }

    public static boolean sendVerificationOTP(String email,String otp)
    {
        boolean send = false;
        String server_Email = "h87539994@gmail.com";
        String server_Email_Password = "afte wjrm thzh oysd";

        String subject = "Your JavaFlix OTP Code";


        String body = "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "  <meta charset='UTF-8'>" +
                "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "  <title>JavaFlix OTP Verification</title>" +
                "  <link href='https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap' rel='stylesheet'>" +
                "  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css'>" +
                "  <style>" +
                "    body {" +
                "      font-family: 'Poppins', sans-serif;" +
                "      background-color: #141414;" +
                "      color: #f4f4f4;" +
                "      padding: 20px;" +
                "      margin: 0;" +
                "      line-height: 1.6;" +
                "    }" +
                "    .container {" +
                "      max-width: 600px;" +
                "      margin: 20px auto;" +
                "      border: 1px solid #333;" +
                "      border-radius: 10px;" +
                "      padding: 40px;" +
                "      background-color: rgba(20, 20, 20, 0.9);" +
                "      box-shadow: 0 10px 30px rgba(0,0,0,0.5);" +
                "    }" +
                "    .logo {" +
                "      text-align: center;" +
                "      margin-bottom: 20px;" +
                "      font-size: 28px;" +
                "      font-weight: 700;" +
                "      color: white;" +
                "      position: relative;" +
                "      display: inline-block;" +
                "      left: 50%;" +
                "      transform: translateX(-50%);" +
                "    }" +
                "    .logo span {" +
                "      color: #e50914;" +
                "    }" +
                "    .logo::after {" +
                "      content: '';" +
                "      position: absolute;" +
                "      bottom: -8px;" +
                "      left: 0;" +
                "      width: 100%;" +
                "      height: 3px;" +
                "      background: linear-gradient(90deg, #e50914, #f40612);" +
                "      border-radius: 3px;" +
                "    }" +
                "    .header {" +
                "      text-align: center;" +
                "      color: white;" +
                "      font-size: 24px;" +
                "      font-weight: 600;" +
                "      margin-bottom: 25px;" +
                "    }" +
                "    .divider {" +
                "      border: none;" +
                "      height: 2px;" +
                "      background: linear-gradient(90deg, rgba(229, 9, 20, 0), #e50914, rgba(229, 9, 20, 0));" +
                "      margin: 25px 0;" +
                "    }" +
                "    .otp-container {" +
                "      text-align: center;" +
                "      margin: 30px 0;" +
                "    }" +
                "    .otp-box {" +
                "      display: inline-block;" +
                "      background: linear-gradient(135deg, #e50914, #f40612);" +
                "      color: #ffffff;" +
                "      padding: 18px 30px;" +
                "      font-size: 28px;" +
                "      border-radius: 5px;" +
                "      font-weight: 700;" +
                "      letter-spacing: 3px;" +
                "      box-shadow: 0 5px 15px rgba(229, 9, 20, 0.3);" +
                "      margin: 15px 0;" +
                "    }" +
                "    .instructions {" +
                "      background-color: rgba(229, 9, 20, 0.1);" +
                "      border-left: 4px solid #e50914;" +
                "      padding: 15px;" +
                "      border-radius: 0 5px 5px 0;" +
                "      margin: 25px 0;" +
                "    }" +
                "    .footer {" +
                "      margin-top: 40px;" +
                "      text-align: center;" +
                "      font-size: 13px;" +
                "      color: #999;" +
                "      border-top: 1px solid #333;" +
                "      padding-top: 20px;" +
                "    }" +
                "    .button {" +
                "      display: inline-block;" +
                "      background: linear-gradient(135deg, #e50914, #f40612);" +
                "      color: white;" +
                "      padding: 12px 25px;" +
                "      text-decoration: none;" +
                "      border-radius: 5px;" +
                "      font-weight: 600;" +
                "      margin-top: 20px;" +
                "      box-shadow: 0 4px 15px rgba(229, 9, 20, 0.3);" +
                "    }" +
                "    .social-links {" +
                "      text-align: center;" +
                "      margin-top: 30px;" +
                "    }" +
                "    .social-icon {" +
                "      display: inline-block;" +
                "      margin: 0 10px;" +
                "      color: #999;" +
                "      font-size: 18px;" +
                "      transition: color 0.3s;" +
                "    }" +
                "    .social-icon:hover {" +
                "      color: #e50914;" +
                "    }" +
                "    p {" +
                "      color: #999;" +
                "    }" +
                "    strong {" +
                "      color: white;" +
                "    }" +
                "  </style>" +
                "</head>" +
                "<body>" +
                "  <div class='container'>" +
                "    <div class='logo'>Java<span>Flix</span></div>" +
                "    <div class='header'>Your Verification Code</div>" +
                "    <hr class='divider' />" +
                "    <p style='text-align: center;'>Thank you for joining JavaFlix. Please use the following One-Time Password (OTP) to verify your account:</p>" +
                "    <div class='otp-container'>" +
                "      <div class='otp-box'>" + otp + "</div>" +
                "    </div>" +
                "    <div class='instructions'>" +
                "      <p><strong>Important:</strong> This OTP is valid for 10 minutes. Do not share this code with anyone.</p>" +
                "    </div>" +
                "    <p style='text-align: center;'>If you didn't request this code, you can safely ignore this email.</p>" +
                "    <div class='social-links'>" +
                "      <a href='#' class='social-icon'><i class='fab fa-facebook-f'></i></a>" +
                "      <a href='#' class='social-icon'><i class='fab fa-twitter'></i></a>" +
                "      <a href='#' class='social-icon'><i class='fab fa-instagram'></i></a>" +
                "      <a href='#' class='social-icon'><i class='fab fa-youtube'></i></a>" +
                "    </div>" +
                "    <div class='footer'>" +
                "      <p>&copy; 2025 JavaFlix. All rights reserved.</p>" +
                "      <p>1234 Movie Street, Hollywood, CA</p>" +
                "      <p><a href='#' style='color: #e50914;'>Unsubscribe</a> | <a href='#' style='color: #e50914;'>Privacy Policy</a></p>" +
                "    </div>" +
                "  </div>" +
                "</body>" +
                "</html>";

        Properties properties = new Properties();
        properties.put("mail.smtp.auth","true");
        properties.put("mail.smtp.starttls.enable","true");
        properties.put("mail.smtp.host","smtp.gmail.com");
        properties.put("mail.smtp.port","587");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(server_Email,server_Email_Password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(server_Email));
            message.setRecipients(MimeMessage.RecipientType.TO,InternetAddress.parse(email));
            message.setSubject(subject);
            message.setContent(body,"text/html");
            Transport.send(message);
            send = true;
        } catch (Exception e) {
            send = false;
            throw new RuntimeException(e);
        }
        return send;
    }

    public static boolean checkUserName(String userName)
    {

        boolean userNameFound = false;
        final String url = "jdbc:mysql://localhost:3307/javaflix";
        final String password = "Harsh$1000Pande";
        final String user = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url,user,password);
            String query = "SELECT username FROM users WHERE username = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1,userName);
            ResultSet resultSet = preparedStatement.executeQuery();
            if(resultSet.next())
            {
                userNameFound = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userNameFound;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String otp = Otp.GenrateOtp();
        String email = req.getParameter("email");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        boolean found_UserName = checkUserName(username);
        boolean found = checkEmail(email);

        if(found_UserName)
        {

            req.setAttribute("error", "UserName is Already Taken By Other User.");
            RequestDispatcher rd = req.getRequestDispatcher("signup.jsp");
            rd.forward(req, resp);

        }else {
            if (found) {

                req.setAttribute("error", "Email is Already Register in Our System.");
                RequestDispatcher rd = req.getRequestDispatcher("signup.jsp");
                rd.forward(req, resp);

            } else {
                boolean send = sendVerificationOTP(email, otp);
                if (send) {

                    req.setAttribute("success", "OTP sent successfully.");
                    HttpSession otpsession = req.getSession(false);
                    otpsession.setAttribute("otp",otp);
                    HttpSession httpSession = req.getSession();
                    httpSession.setAttribute("email",email);
                    httpSession.setAttribute("username",username);
                    httpSession.setAttribute("password",password);
                    httpSession.setMaxInactiveInterval(3 * 24 * 60 * 60);
                    otpsession.setMaxInactiveInterval(10 * 60);
                    req.setAttribute("email",email);
                    RequestDispatcher rd = req.getRequestDispatcher("otp.jsp");
                    rd.forward(req, resp);

                } else {

                    req.setAttribute("error", "Server Error. Try Later.");
                    RequestDispatcher rd = req.getRequestDispatcher("signup.jsp");
                    rd.forward(req, resp);
                }
            }
        }
    }
}
