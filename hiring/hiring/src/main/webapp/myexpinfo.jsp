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
%>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));

    String profileName = request.getParameter("profileName");

    Key userKey = KeyFactory.createKey("User", userId);
    Key seekerInfoKey = KeyFactory.createKey(userKey, "SeekerInfo", profileName);

    Query q = new Query("SeekerExpInfo").setAncestor(seekerInfoKey);
    PreparedQuery pq = datastore.prepare(q);

    %>

    <a href="/newexpinfo.jsp?profileName=<%=profileName%>">Add new exp to this profile</a>

    <table>
    <tr>
        <td>userId</td>
        <td>myProfileName</td>
        <td>expName</td>
        <td>title</td>
        <td>companyName</td>
        <td>location</td>
        <td>timePeriod</td>
        <td>description</td>
    </tr>
<%
    for (Entity e : pq.asIterable()) {
    String myProfileName = (String) e.getProperty("profileName");

    String expName = (String) e.getProperty("expName");
    String title = (String) e.getProperty("title");
    String companyName = (String) e.getProperty("companyName");
    String location = (String) e.getProperty("location");
    String timePeriod = (String) e.getProperty("timePeriod");
    String description = (String) e.getProperty("description");
%>  <tr>
        <td><%=userId %></td>
        <td><%=myProfileName %></td>
        <td><%=expName %></td>
        <td><%=title %></td>
        <td><%=companyName %></td>
        <td><%=location %></td>
        <td><%=timePeriod %></td>
        <td><%=description %></td>
        <td><a href="/editexpinfo.jsp?profileName=<%=myProfileName%>&amp;expName=<%=expName%>"> Edit this exp</a></td>
        <td>
            <form action="/rest/infoenqueue/deleteexpinfo?profileName=<%=myProfileName%>&amp;expName=<%=expName%>" method="post">
                <input type="submit" value="Delete this exp" />
            </form>

        </td>
    </tr>
    <%
}
%>
    </table>

</body>
</html>
