class SearchFormView extends Backbone.View

  events:
    "submit": "onSubmit"

  template: _.template """
  <form class="epages-search-form">
  <input type="text" class="epages-search-form"  placeholder="Search">
  </form>
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
