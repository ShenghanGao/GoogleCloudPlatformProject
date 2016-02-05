package cs263w16;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.util.logging.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.memcache.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class NewSeekerInfoWorker extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        //String userId = user.getUserId();

        if (user == null) {
            System.out.println("The user has not logged in!!!!!!!!");
            response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
            return;
        }

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        String profileName = request.getParameter("profileName");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String address = request.getParameter("address");
        
        Date d = new Date();
        Entity entity = new Entity("SeekerInfo", user.getUserId() + ":" + profileName);
        entity.setProperty("firstName", firstName);
        entity.setProperty("lastName", lastName);
        entity.setProperty("address", address);
        datastore.put(entity);

    }
}
