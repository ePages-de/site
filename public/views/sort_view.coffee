class SortView extends Backbone.View

  initialize: ->
    @sort = @direction = null

  tagName: "div"

  events:
    "click": "onClick"

  template: _.template """
    Sort by:
    <a href="#" data-sort="name" data-direction="asc">Name</a>
    <a href="#" data-sort="price" data-direction="asc">Price 0..9</a>
    <a href="#" data-sort="price" data-direction="desc">Price 9..0</a>
  """

  render: ->
    @$el.html @template
    this

  onClick: (event) ->
    event.preventDefault()
    @sort = $(event.target).data("sort")
    @direction = $(event.target).data("direction")
    @trigger "change"
