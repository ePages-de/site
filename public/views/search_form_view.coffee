class SearchFormView extends Backbone.View

  tagName: "form"

  events:
    "submit": "onSubmit"

  template: _.template """
    <input type="text">
    <input type="submit" value="Search">
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
