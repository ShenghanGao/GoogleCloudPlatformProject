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
    response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
}
%>

<form action="/enqueue/newseekerinfo" method="post">
    <p>Profile Name</p>
    <div><input type="text" name="profileName"></div>
    <p>First Name</p>
    <div><input type="text" name="firstName"/></div>
    <p>Last Name</p>
    <div><input type="text" name="lastName"/></div>
    <p>Address</p>
    <div><input type="text" name="address"/></div>
    <div><input type="submit" value="Submit"/></div>
 </form>

</body>
</html>
