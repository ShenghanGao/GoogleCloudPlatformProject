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
            <a href="<%=userService.createLogoutURL(request.getRequestURI())%>">Sign out</a>.)</p>
<%
}
else {
%>

<p>Hello!<a href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign in</a> to include your name with greetings.</p>
<%
}
%>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));

    Query q = new Query("SeekerInfo");
    PreparedQuery pq = datastore.prepare(q);
    %>
    <table>
<%
    for (Entity e : pq.asIterable()) {
    String keyname = e.getKey().getName();
    String[] tmp = keyname.split(":");
    //String userIdInKey = tmp[0];
    //String profileNameInKey= tmp[1];
    //if (userId == null || userId.compareTo(userIdInKey) != 0) continue;
    String firstName = (String) e.getProperty("firstName");
    String lastName = (String) e.getProperty("lastName");
    String address = (String) e.getProperty("address");
%>    <tr>
        <td><%=keyname%></td>

        <td><%=firstName %></td>
        <td><%=lastName %></td>
        <td><%=address %></td>
    </tr>
    <%
}
%>
    </table>

</body>
</html>
