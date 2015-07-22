class CartView extends Backbone.View

  initialize: ->
    @listenTo @model, "update refresh", @render

  tagName: "button"

  className: "epages-cart-button"

  events:
    "click": "openCart"

  template: _.template """
    Basket (<%= count %>)
  """

  render: ->
    @$el.html @template(count: @model.lineItems.length)
    this

  openCart: (event) ->
    event.preventDefault()

    view = new CartDetailView(model: @model).render()
    App.modal.open(view)
