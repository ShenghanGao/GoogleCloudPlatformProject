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

    Key userKey = KeyFactory.createKey("User", userId);
    Key seekerInfoKey = KeyFactory.createKey(userKey, "SeekerInfo", profileName);

    Entity expInfo = datastore.get(seekerInfoKey);

    String myProfileName = (String) expInfo.getProperty("profileName");
    String firstName = (String) expInfo.getProperty("firstName");
    String lastName = (String) expInfo.getProperty("lastName");
    String address = (String) expInfo.getProperty("address");

%>

<form action="/rest/infoenqueue/newseekerinfo" method="post">
    <p>Profile Name: <%=myProfileName%> is being edited!</p>
    <input type="hidden" name="profileName" value="<%=myProfileName%>"/>
    <p>First Name</p>
    <div><input type="text" name="firstName" value="<%=firstName%>"/></div>
    <p>Last Name</p>
    <div><input type="text" name="lastName" value="<%=lastName%>"/></div>
    <p>Address</p>
    <div><input type="text" name="address" value="<%=address%>"/></div>
    <div><input type="submit" value="Submit"/></div>
</form>

</body>
</html>
