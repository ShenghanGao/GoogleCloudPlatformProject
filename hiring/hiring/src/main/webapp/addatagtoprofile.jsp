<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.*" %>
<%@ page import="com.google.appengine.api.memcache.*" %>

<%@ page import="java.util.*" %>
<%@ page import="java.util.logging.*" %>

<%@ page import="java.net.URI" %>
<%@ page import="java.net.URISyntaxException" %>
<%@ page import="java.net.URLEncoder" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <!--link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/-->
</head>

<body>

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

    Key userKey = KeyFactory.createKey("User", userId);
    Key seekerInfoKey = KeyFactory.createKey(userKey, "SeekerInfo", profileName);

    Entity seekerInfo = datastore.get(seekerInfoKey);

    List<String> tags = (List<String>) seekerInfo.getProperty("tags");

%>
<b>Added tags for this profile:</b>
<ul>
<%
if (tags != null) {
    for (String tag : tags) {
%>
    <li><%=tag%></li>
<%
}
}
%>
</ul>

<br>

<form action="/rest/infoenqueue/addatagtoprofile" method="post">
    <input type="hidden" name="profileName" value="<%=profileName%>">
    <p>Add a tag to this profile:</p>
    <input type="text" name="tag">
    <input type="submit" value="Submit">
</form>

</body>
</html>
