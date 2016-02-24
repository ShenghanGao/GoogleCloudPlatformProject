<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.*" %>
<%@ page import="com.google.appengine.api.memcache.*" %>

<!--%@ page import="com.google.appengine.api.blobstore.BlobKey" %-->
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>

<%@ page import="java.util.List" %>

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
    String profileName = request.getParameter("profileName");
    User user = userService.getCurrentUser();

    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
    if (user != null) {
        pageContext.setAttribute("user", user);
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
//String uploadUrl = "/rest/blobstoreenqueue/newprofilephoto?profileName=" + URLEncoder.encode(profileName, "UTF-8");
String uploadUrl = "/blobstorenewphoto?profileName=" + URLEncoder.encode(profileName, "UTF-8");
%>

<form action="<%= blobstoreService.createUploadUrl(uploadUrl) %>" method="post" enctype="multipart/form-data">
    <p>Profile photo:</p>
    <input type="file" name="myFile">
  <input type="submit" value="Submit">
</form>

</body>
</html>
