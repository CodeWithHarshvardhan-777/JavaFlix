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

@WebServlet("/savemovie")
public class savemovies extends HttpServlet {


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


    public static String saveMovie(String userID,String title, String image,String year, String type, String runtime,String language, String imdb)
    {
        final String url = "jdbc:mysql://localhost:3307/javaflix";
        final String password = "Harsh$1000Pande";
        final String user = "root";
        String store = "error";

            try {
                Connection connection = null;
                PreparedStatement preparedStatement = null;
                ResultSet resultSet = null;

                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, password);
                String query_find = "SELECT userID = ? FROM movies WHERE title = ?";
                preparedStatement = connection.prepareStatement(query_find);
                preparedStatement.setString(1,userID);
                preparedStatement.setString(2,title);
                resultSet = preparedStatement.executeQuery();
                if(!resultSet.next())
                {
                    String query = "INSERT INTO movies (userID,title,image,year,type,runtime,language,imdb) VALUES (?,?,?,?,?,?,?,?)";
                    preparedStatement = connection.prepareStatement(query);
                    preparedStatement.setString(1,userID);
                    preparedStatement.setString(2, title);
                    preparedStatement.setString(3, image);
                    preparedStatement.setString(4, year);
                    preparedStatement.setString(5, type);
                    preparedStatement.setString(6, runtime);
                    preparedStatement.setString(7, language);
                    preparedStatement.setString(8,imdb);
                    int i = preparedStatement.executeUpdate();
                    if(i > 0)
                    {
                        store = "save";
                    }
                }else {
                    store = "already_save";
                }

            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        return store;
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        final String url = "jdbc:mysql://localhost:3307/javaflix";
        final String password = "Harsh$1000Pande";
        final String user = "root";

        HttpSession httpSession = req.getSession(false);
        String imdb = req.getParameter("imdb");
        String title = req.getParameter("title");
        String userID = (String) httpSession.getAttribute("userID");
        String username = (String) httpSession.getAttribute("username");
        String image = (String) httpSession.getAttribute("posterUrl");
        String year = req.getParameter("year");
        String runtime = req.getParameter("runtime");
        String language = req.getParameter("language");
        String type = req.getParameter("type");

        if(checkUserName(username))
        {
            String result = saveMovie(userID,title,image,year,type,runtime,language,imdb);

            switch (result){
                case "error":
                    req.setAttribute("error","Error During Save Movie");
                    break;

                case "already_save":
                    req.setAttribute("error","Movie is Already Save");
                    break;

                case "save":
                default:
                    req.setAttribute("success","Movie Save Successfully");
                    break;
            }

            RequestDispatcher requestDispatcher = req.getRequestDispatcher("result.jsp");
            requestDispatcher.forward(req,resp);
        }else {
            resp.sendRedirect("login.jsp");
        }
    }
}
