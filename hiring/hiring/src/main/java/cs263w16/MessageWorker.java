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

@Path("/messageworker")
public class MessageWorker {
  // Allows to insert contextual objects into the class,
  // e.g. ServletContext, Request, Response, UriInfo
  @Context
  UriInfo uriInfo;
  @Context
  Request request;
  @Context
  Response response;

  @POST
  @Path("/sendmessageworker")
  public void sendMessageEnqueue(
    @Context HttpServletRequest request
    ) throws Exception {
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        String userIdFrom = request.getParameter("userIdFrom");
        String userEmailFrom = request.getParameter("userEmailFrom");
        String userIdTo = request.getParameter("userIdTo");
        String userEmailTo = request.getParameter("userEmailTo");
        String message = request.getParameter("message");

        System.out.println("I am in sendMessageEnqueue!!!");
        System.out.println("userIdFrom = " + userIdFrom);
        System.out.println("userEmailFrom = " + userEmailFrom);
        System.out.println("userIdTo = " + userIdTo);
        System.out.println("userEmailTo = " + userEmailTo);
        System.out.println("message = " + message);

        Key userFromKey = KeyFactory.createKey("User", userIdFrom);
        Key userToKey = KeyFactory.createKey("User", userIdTo);

        String conversationKeyname = userIdFrom.compareTo(userIdTo) < 0 ? userIdFrom + ";" + userIdTo : userIdTo + ";" + userIdFrom;
        //String conversationKeyname = userIdFrom + ";" + userIdTo;
        Key conversationForUserFromKey = KeyFactory.createKey(userFromKey, "Conversation", conversationKeyname);
        Key conversationForUserToKey = KeyFactory.createKey(userToKey, "Conversation", conversationKeyname);

        Entity conversationForUserFrom;
        try {
          conversationForUserFrom = datastore.get(conversationForUserFromKey);
        } catch (EntityNotFoundException e) {
          conversationForUserFrom = new Entity(conversationForUserFromKey);
          conversationForUserFrom.setProperty("userIdFrom", userIdFrom);
          conversationForUserFrom.setProperty("userEmailFrom", userEmailFrom);
          conversationForUserFrom.setProperty("userIdTo", userIdTo);
          conversationForUserFrom.setProperty("userEmailTo", userEmailTo);
          datastore.put(conversationForUserFrom);
        }

        Entity conversationForUserTo;
        try {
          conversationForUserTo = datastore.get(conversationForUserToKey);
        } catch (EntityNotFoundException e) {
          conversationForUserTo = new Entity(conversationForUserToKey);
          conversationForUserTo.setProperty("userIdFrom", userIdFrom);
          conversationForUserTo.setProperty("userEmailFrom", userEmailFrom); 
          conversationForUserTo.setProperty("userIdTo", userIdTo);
          conversationForUserTo.setProperty("userEmailTo", userEmailTo); 
          datastore.put(conversationForUserTo);
        }

        Date date = new Date();
        Key messageForUserFromKey = KeyFactory.createKey(conversationForUserFromKey, "Message", date.toString());
        Key messageForUserToKey = KeyFactory.createKey(conversationForUserToKey, "Message", date.toString());

        Entity messageForUserFrom = new Entity(messageForUserFromKey);
        // messageForUserFrom.setProperty("userIdFrom", userIdFrom);
        // messageForUserFrom.setProperty("userIdTo", userIdTo);
        messageForUserFrom.setProperty("message", message);
        messageForUserFrom.setProperty("date", date);

        Entity messageForUserTo = new Entity(messageForUserToKey);
        // messageForUserTo.setProperty("userIdFrom", userIdFrom);
        // messageForUserTo.setProperty("userIdTo", userIdTo);
        messageForUserTo.setProperty("message", message);
        messageForUserTo.setProperty("date", date);

        datastore.put(messageForUserFrom);
        datastore.put(messageForUserTo);

/*
        Key userKey = KeyFactory.createKey("User", userId);
        Key seekerInfoKey = KeyFactory.createKey(userKey, "SeekerInfo", profileName);


        Entity entity = new Entity(seekerInfoKey);
        entity.setProperty("profileName", profileName);
        entity.setProperty("userId", userId);
        entity.setProperty("firstName", firstName);
        entity.setProperty("lastName", lastName);
        entity.setProperty("address", address);
*/
    }
}
