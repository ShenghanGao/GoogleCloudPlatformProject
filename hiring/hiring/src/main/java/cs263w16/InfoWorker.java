package cs263w16;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.util.logging.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.memcache.*;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PUT;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Request;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;
import javax.xml.bind.JAXBElement;

@Path("/infoworker")
public class InfoWorker {
  // Allows to insert contextual objects into the class,
  // e.g. ServletContext, Request, Response, UriInfo
  @Context
  UriInfo uriInfo;
  @Context
  Request request;

  @POST
  @Path("/newseekerinfoworker")
  public void newSeekerInfoWorker(
      @Context HttpServletRequest request
    ) throws IOException {
int[] a = {1, 5, 3, 2};
Arrays.sort(a);
System.out.println("Sorting is complete!");
for (int i : a)
  System.out.print(i + " ");


        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        String userId = request.getParameter("userId");
        String profileName = request.getParameter("profileName");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String address = request.getParameter("address");

        Key userKey = KeyFactory.createKey("User", userId);
        Key seekerInfoKey = KeyFactory.createKey(userKey, "SeekerInfo", profileName);


        Entity entity = new Entity(seekerInfoKey);
        entity.setProperty("profileName", profileName);
        entity.setProperty("userId", userId);
        entity.setProperty("firstName", firstName);
        entity.setProperty("lastName", lastName);
        entity.setProperty("address", address);
        datastore.put(entity);

    }


  @POST
  @Path("/newposinfoworker")
  public void newPosInfoWorker(
      @Context HttpServletRequest request
    ) throws IOException {
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        String positionId = request.getParameter("positionId");
        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        
        Date d = new Date();
        Entity entity = new Entity("PosInfo", positionId);
        entity.setProperty("title", title);
        entity.setProperty("location", location);
        entity.setProperty("description", description);
        datastore.put(entity);

  }

  @POST
  @Path("/newexpinfoworker")
  public void newExpInfoWorker(
      @Context HttpServletRequest request
    ) throws IOException {
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        String userId = request.getParameter("userId");
        String expName = request.getParameter("expName");
        String profileName = request.getParameter("profileName");
        String title = request.getParameter("title");
        String companyName = request.getParameter("companyName");
        String location = request.getParameter("location");
        String timePeriod = request.getParameter("timePeriod");
        String description = request.getParameter("description");

        System.out.println("I am in the newExpInfoWorker!!! expName = " + expName);

        Key userKey = KeyFactory.createKey("User", userId);
        Key seekerInfoKey = KeyFactory.createKey(userKey, "SeekerInfo", profileName);
        Key expInfoKey = KeyFactory.createKey(seekerInfoKey, "SeekerExpInfo", expName);

        Entity entity = new Entity(expInfoKey);
        entity.setProperty("userId", userId);
        entity.setProperty("expName", expName);
        entity.setProperty("profileName", profileName);
        entity.setProperty("title", title);
        entity.setProperty("companyName", companyName);
        entity.setProperty("location", location);
        entity.setProperty("timePeriod", timePeriod);
        entity.setProperty("description", description);
        
        datastore.put(entity);

  }


}
