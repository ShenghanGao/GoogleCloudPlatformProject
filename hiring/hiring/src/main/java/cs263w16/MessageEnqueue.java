package cs263w16;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.util.logging.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.memcache.*;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;

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

@Path("/messageenqueue")
public class MessageEnqueue {
  // Allows to insert contextual objects into the class,
  // e.g. ServletContext, Request, Response, UriInfo
  @Context
  UriInfo uriInfo;
  @Context
  Request request;
  @Context
  Response response;

  @POST
  @Path("/sendmessage")
  public Response sendMessageEnqueue(
    @FormParam("userIdTo") String userIdTo,
    @FormParam("userEmailTo") String userEmailTo,
    @FormParam("message") String message,
    @Context HttpServletRequest request,
    @Context HttpServletResponse response
    ) throws Exception {

    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    String userIdFrom = user.getUserId();
    String userEmailFrom = user.getEmail();

    if (user != null) {
      System.out.println("The user is not null!!! User Id is " + userIdFrom);
    }
    else
      System.out.println("The user is NULL!!!NULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULL");
    
    Queue queue = QueueFactory.getDefaultQueue();
    queue.add(TaskOptions.Builder.withUrl("/rest/messageworker/sendmessageworker").param("userIdFrom", userIdFrom).param("userEmailFrom", userEmailFrom)
      .param("userIdTo", userIdTo).param("userEmailTo", userEmailTo)
      .param("message", message));

    String des = "/myconversations.jsp";

    return Response.temporaryRedirect(new URI(des)).build();

    }

}
