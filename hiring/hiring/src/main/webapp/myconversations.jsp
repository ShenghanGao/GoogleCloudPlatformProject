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
    System.out.println("Before datastore!!");
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));

    Key userKey = KeyFactory.createKey("User", userId);
    Query q = new Query("Conversation").setAncestor(userKey);
    PreparedQuery pq = datastore.prepare(q);

    int counter = 0;
    for (Entity entity : pq.asIterable()) {
        ++counter;
    }
    System.out.println("Counter = " + counter);

    for (Entity conversation : pq.asIterable()) {
        Key conversationKey = conversation.getKey();
        String userIdFrom = (String) conversation.getProperty("userIdFrom");
        String userEmailFrom = (String) conversation.getProperty("userEmailFrom");
        String userIdTo = (String) conversation.getProperty("userIdTo");
        String userEmailTo = (String) conversation.getProperty("userEmailTo");

        boolean isSender = userIdFrom.compareTo(userId) == 0; 
        String withWhom = isSender ? userEmailTo : userEmailFrom;

        String conversationKeyString = KeyFactory.keyToString(conversationKey);
%>
<a href="/mymessages.jsp?conKeyString=<%=conversationKeyString%>">Conversation with: <%=withWhom %></a>
<br>
<%
}
%>

</body>
</html>
