class CartDetailView extends Backbone.View

  initialize: ->
    @sync()
    @listenTo @collection, "reset update change", @render

  events:
    "click .epages-cart-overlay-checkout-button": "checkout"
    "click .epages-cart-overlay-line-item-remove": "sync"
    "change .epages-cart-overlay-line-item-quantity": "sync"

  template: _.template """
  <div class="epages-cart-overlay">
    <h2 class="epages-cart-healine" data-i18n='basket'></h2>

    <% if (failedToCreateCart) { %>
      <div class="epages-cart-overlay-fail" data-i18n='basket-fail'></div>
    <% } %>
    <div class="epages-cart-overlay-not-empty" style="display:none">
      <table class="epages-cart-overlay-line-table">
        <thead>
          <tr>
            <th class="epages-cart-overlay-image"></th>
            <th class="epages-cart-overlay-name" data-i18n='name'></th>
            <th class="epages-cart-overlay-price" data-i18n='unit-price'></th>
            <th class="epages-cart-overlay-quantity" data-i18n='quantity'></th>
            <th class="epages-cart-overlay-total" data-i18n='total-price'></th>
            <th class="epages-cart-overlay-remove"></th>
          </tr>
        </thead>
        <tbody></tbody>
        <tfoot>
          <% if (deliveryPrice) { %>
            <tr>
              <td colspan="4" data-i18n='subtotal'></td>
              <td class="epages-cart-overlay-delivery-price"><%= subTotal %></td>
              <td class="epages-cart-overlay-remove"></td>
            </tr>
            <tr>
              <td colspan="4"><%= deliveryName %></td>
              <td class="epages-cart-overlay-delivery-price"><%= deliveryPrice %></td>
              <td class="epages-cart-overlay-remove"></td>
            </tr>
          <% } %>
          <tr>
            <td colspan="4">
              <div class="epages-cart-overlay-product-price-desc" data-i18n='total-price'></div>
              <div class="epages-cart-overlay-product-taxes">
                <span data-i18n='include-vat-cart'></span>
              </div>
            </td>
            <td class="epages-cart-overlay-total-price">
              <b><%= total %></b>
            </td>
            <td class="epages-cart-overlay-remove"></td>
          </tr>
        </tfoot>
      </table>

      <button class="epages-cart-overlay-checkout-button" data-i18n='checkout'></button>
      <div class="epages-cart-overlay-secure" data-i18n='ssl'></div>
    </div>
    <div class="epages-cart-overlay-is-empty" style="display:none">
      <p data-i18n='basket-empty'></p>
    </div>
  </div>
"""

  render: ->
    @$el.html @template
      subTotal: @collection.subTotal
      total: @collection.total
      shippingUrl: @collection.shippingUrl
      deliveryPrice: @collection.deliveryPrice
      deliveryName: @collection.deliveryName
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
    left = screen.width/2 - 300
    top = screen.height/2 - 350
    checkoutWindow = window.open("#{App.rootUrl}/checkout.html", 'newwindow',"width=600,height=620,scrollbars=yes,top=#{top},left=#{left}")

    # XXX: can we get rid of this maybe?
    App.modal.closeAll()

    if @checkoutUrl
      checkoutWindow.location = @checkoutUrl
    else
      App.cart.save()
        .done (response) ->
          checkoutWindow.location = response.checkoutUrl
        .fail =>
          checkoutWindow.close()

          @failedToCreateCart = true
          @render()
          @failedToCreateCart = false

          App.modal.open(this)
    setTimeout (->
      App.cart.clearCart()
      App.cart.save()
    ), 10000
