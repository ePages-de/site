class CartView extends Backbone.View

  initialize: ->
    @listenTo @model, "update", @render

  events:
    "click a": "onClick"

  template: _.template """
  <p><a href="#">Your cart</a> contains <%= count %> products.</p>
  """

  render: ->
    @$el.html @template(count: @model.count())
    this

  onClick: (event) ->
    event.preventDefault()

    view = new CartDetailView(model: @model).render()
    App.modal(view)
