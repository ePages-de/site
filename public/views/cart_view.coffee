class CartView extends Backbone.View

  initialize: ->
    @listenTo @model, "update", @render

  events:
    "click .epages-cart-button": "openCartDetails"

  template: _.template """
    <button class="epages-cart-button">Shopping cart (<%= count %>)</button>
  """

  render: ->
    @$el.html @template(count: @model.count())
    this

  openCartDetails: (event) ->
    event.preventDefault()

    view = new CartDetailView(model: @model).render()
    App.modal(view)
