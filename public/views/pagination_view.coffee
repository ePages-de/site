class PaginationView extends Backbone.View

  initialize: ->
    @listenTo @collection, "click reset", @render

  events:
    "click": "onClick"

  template: _.template """
    <ul class="shop-pagination">
      <li><a href="#">&lt;</a></li>
      <% _.map(_.range(1,pages + 1), function(num) { %>
        <li class="<% if(current_page == num){ %><%= 'active' %><% }%>" ><a href="#"><%= num %></a></li>
      <% }); %>
      <li><a href="#">&gt;</a></li>
    </ul>
  """

  render: ->
    if @collection.pages > 1
      @$el.html @template({pages: @collection.pages, current_page: @collection.page})
    this

  onClick: (event) ->
    event.preventDefault()

    @page = event.target.text || null
    if @page == "<"
      @page = 1
    if @page == ">"
      @page = @collection.pages

    $(".epages-shop-pagination ul li").removeClass("active")
    $(".epages-shop-pagination ul li:contains(#{this.page})").addClass("active")
    if @page
      @trigger "change:page"