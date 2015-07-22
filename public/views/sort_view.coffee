class SortView extends Backbone.View

  initialize: ->
    @sort = @direction = null

  tagName: "div"

  events:
    "change": "onChange"

  template: _.template """
    Sort by:
    <select name="sort">
      <option value="">Name</option>
      <option value="price,asc">Price 0..9</option>
      <option value="price,desc">Price 9..0</option>
    </select>
  """

  render: ->
    @$el.html @template
    this

  onChange: (event) ->
    event.preventDefault()
    [ @sort, @direction ] = event.target.value.split(",")
    @trigger "change"
