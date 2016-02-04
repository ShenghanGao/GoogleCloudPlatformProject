package cs263w16;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;

public class NewSeekerInfoEnqueue extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String profileName = request.getParameter("profileName");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String address = request.getParameter("address");

        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(TaskOptions.Builder.withUrl("/newseekerinfoworker").param("profileName", profileName).param("firstName", firstName).param("lastName", lastName).param("address", address));

        response.sendRedirect("/");
    }
}
