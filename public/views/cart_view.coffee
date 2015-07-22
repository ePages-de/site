class CartView extends Backbone.View

  initialize: ->
    @listenTo @model, "update refresh", @render

  events:
    "click .epages-cart-button": "openCart"

  template: _.template """
    <button class="epages-cart-button">Shopping cart (<%= count %>)</button>
  """

  render: ->
    @$el.html @template(count: @model.lineItems.length)
    this

  openCart: (event) ->
    event.preventDefault()

    view = new CartDetailView(model: @model).render()
    App.modal.open(view)
