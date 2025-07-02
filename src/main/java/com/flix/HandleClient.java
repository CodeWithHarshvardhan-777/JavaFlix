package com.flix;


import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;


@WebServlet("/try")
public class HandleClient extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        String api_Key = "a5f6d22";
        String movie = request.getParameter("query");
        String encodemovie = URLEncoder.encode(movie, StandardCharsets.UTF_8.toString());
        String url = "https://www.omdbapi.com/?t=" + encodemovie + "&apikey=" + api_Key;
        try {
            URL url1 = new URL(url);
            HttpURLConnection httpURLConnection = (HttpURLConnection) url1.openConnection();
            httpURLConnection.setRequestMethod("GET");

            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream()));
            StringBuilder stringBuilder = new StringBuilder();

            String resp;
            while ((resp = bufferedReader.readLine()) != null) {
                stringBuilder.append(resp);
            }

            JsonObject jsonObject = JsonParser.parseString(stringBuilder.toString()).getAsJsonObject();
            Gson gson = new GsonBuilder().setPrettyPrinting().create();
            String readAble = gson.toJson(jsonObject);
            System.out.println(readAble);

            String title = jsonObject.get("Title").toString().replace("\"", "");
            String year = jsonObject.get("Year").toString().replace("\"", "");
            String released_Date = jsonObject.get("Released").toString().replace("\"", "");
            String runtime = jsonObject.get("Runtime").toString().replace("\"", "");
            String genre = jsonObject.get("Genre").toString().replace("\"", "");
            String Director = jsonObject.get("Director").toString().replace("\"", "");
            String Writer = jsonObject.get("Writer").toString().replace("\"", "");
            String Actors = jsonObject.get("Actors").toString().replace("\"", "");
            String plot = jsonObject.get("Plot").toString().replace("\"", "");
            String language = jsonObject.get("Language").toString().replace("\"", "");
            String country = jsonObject.get("Country").toString().replace("\"", "");
            String awards = jsonObject.get("Awards").toString().replace("\"", "");
            String poster = jsonObject.get("Poster").toString();
            String metascore = jsonObject.has("Metascore") ? jsonObject.get("Metascore").toString().replace("\"", "") : "N/A";
            String imdbrating = jsonObject.has("imdbRating") ? jsonObject.get("imdbRating").toString().replace("\"", "") : "N/A";
            String imdbvotes = jsonObject.has("imdbVotes") ? jsonObject.get("imdbVotes").toString().replace("\"", "") : "N/A";
            String collection = jsonObject.has("BoxOffice") ? jsonObject.get("BoxOffice").toString().replace("\"", "") : "N/A";

            request.setAttribute("title",title.replaceAll("^\"|\"$",""));
            request.setAttribute("year",year.replaceAll("^\"|\"$",""));
            request.setAttribute("released",released_Date);
            request.setAttribute("runtime",runtime);
            request.setAttribute("genre",genre);
            request.setAttribute("director",Director);
            request.setAttribute("writer",Writer);
            request.setAttribute("actor",Actors);
            request.setAttribute("plot",plot);
            request.setAttribute("language",language);
            request.setAttribute("country",country);
            request.setAttribute("award",awards);
            request.setAttribute("poster",poster);
            request.setAttribute("metascore",metascore);
            request.setAttribute("imdb_rate",imdbrating);
            request.setAttribute("imdb_vote",imdbvotes);
            request.setAttribute("collection",collection);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("result.jsp");
            requestDispatcher.forward(request,response);


        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error","Wrong Movie Name or Failed to Fetch Movie Details.");
            request.setAttribute("movie",movie);
            RequestDispatcher error = request.getRequestDispatcher("pagenotfound.jsp");
            error.forward(request,response);

        }

    }
}
