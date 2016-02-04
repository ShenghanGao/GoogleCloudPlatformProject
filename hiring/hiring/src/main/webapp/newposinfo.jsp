<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <!--link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/-->
</head>

<body>

<h1>Hiring Platform</h1>

<p>I am a job seeker, POST my information!</p>
<p>I am an employer, POST my positions!</p>

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
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
%>

<form action="/enqueue/newposinfo" method="post">
	<p>Title</p>
    <div><input type="text" name="title"/></div>
    <p>Location</p>
    <div><input type="text" name="location"/></div>
    <p>Description</p>
    <div><input type="text" name="description"/></div>
    <div><input type="submit" value="Submit"/></div>
</form>

</body>
</html>
