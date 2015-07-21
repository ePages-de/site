App.env = "<%= data.env %>"

<%= data.contents %>

<% if (data.env === "test") { %>
# Export Zepto to be used by Jasmine.
window.$j = Zepto
<% } %>
