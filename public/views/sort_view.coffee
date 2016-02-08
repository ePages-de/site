class SortView extends Backbone.View

  initialize: ->
    @sort = @direction = null

  tagName: "label"

  events:
    "change select": "onChange"

  template: _.template """
    <select class="form-control" >
      <option value="">Name</option>
      <option value="price,asc">Price: low to high</option>
      <option value="price,desc">Price: high to low</option>
    </select>
  """

  render: ->
    @$el.html @template
    App.i18n(this)
    this

  onChange: (event) ->
    event.preventDefault()
    [ @sort, @direction ] = event.target.value.split(",")
    @trigger "change"
