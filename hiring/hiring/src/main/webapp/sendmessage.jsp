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

    String userIdTo = request.getParameter("userIdTo");
    String userEmailTo = request.getParameter("userEmailTo");
    System.out.println("In sendmessage.jsp:  userEmailTo = " + userEmailTo);


%>

<br>

<form action="/rest/messageenqueue/sendmessage" method="post">
    <!--input type="hidden" name="userIdFrom" value="<%=userId %>"-->
    <input type="hidden" name="userIdTo" value="<%=userIdTo %>">
    <input type="hidden" name="userEmailTo" value="<%=userEmailTo%>">
    <p>Send a message:</p>
    <input type="text" name="message">
    <input type="submit" value="Submit">
</form>

</body>
</html>
