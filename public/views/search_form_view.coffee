class SearchFormView extends Backbone.View
  tagName: "form"
  className: "epages-search-form"
  events:
    "submit": "onSubmit"

  template: _.template """
  <input type="text" class="epages-search-form"  placeholder="Search">
  """

  render: ->
    @$el.html @template
    App.i18n(this)
    this

  reset: ->
    @$el.find("input[type='text']").val(null)

  onSubmit: (event) ->
    event.preventDefault()
    @trigger "change:query", @$el.find("input[type='text']").val()
