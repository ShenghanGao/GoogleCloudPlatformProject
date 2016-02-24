package cs263w16;

import java.util.*;
import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;

import com.google.appengine.api.datastore.*;
import com.google.appengine.api.memcache.*; 

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PUT;
import javax.ws.rs.Produces;
import javax.ws.rs.FormParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Request;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;
import javax.xml.bind.JAXBElement;

@Path("/blobstoreworker")
public class BlobstoreWorker {
  @POST
  @Path("/profilephotoworker")
  public void newProfilePhoto(
      @Context HttpServletRequest request
    ) throws Exception {

    System.out.println("I am here!!!!!!!!!!!!!!!!!!!!!!!");

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        String userId = request.getParameter("userId");
        String profileName = request.getParameter("profileName");
        String blobKey = request.getParameter("blobKey");

        Key userKey = KeyFactory.createKey("User", userId);
        Key seekerInfoKey = KeyFactory.createKey(userKey, "SeekerInfo", profileName);


        Entity entity = datastore.get(seekerInfoKey);
        entity.setProperty("profilePhoto", blobKey);
        datastore.put(entity);

        System.out.println("userId" + userId + "\nprofileName" + profileName + "\nblobKey" + blobKey);

    }

}
