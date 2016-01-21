package cs263w16;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.util.*;
import java.util.logging.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.memcache.*;
import javax.xml.bind.JAXBElement;

public class TaskDataResource {
  @Context
  UriInfo uriInfo;
  @Context
  Request request;
  String keyname;

  public TaskDataResource(UriInfo uriInfo, Request request, String kname) {
    this.uriInfo = uriInfo;
    this.request = request;
    this.keyname = kname;
  }
  // for the browser
  @GET
  @Produces(MediaType.TEXT_XML)
  public TaskData getTaskDataHTML() {
    //add your code here (get Entity from datastore using this.keyname)
    // throw new RuntimeException("Get: TaskData with " + keyname +  " not found");
    //if not found

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
    Key k = KeyFactory.createKey("TaskData", keyname);

    TaskData memcacheVal = (TaskData) syncCache.get(keyname);
    if (memcacheVal == null) {
      try {
        Entity taskData = datastore.get(k);
        String resKeyname = taskData.getKey().getName();
        String resValue = (String) taskData.getProperty("value");
        Date resDate = (Date) taskData.getProperty("date");
        TaskData taskDataI = new TaskData(resKeyname, resValue, resDate);

        syncCache.put(resKeyname, taskDataI);

        return taskDataI;
      } catch (EntityNotFoundException e) {
        throw new RuntimeException("Get: TaskData with " + keyname +  " not found");
      }
    }
    else
      return memcacheVal;
  }
  // for the application
  @GET
  @Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
  public TaskData getTaskData() {
    //same code as above method

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
    Key k = KeyFactory.createKey("TaskData", keyname);

    TaskData memcacheVal = (TaskData) syncCache.get(keyname);
    if (memcacheVal == null) {
      try {
        Entity taskData = datastore.get(k);
        String resKeyname = taskData.getKey().getName();
        String resValue = (String) taskData.getProperty("value");
        Date resDate = (Date) taskData.getProperty("date");
        TaskData taskDataI = new TaskData(resKeyname, resValue, resDate);

        syncCache.put(resKeyname, taskDataI);

        return taskDataI;
      } catch (EntityNotFoundException e) {
        throw new RuntimeException("Get: TaskData with " + keyname +  " not found");
      }
    }
    else
      return memcacheVal;
  }

  @PUT
  @Consumes(MediaType.APPLICATION_XML)
  public Response putTaskData(String val) {
    Response res = null;
    //add your code here
    //first check if the Entity exists in the datastore
    //if it is not, create it and 
    //signal that we created the entity in the datastore

    //else signal that we updated the entity

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
    Key k = KeyFactory.createKey("TaskData", keyname);

    Entity taskData = null;
    try {
      taskData = datastore.get(k);
      taskData.setProperty("value", val);
      datastore.put(taskData);

      Date resDate = (Date) taskData.getProperty("date");
      TaskData taskDataI = new TaskData(keyname, val, resDate);
      syncCache.put(keyname, taskDataI);

      res = Response.noContent().build();
    } catch (EntityNotFoundException e) {
      taskData = new Entity("TaskData", keyname);
      Date d = new Date();

      taskData.setProperty("keyname", keyname);
      taskData.setProperty("value", val);
      taskData.setProperty("date", d);
      datastore.put(taskData);

      TaskData taskDataI = new TaskData(keyname, val, d);
      syncCache.put(keyname, taskDataI);
      
      res = Response.created(uriInfo.getAbsolutePath()).build(); 
      }
      return res;
  }

  @DELETE
  public void deleteIt() {

    //delete an entity from the datastore
    //just print a message upon exception (don't throw)
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
    Key k = KeyFactory.createKey("TaskData", keyname);

    syncCache.delete(keyname);

    try {
      datastore.delete(k);
    } catch (DatastoreFailureException e) {
      System.out.println("There is a DatastoreFailureException");
    }
  }
}
