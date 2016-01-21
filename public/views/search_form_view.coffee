class SearchFormView extends Backbone.View

  tagName: "form"

  events:
    "submit": "onSubmit"

  template: _.template """
    <div class="input-group">
    <input type="text" class="form-control">
    <span class="input-group-btn">
    <button type="submit" class="btn btn-default" data-i18n="search" value="search"> </span>
    </button></div>
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
