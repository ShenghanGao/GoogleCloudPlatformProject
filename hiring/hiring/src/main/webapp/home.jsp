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

<p>I am a job seeker, <a href="newseekerinfo.jsp">POST</a> my information!</p>
<p>I am an employer, <a href="newposinfo.jsp">POST</a> my positions!</p>

<%
/*
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
*/
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
        pageContext.setAttribute("user", user);
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

<!--form action="/home.jsp" method="get">
    <div><input type="text" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/></div>
    <div><input type="submit" value="Switch Guestbook"/></div>
</form-->

</body>
</html>
