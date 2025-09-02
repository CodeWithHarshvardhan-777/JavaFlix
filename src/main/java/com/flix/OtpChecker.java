package com.flix;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


@WebServlet("/VerifyOTP")
public class OtpChecker extends HttpServlet {
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

        if(enter_OTP.equals(server_OTP))
        {
            RequestDispatcher requestDispatcher = req.getRequestDispatcher("SignUp");
            requestDispatcher.forward(req,resp);

        }else {
            req.setAttribute("error", "Enter OTP is Incorrect. ");
            RequestDispatcher rd = req.getRequestDispatcher("otp.jsp");
            rd.forward(req, resp);
        }
    }
}
