package cs263w16;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.util.logging.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.memcache.*;

public class NewSeekerInfoWorker extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String address = request.getParameter("address");
        
        Date d = new Date();
        Entity entity = new Entity("SeekerInfo", firstName+lastName);
        entity.setProperty("firstName", firstName);
        entity.setProperty("lastName", lastName);
        entity.setProperty("address", address);
        datastore.put(entity);

    }
}
