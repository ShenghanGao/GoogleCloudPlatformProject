package cs263w16;

import java.util.*;
import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

public class BlobstoreNewPhoto extends HttpServlet {
  private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

  @Override
  public void doPost(HttpServletRequest req, HttpServletResponse res) 
  throws IOException {
        System.out.println("Ready to doGet enqueue the profile photo!!! doGet  doGet  doGet  doGet  doGet  doGet  doGet  doGet  doGet  doGet  doGet ");

        String profileName = req.getParameter("profileName");

        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String userId = user.getUserId();

        if (user != null) {
            System.out.println("The user is not null!!! User Id is " + userId);
        }
        else
            System.out.println("The user is NULL!!!NULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULLNULL");


    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
    Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
    List<BlobKey> blobKeys = blobs.get("myFile");

    String des;

    System.out.println("I am about to upload to Blobstore!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

    if (blobKeys == null || blobKeys.isEmpty()) {
      des = "/";
    }
    else {
      des = "/profileaction.jsp?profileName=" + URLEncoder.encode(profileName, "UTF-8");
      String blobKey = blobKeys.get(0).getKeyString();

      Queue queue = QueueFactory.getDefaultQueue();
      queue.add(
        TaskOptions.Builder.withUrl("/rest/blobstoreworker/profilephotoworker").param("userId", userId).param("profileName", profileName).param("blobKey", blobKey)
        );
    }

    res.sendRedirect(des);
    }
}
