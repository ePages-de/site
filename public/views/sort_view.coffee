class SortView extends Backbone.View

  initialize: ->
    @sort = @direction = null

  tagName: "input-group"

  events:
    "change select": "onChange"

  template: _.template """
    <label for="sortby" data-i18n='sortby'></label>
    <select class="form-control" id="sortby">
      <option value="" data-i18n='name'></option>
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
    Backbone.trigger 'sort:changed', @
