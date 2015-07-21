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
    this

  onSubmit: (event) ->
    event.preventDefault()
    @trigger "change:query", @$el.find("input[type='text']").val()
