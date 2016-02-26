class PaginationView extends Backbone.View

  events:
    'click a.previous_page' : 'previous'
    'click a.next_page'     : 'next'
    'click a.set_page'      : 'goto_page'

  initialize: ->
    @listenTo @collection, "click reset", @render


  template: _.template """
    <ul class="shop-pagination">
      <li><a class="previous_page" href="#">&lt;</a></li>
      <% _.map(selected_pages, function(num) { %>
        <li class="<% if(current_page == num){ %><%= 'active' %><% }%>" ><a class="<% if(!isNaN(num)){ %><%= 'set_page' %><% }%>" href="#"><%= num %></a></li>
      <% }); %>
      <li><a class="next_page" href="#">&gt;</a></li>
    </ul>
  """

  render: ->
    if @collection.pages > 1
      @$el.html @template({pages: @collection.pages, current_page: @collection.page, selected_pages: @windowed_page() })
    this

  previous: ->
    @page = @collection.page - 1
    if @page == 0 then @page = 1
    @change_page()

  next: ->
    @page = @collection.page + 1
    if @page > @collection.pages then @page = @collection.pages
    @change_page()

  goto_page: (event) ->
    event.preventDefault()
    @page = event.target.text || null
    @change_page()

  windowed_page: ->
    total_pages = parseInt(@collection.pages)
    inner_window = 2
    outer_window = 1
    window_from = parseInt(@collection.page) - inner_window
    window_to = parseInt(@collection.page) + inner_window
    if window_to > total_pages
      window_from -= window_to - total_pages
      window_to = total_pages
    if window_from < 1
      window_to  += 1 - window_from
      window_from = 1
      window_to = total_pages if window_to > total_pages

    middle = [window_from..window_to]

    if outer_window + 3 < middle[0]
      left = [1..(outer_window + 1)]
      left.push "..."
    else
      left = [1...middle[0]]

    if (total_pages - outer_window - 2) > middle[middle.length - 1]
      right = [(total_pages - outer_window)..total_pages]
      right.unshift "..."
    else
      right_start = Math.min(middle[middle.length - 1] + 1, total_pages)
      right = [right_start..total_pages]
      right = [] if right_start is total_pages

    left.concat(middle.concat(right))

  change_page: ->
    $(".epages-shop-pagination ul li").removeClass("active")
    $(".epages-shop-pagination ul li:contains(#{this.page})").addClass("active")
    if @page then @trigger "change:page"