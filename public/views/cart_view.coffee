class CartView extends Backbone.View

  initialize: ->
    @listenTo @collection, "reset update", @render

  tagName: "button"

  className: "epages-cart-button"

  events:
    "click": "openCart"

  template: _.template """
    <i class="fa fa-shopping-cart"></i><span><%= count %></span>
  """

  render: ->
    quantity = @countProducts()
    @$el.html @template(count: quantity)
    this

  openCart: (event) ->
    event.preventDefault()

    view = new CartDetailView(collection: @collection).render()
    App.modal.open(view)

  countProducts: () ->
    lineProducts = JSON.parse(@collection.storage.storage["epages-shop-cart-products"])
    quantity = 0
    for product in lineProducts
      quantity += product.quantity
    quantity
