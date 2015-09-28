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
    <style type="text/css">
      .shop-pagination li {
        display:inline;
        color:#fff;
      }

      .shop-pagination>li:first-child>a, .shop-pagination>li:first-child>span {
        margin-left: 0;
        border-top-left-radius: 4px;
        border-bottom-left-radius: 4px;
      }

      .shop-pagination>li:last-child>a, .shop-pagination>li:last-child>span {
        margin-right: 0;
        border-top-right-radius: 4px;
        border-bottom-right-radius: 4px;
      }
      .shop-pagination>li>a, .shop-pagination>li>span {
        padding: 6px 12px;
        margin-left: -5px;
        color: #337ab7;
        text-decoration: none;
        background-color: #fff;
        border: 1px solid #dedede;
      }

      .shop-pagination>li.active>a{
        background-color: #337ab7;
        color: #fff;
      }
    </style>
  """

  render: ->
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