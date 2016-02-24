<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.*" %>
<%@ page import="com.google.appengine.api.memcache.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.logging.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <!--link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/-->
</head>

<body>

<h1>Hiring Platform</h1>

<%
    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();
    String userId = null;
    if (user != null) {
        pageContext.setAttribute("user", user);
        userId = user.getUserId();
%>

<p>Hello,${fn:escapeXml(user.nickname)}!(You can
            <a href="<%=userService.createLogoutURL("/")%>">Sign out</a>.)</p>
<%
}
else {
%>

<p>Hello!<a href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign in</a> to include your name with greetings.</p>
<%
}

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));

    String profileName = request.getParameter("profileName");
    String expName = request.getParameter("expName");

    Key userKey = KeyFactory.createKey("User", userId);
    Key seekerInfoKey = KeyFactory.createKey(userKey, "SeekerInfo", profileName);

    Entity expInfo = datastore.get(seekerInfoKey);

    String myExpName = (String) expInfo.getProperty("expName");
    String title = (String) expInfo.getProperty("title");
    String companyName = (String) expInfo.getProperty("companyName");
    String location = (String) expInfo.getProperty("location");
    String timePeriod = (String) expInfo.getProperty("timePeriod");
    String description = (String) expInfo.getProperty("description");

%>

<form action="/rest/infoenqueue/newseekerinfo" method="post">
    <input type="hidden" name="profileName" value="<%=profileName%>"/>
    <p>Experience Name: <%=myExpName%> is being edited!</p>
    <div><input type="hidden" name="expName" value="<%=myExpName%>"/></div>
    <p>Title</p>
    <div><input type="text" name="title" value="<%=title%>"/></div>
    <p>Company Name</p>
    <div><input type="text" name="companyName" value="<%=companyName%>"/></div>
    <p>Location</p>
    <div><input type="text" name="location" value="<%=location%>"/></div>
    <p>Time Period</p>
    <div><input type="text" name="timePeriod" value="<%=timePeriod%>"/></div>
    <p>Description</p>
    <div><input type="text" name="description" value="<%=description%>"/></div>
    <div><input type="submit" value="Submit"/></div>
 </form>


</body>
</html>
