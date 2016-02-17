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

@Path("/search")
public class Search {
  // Allows to insert contextual objects into the class,
  // e.g. ServletContext, Request, Response, UriInfo
  @Context
  UriInfo uriInfo;
  @Context
  Request request;
  @Context
  Response response;

  @POST
  @Path("/seekerinfo")
  public Response newSeekerInfoWorker(
    @FormParam("firstNameSearch") String firstNameSearch,
    @FormParam("lastNameSearch") String lastNameSearch,
    @Context HttpServletRequest request,
    @Context HttpServletResponse response
    ) throws Exception {
    //System.out.println("lastNameSearch = " + lastNameSearch);
    //String tmp = request.getParameter("lastNameSearch");

         return Response.temporaryRedirect(new URI("/seekerinfo.jsp?firstNameSearch=" + firstNameSearch + "&lastNameSearch="+lastNameSearch)).build();
        //return Response.temporaryRedirect(new URI("/seekerinfo.jsp?lastNameSearch="+tmp)).build();

    }


}
