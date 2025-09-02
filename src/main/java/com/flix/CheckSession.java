package com.flix;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/CheckSession")
public class CheckSession extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session != null) {
            String username = (String) session.getAttribute("username");
            if (username != null && !username.isEmpty()) {
                resp.sendRedirect("viewSaveMovies.jsp");
                return;
            }
        }
        resp.sendRedirect("login.jsp");
    }
}
