package cs263w16;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;

public class NewPosInfoEnqueue extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String description = request.getParameter("description");

        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(TaskOptions.Builder.withUrl("/newposinfoworker").param("title", title).param("location", location).param("description", description));

        response.sendRedirect("/");
    }
}
