<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.*" %>
<%@ page import="com.google.appengine.api.memcache.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.logging.*" %>

<%@ page import="com.google.appengine.api.blobstore.BlobKey" %>
<%@ page import="com.google.appengine.api.images.ServingUrlOptions" %>

<%@ page import="com.google.appengine.api.images.ImagesService" %>
<%@ page import="com.google.appengine.api.images.ImagesServiceFactory" %>

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

    ImagesService imagesService = ImagesServiceFactory.getImagesService();
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

    Key userKey = KeyFactory.createKey("User", userId);
    Query q = new Query("SeekerInfo").setAncestor(userKey);
    PreparedQuery pq = datastore.prepare(q);
    %>
    <table>
    <tr>
        <td>myUserId</td>
        <td>profileName</td>
        <td>firstName</td>
        <td>lastName</td>
        <td>address</td>
    </tr>


<%
    for (Entity e : pq.asIterable()) {
    String myUserId = (String) e.getProperty("userId");
    String firstName = (String) e.getProperty("firstName");
    String lastName = (String) e.getProperty("lastName");
    String address = (String) e.getProperty("address");
    String profileName = (String) e.getProperty("profileName");
    String profilePhoto = (String) e.getProperty("profilePhoto");
    String servingUrl = null;
    if (profilePhoto != null) {
    BlobKey blobKey = new BlobKey(profilePhoto);

    ServingUrlOptions servingUrlOptions = ServingUrlOptions.Builder.withBlobKey(blobKey);
    servingUrl = imagesService.getServingUrl(servingUrlOptions);
}
%>    <tr>


<%
System.out.println("servingUrl = " + servingUrl);
    if (servingUrl != null) {
%>
<td><img src="<%= servingUrl %>" height="88" width="88"></td>
<%
}
%>
<td><a href="/profileaction.jsp?profileName=<%=profileName %>">Profile action</a></td>
        <td><a href="/myexpinfo.jsp?profileName=<%=profileName %>">Exp details</a></td>
        <td><%=myUserId %></td>
        <td><%=profileName %></td>
        <td><%=firstName %></td>
        <td><%=lastName %></td>
        <td><%=address %></td>
        <td><a href="/editseekerinfo.jsp?profileName=<%=profileName%>"> Edit this seeker info</a></td>
        <td>
            <form action="/rest/infoenqueue/deleteseekerinfo?profileName=<%=profileName%>" method="post">
                <input type="submit" value="Delete this seeker info" />
            </form>

        </td>
    </tr>
    <%
}
%>
    </table>

</body>
</html>
