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
    <input type="submit">
</form>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
    String firstNameSearch = request.getParameter("firstNameSearch");
    String lastNameSearch = request.getParameter("lastNameSearch");

    Query q = new Query("SeekerInfo");

    if (firstNameSearch != null && !firstNameSearch.isEmpty()) {
    Filter qFilter = q.getFilter();


    Filter firstNameFilter = new FilterPredicate("firstName",
    FilterOperator.EQUAL, firstNameSearch);

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
}

    if (lastNameSearch != null && !lastNameSearch.isEmpty()) {

    Filter qFilter = q.getFilter();


    Filter lastNameFilter = new FilterPredicate("lastName",
    FilterOperator.EQUAL, lastNameSearch);

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
    }


    PreparedQuery pq = datastore.prepare(q);
    %>
    <table>
<tr>
        <td>userId</td>
        <td>firstName</td>
        <td>lastName</td>
        <td>address</td>
    </tr>   
<tr>
<%
    for (Entity e : pq.asIterable()) {
    String userId = (String) e.getProperty("userId");
    String firstName = (String) e.getProperty("firstName");
    String lastName = (String) e.getProperty("lastName");
    String address = (String) e.getProperty("address");
%> 

        <td><%=userId %></td>
        <td><%=firstName %></td>
        <td><%=lastName %></td>
        <td><%=address %></td>
    </tr>
    <%
}
%>
    </table>

</body>
</html>
