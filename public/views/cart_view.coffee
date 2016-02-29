class CartView extends Backbone.View

  initialize: ->
    @listenTo @collection, "reset update", @render

  tagName: "button"

  className: "epages-cart-button"

  events:
    "click": "openCart"

  template: _.template """
    <i class="fa fa-2x fa-shopping-cart"></i><span><%= count %></span>
  """

  render: ->
    @$el.html @template(count: @collection.length)
    this

  openCart: (event) ->
    event.preventDefault()

    view = new CartDetailView(collection: @collection).render()
    App.modal.open(view)
