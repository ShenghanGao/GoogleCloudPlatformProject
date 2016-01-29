package cs263w16;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.util.logging.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.memcache.*;

public class NewPosInfoWorker extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        
        Date d = new Date();
        Entity entity = new Entity("PosInfo", title);
        entity.setProperty("title", title);
        entity.setProperty("location", location);
        entity.setProperty("description", description);
        datastore.put(entity);

    }
}
