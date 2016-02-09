package cs263w16;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.net.URI;
import java.net.URISyntaxException;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

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

@Path("/infoenqueue")
public class InfoEnqueue {
  // Allows to insert contextual objects into the class,
  // e.g. ServletContext, Request, Response, UriInfo
  // @Context
  // UriInfo uriInfo;
  // @Context
  // Request request;
  // @Context
  // Request response;

  @POST
  @Path("/newseekerinfo")
  //@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
  @Consumes("application/x-www-form-urlencoded")
  public Response newSeekerInfo(@FormParam("profileName") String profileName,
      @FormParam("firstName") String firstName,
      @FormParam("lastName") String lastName,
      @FormParam("address") String address,
      @Context HttpServletRequest request,
      @Context HttpServletResponse response
    ) throws Exception {

        System.out.println("I am in the newseekerindo function!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String userId = user.getUserId();

        if (user != null) {
            System.out.println("The user is not null!!! User Id is " + userId);
        }
        else
            System.out.println("The user is NULL!!!NULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULL");
/*
        myProfileName = request.getParameter("profileName");
        myFirstName = request.getParameter("firstName");
        myLastName = request.getParameter("lastName");
        myAddress = request.getParameter("address");
*/
        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(TaskOptions.Builder.withUrl("/rest/infoworker/newseekerinfoworker").param("userId", userId).param("profileName", profileName).param("firstName", firstName).param("lastName", lastName).param("address", address));

        //response.sendRedirect("/home.jsp");
        return Response.temporaryRedirect(new URI("/")).build();
    }


  @POST
  @Path("/newposinfo")
  //@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
  @Consumes("application/x-www-form-urlencoded")
  public void newPosInfo(@FormParam("positionId") String positionId,
      @FormParam("title") String title,
      @FormParam("location") String location,
      @FormParam("description") String description,
      @Context HttpServletRequest request,
      @Context HttpServletResponse response
    ) throws Exception {
    UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String userId = user.getUserId();

        if (user != null) {
            System.out.println("The user is not null!!! User Id is " + userId);
        }
        else
            System.out.println("The user is NULL!!!NULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULL");
/*
        myPositionId = request.getParameter("positionId");
        myTitle = request.getParameter("title");
        myLocation = request.getParameter("location");
        myDescription = request.getParameter("description");
*/
        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(TaskOptions.Builder.withUrl("/rest/infoworker/newposinfoworker").param("userId", userId).param("positionId", positionId).param("title", title).param("location", location).param("description", description));

        response.sendRedirect("/home.jsp");
  }


}
