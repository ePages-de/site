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
      <h2 data-i18n='basket'></h2>

      <% if (failedToCreateCart) { %>
        <div class="epages-cart-overlay-fail" data-i18n='basket-fail'></div>
      <% } %>

      <div class="epages-cart-overlay-not-empty" style="display:none">
        <table class="epages-cart-overlay-line-table">
          <thead>
            <tr>
              <th></th>
              <th data-i18n='name'></th>
              <th data-i18n='unit-price'></th>
              <th data-i18n='quantity'></th>
              <th></th>
              <th data-i18n='total-price'></th>
            </tr>
          </thead>
          <tbody></tbody>
          <tfoot>
            <% if (deliveryPrice) { %>
              <tr>
                <td colspan="4" data-i18n='shipping-price'></td>
                <td class="epages-cart-overlay-delivery-price"><%= deliveryPrice.formatted %></td>
                <td></td>
              </tr>
            <% } %>
            <tr>
              <td colspan="4">
                <div class="epages-cart-overlay-product-price-desc" data-i18n='subtotal'></div>
                <div class="epages-cart-overlay-product-shipping">
                  <span data-i18n='include-vat'></span> <a href="<%= shippingUrl %>" target="_blank" data-i18n='shipping'></a>.
                </div>
              </td>
              <td class="epages-cart-overlay-product-price">
                <b><%= subTotal %></b>
              </td>
              <td></td>
            </tr>
          </tfoot>
        </table>

        <div class="epages-cart-overlay-secure" data-i18n='ssl'></div>

        <button class="epages-cart-overlay-checkout-button" data-i18n='checkout'></button>
      </div>

      <div class="epages-cart-overlay-is-empty" style="display:none">
        <p data-i18n='basket-empty'></p>
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

    App.i18n(this)
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
