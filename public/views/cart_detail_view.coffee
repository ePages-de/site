class CartDetailView extends Backbone.View

  initialize: ->
    @collection.sync()
    @listenTo @collection, "reset update change", @render

  events:
    "click .epages-cart-overlay-checkout-button": "checkout"
    "click .epages-cart-overlay-line-item-remove": "sync"
    "change .epages-cart-overlay-line-item-quantity": "sync"

  template: _.template """
    <div class="epages-cart-overlay">
      <h2>Basket</h2>

      <% if (failedToCreateCart) { %>
        <div class="epages-cart-overlay-fail">
          Oops. This took longer than it should. Please try again now!
        </div>
      <% } %>

      <div class="epages-cart-overlay-not-empty" style="display:none">
        <table class="epages-cart-overlay-line-table">
          <thead>
            <tr>
              <th></th>
              <th>Quantity</th>
              <th>Name</th>
              <th>Unit price</th>
              <th>Total price</th>
              <th>Remove</th>
            </tr>
          </thead>
          <tbody></tbody>
          <tfoot>
            <% if (deliveryPrice) { %>
              <tr>
                <td colspan="4">Delivery Price</td>
                <td class="epages-cart-overlay-delivery-price"><%= deliveryPrice.formatted %></td>
                <td></td>
              </tr>
            <% } %>
            <tr>
              <td colspan="4">
                <div class="epages-cart-overlay-product-price-desc">Subtotal</div>
                <div class="epages-cart-overlay-product-shipping">
                  includes VAT, plus <a href="<%= shippingUrl %>" target="_blank">Shipping</a>.
                </div>
              </td>
              <td class="epages-cart-overlay-product-price">
                <b><%= subTotal %></b>
              </td>
              <td></td>
            </tr>
          </tfoot>
        </table>

        <div class="epages-cart-overlay-secure">
          Your data will be transmitted through an encrypted connection (SSL)<br>
          and will not be disclosed to third parties.
        </div>

        <button class="epages-cart-overlay-checkout-button">Check out</button>
      </div>

      <div class="epages-cart-overlay-is-empty" style="display:none">
        <p>Your basket is empty.</p>
      </div>
    </div>
  """

  render: ->
    @$el.html @template
      subTotal: @collection.lineItemsSubTotal()
      shippingUrl: @collection.shippingUrl
      deliveryPrice: @collection.deliveryPrice
      failedToCreateCart: @failedToCreateCart

    if @collection.isEmpty()
      @$(".epages-cart-overlay-is-empty").show()
    else
      html = @collection.map (lineItem) ->
        view = new CartLineItemView(model: lineItem)
        view.render().el

      @$(".epages-cart-overlay-line-table tbody").html html
      @$(".epages-cart-overlay-not-empty").show()

    this

  sync: ->
    @collection.sync()

  checkout: ->
    checkoutWindow = window.open("#{App.rootUrl}/checkout.html", "_blank")

    # XXX: can we get rid of this maybe?
    App.modal.closeAll()

    App.cart.save()
      .done (response) ->
        checkoutWindow.location = response.checkoutUrl
      .fail =>
        checkoutWindow.close()

        @failedToCreateCart = true
        @render()
        @failedToCreateCart = false

        App.modal.open(this)
