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
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        String userId = request.getParameter("userId");
        String profileName = request.getParameter("profileName");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String address = request.getParameter("address");

        Key userKey = KeyFactory.createKey("User", userId);
        Key seekerInfoKey = KeyFactory.createKey(userKey, "SeekerInfo", profileName);


        Entity entity = new Entity(seekerInfoKey);
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


}
