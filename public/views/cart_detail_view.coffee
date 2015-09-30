class CartDetailView extends Backbone.View

  initialize: ->
    @listenTo @collection, "reset update change", @render

  events:
    "click .epages-cart-overlay-checkout-button": "checkout"

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

    <style type="text/css">
      .epages-cart-overlay {
        color: #444;
      }
      .epages-cart-overlay h2 {
        color: #333;
      }
      .epages-cart-overlay-fail {
        background-color: #e00;
        color: #fff;
        padding: 10px 15px;
        margin-bottom: 20px;
      }
      .epages-cart-overlay table {
        border: 1px solid #ccc;
        border-left: 0;
        border-right: 0;
        width: 100%;
      }
      .epages-cart-overlay table th {
        text-align: left;
        padding: 20px 10px 5px;
      }
      .epages-cart-overlay table td {
        padding: 5px 10px;
      }
      .epages-cart-overlay table tfoot td {
        padding: 10px 10px 20px;
      }
      .epages-cart-overlay-product-price-desc {
        font-weight: bold;
        font-size: 120%;
      }
      .epages-cart-overlay-product-price {
        vertical-align: top;
      }
      .epages-cart-overlay-product-shipping {
        font-size: 80%;
      }
      .epages-cart-overlay-secure {
        padding: 20px 10px 0 50px;
        background: url(#{App.rootUrl}/images/secure.png) 0 25px no-repeat;
      }
      .epages-cart-overlay-checkout-button {
        float: right;
        margin: 0 auto 10px;
        vertical-align: right;
      }

      .epages-cart-overlay-line-item-quantity {
        margin-right: 5px;
      }
      .epages-cart-overlay-line-item-remove {
        display: block;
        cursor: pointer;
        background: url(#{App.rootUrl}/images/remove.png) 0 0 no-repeat;
        border: 0;
        outline: none;
        width: 20px;
        height: 20px;
      }
      .epages-cart-overlay-line-item-remove:disabled {
        cursor: auto;
      }
    </style>
  """

  render: ->
    @$el.html @template
      subTotal: @collection.lineItemsSubTotal()
      shippingUrl: @collection.shippingUrl
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
