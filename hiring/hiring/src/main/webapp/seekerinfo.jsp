<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.*" %>
<%@ page import="com.google.appengine.api.memcache.*" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilter" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilterOperator" %>


<%@ page import="java.util.logging.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <!--link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/-->
</head>

<body>

<h1>Hiring Platform</h1>

<a href="seekerinfo.jsp">List All</a>

<%
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

<form action="/rest/search/seekerinfo" method="post">
    FirstName:
    <input type="search" name="firstNameSearch">
    LastName:
    <input type="search" name="lastNameSearch">
    Tag:
    <input type="search" name="tagSearch">
    <input type="submit">
</form>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
    String firstNameSearch = request.getParameter("firstNameSearch");
    String lastNameSearch = request.getParameter("lastNameSearch");
    String tagSearch = request.getParameter("tagSearch");

    Query q = new Query("SeekerInfo");

    if (firstNameSearch != null && !firstNameSearch.isEmpty()) {
    Filter qFilter = q.getFilter();


    Filter firstNameFilter = new FilterPredicate("firstName",
    FilterOperator.EQUAL, firstNameSearch);

    setQueryFilterAnd(q, firstNameFilter);
/*
if (qFilter == null) {
    q.setFilter(firstNameFilter);
}
else {
    List<Filter> filters = new ArrayList<Filter> ();
    filters.add(qFilter);
    filters.add(firstNameFilter);

    Filter compositeFilter = new CompositeFilter(CompositeFilterOperator.AND, filters);

    //Filter compositeFilter = new CompositeFilter(CompositeFilterOperator.AND, Arrays.asList(qFilter, firstNameFilter));

    q.setFilter(compositeFilter);
}
*/
}

    if (lastNameSearch != null && !lastNameSearch.isEmpty()) {

    Filter qFilter = q.getFilter();


    Filter lastNameFilter = new FilterPredicate("lastName",
    FilterOperator.EQUAL, lastNameSearch);
    setQueryFilterAnd(q, lastNameFilter);
/*
if (qFilter == null) {
    q.setFilter(lastNameFilter);
}
else {
    List<Filter> filters = new ArrayList<Filter> ();
    filters.add(qFilter);
    filters.add(lastNameFilter);

    Filter compositeFilter = new CompositeFilter(CompositeFilterOperator.AND, filters);

    q.setFilter(compositeFilter);
}
*/
    }

        if (tagSearch != null && !tagSearch.isEmpty()) {

    Filter qFilter = q.getFilter();
    //List<String> l = new ArrayList<String> ();
    //l.add(tagSearch);
    Filter tagFilter = new FilterPredicate("tags",
    FilterOperator.EQUAL, tagSearch);
    setQueryFilterAnd(q, tagFilter);
    }


    PreparedQuery pq = datastore.prepare(q);
    %>
    <table>
<tr>
        <td>userId</td>
        <td>firstName</td>
        <td>lastName</td>
        <td>address</td>
        <td>Tags</td>
    </tr>   
<tr>
<%
    for (Entity e : pq.asIterable()) {
    String userId = (String) e.getProperty("userId");
    String userEmail = (String) e.getProperty("userEmail");
    System.out.println("userEmail = " + userEmail);
    String firstName = (String) e.getProperty("firstName");
    String lastName = (String) e.getProperty("lastName");
    String address = (String) e.getProperty("address");
    List<String> tags = (List<String>) e.getProperty("tags");
    StringBuilder sb = new StringBuilder();
    if (tags != null) {
    for (int i = 0; i <= tags.size()-2; ++i) {
    sb.append(tags.get(i));
    sb.append(", ");
}
    sb.append(tags.get(tags.size()-1));
}
%> 

        <td><%=userId %></td>
        <td><%=firstName %></td>
        <td><%=lastName %></td>
        <td><%=address %></td>
        <td><%=sb.toString() %></td>
        <td>
            <a href="sendmessage.jsp?userIdTo=<%=userId%>&amp;userEmailTo=<%=userEmail%>">Send a message</a>
        </td>
    </tr>
    <%
}
%>
    </table>

</body>
</html>

<%!
private static void setQueryFilterAnd(Query q, Filter filter) {
    Filter qFilter = q.getFilter();
    if (qFilter == null)
        q.setFilter(filter);

    else {
        List<Filter> filters = new ArrayList<Filter> ();
    filters.add(qFilter);
    filters.add(filter);

    Filter compositeFilter = new CompositeFilter(CompositeFilterOperator.AND, filters);

    q.setFilter(compositeFilter);
}
}
%>
