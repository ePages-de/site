class SortView extends Backbone.View

  initialize: ->
    @sort = @direction = null

  tagName: "label"

  events:
    "change select": "onChange"

  template: _.template """
    Sort by:
    <select>
      <option value="">Name</option>
      <option value="price,asc" data-i18n='price-asc'></option>
      <option value="price,desc" data-i18n='price-desc'></option>
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
