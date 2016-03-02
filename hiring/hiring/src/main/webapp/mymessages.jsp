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

    String conversationKeyString = request.getParameter("conKeyString");
    Key conversationKey = KeyFactory.stringToKey(conversationKeyString);

    Entity conversation = null;
    try {
        conversation = datastore.get(conversationKey);
    } catch (EntityNotFoundException e) {

    }
    if (conversation != null) {
        String userIdFrom = (String) conversation.getProperty("userIdFrom");
        String userEmailFrom = (String) conversation.getProperty("userEmailFrom");
        String userIdTo = (String) conversation.getProperty("userIdTo");
        String userEmailTo = (String) conversation.getProperty("userEmailTo");
        boolean isSender = userIdFrom.compareTo(userId) == 0;
        String withWhomId = isSender ? userIdTo : userIdFrom;
        String withWhom = isSender ? userEmailTo : userEmailFrom;
%>
        <p><b>Conversation with <%=withWhom%></b>:</p>
<%

        Query messageQuery = new Query("Message").setAncestor(conversationKey);
        PreparedQuery preparedMessages = datastore.prepare(messageQuery);
        if (preparedMessages != null) {
            System.out.println("Entity message is NOT null!!");
            for (Entity message : preparedMessages.asIterable()) {
                String theMessage = (String) message.getProperty("message");
%>
            <ul>
                <li>userIdForm: <%=userIdFrom %></li>
                <li>userEmailFrom: <%=userEmailFrom %></li>
                <li>userIdTo: <%=userIdTo %></li>
                <li>userEmailTo: <%=userEmailTo %></li>
                <li>message: <%=theMessage %></li>
            </ul>
<%
            }
%>
    <br><br>
    <a href="sendmessage.jsp?userIdTo=<%=withWhomId%>&amp;userEmailTo=<%=withWhom %>">Send a message to <%=withWhom%></a>
<%
        }
        else {
%>
    <p>Entity message is null!!</p>
<%
                System.out.println("Entity message is null!!");
        }
    }
    else {
%>
<p><b>You do not have conversation with this user!</b>!</p>
<%
    }
%>

</body>
</html>
