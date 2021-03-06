package cs263w16;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.util.logging.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.memcache.*;

@SuppressWarnings("serial")
public class DatastoreServlet extends HttpServlet {

  @Override
  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
      resp.setContentType("text/html");
      resp.getWriter().println("<html><body>");

      TaskData memcacheVal;

  	  DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
  	  MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
  	  syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));

  	  Enumeration<String> en = req.getParameterNames();

  	  while (en.hasMoreElements()) {
  	  	String str = en.nextElement();
  	  	if (str.compareTo("keyname") != 0 && str.compareTo("value") != 0) {
  	  		resp.getWriter().println("<h1>These arguments are not acceptable!<h1>");
  	  		resp.getWriter().println("</body></html>");
  	  		return;
  	  	}
  	  }

  	  String keyname = req.getParameter("keyname");
  	  String value = req.getParameter("value");

  	  if (keyname == null && value == null) {
  	  	Query q = new Query("TaskData");
  	  	PreparedQuery pq = datastore.prepare(q);

  	  	resp.getWriter().println("Datastore entries<br>");
  	  	for (Entity result : pq.asIterable()) {
  	  		String resKeyname = result.getKey().getName();
  	  		String resValue = (String) result.getProperty("value");
  	  		Date resDate = (Date) result.getProperty("date");

  	  		resp.getWriter().println("keyname: " + resKeyname + ", value: " + resValue + ", date: " + resDate + "<br>");
  	  	}

  	  	resp.getWriter().println("Memcache entries<br>");
  	  	for (Entity result : pq.asIterable()) {
  	  		String resKeyname = result.getKey().getName();
  	  		memcacheVal = (TaskData) syncCache.get(resKeyname);

  	  		if (memcacheVal != null) {
  	  			String resValue = memcacheVal.getValue();
  	  			Date resDate = memcacheVal.getDate();
  	  			resp.getWriter().println("keyname: " + resKeyname + ", value: " + resValue + ", date: " + resDate + "<br>");
  	  		}
  	  	}

  	  }

  	  else if (keyname != null && value == null) {
  	  	Key k = KeyFactory.createKey("TaskData", keyname);

  	  	Entity taskData = null;

  	  	memcacheVal = (TaskData) syncCache.get(keyname);
  	  	if (memcacheVal == null) {
  	  		try {
  	  			taskData = datastore.get(k);

  	  			resp.getWriter().println("Datastore" + "<br>");

  	  			String resKeyname = taskData.getKey().getName();
  	  			String resValue = (String) taskData.getProperty("value");
  	  			Date resDate = (Date) taskData.getProperty("date");
  	  			resp.getWriter().println("keyname: " + resKeyname + ", value: " + resValue + ", date: " + resDate + "<br>");

  	  			TaskData taskDataI = new TaskData(resKeyname, resValue, resDate);
  	  			syncCache.put(resKeyname, taskDataI);
  	  			resp.getWriter().println("Stored KEY: " + resKeyname + " and value: " + resValue + ", date: " + resDate + " in Memcache" + "<br>");
  	  		} catch (EntityNotFoundException e) {
  	  			resp.getWriter().println("Neither" + "<br>");
  	  		}
  	  	}
  	  	else {
  	  		try {
  	  			taskData = datastore.get(k);
  	  			resp.getWriter().println("Both<br>");

  	  			String resKeyname = taskData.getKey().getName();
  	  			String resValue = (String) taskData.getProperty("value");
  	  			Date resDate = (Date) taskData.getProperty("date");
  	  			resp.getWriter().println("keyname: " + resKeyname + ", value: " + resValue + ", date: " + resDate + "<br>");

  	  		} catch (EntityNotFoundException e) {
  	  			resp.getWriter().println("Memcache" + "<br>");
  	  		}
  	  	}
  	  }

  	  else if (keyname != null && value != null) {
  	  	Entity taskData = new Entity("TaskData", keyname);
  	  	Date d = new Date();
  	  	taskData.setProperty("value", value);
  	  	taskData.setProperty("date", d);

  	  	datastore.put(taskData);
  	  	resp.getWriter().println("Stored KEY: " + keyname + " and value: " + value + ", date: " + d + " in Datastore" + "<br>");

  	  	TaskData taskDataI = new TaskData(keyname, value, d);
  	  	syncCache.put(keyname, taskDataI);
  	  	resp.getWriter().println("Stored KEY: " + keyname + " and value: " + value + ", date: " + d + " in Memcache" + "<br>");
  	  }

      resp.getWriter().println("</body></html>");
  }
}
