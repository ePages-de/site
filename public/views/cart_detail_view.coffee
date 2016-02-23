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
    <h2 class="epages-cart-healine" data-i18n='basket'></h2>

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
                <td></td>
                <td class="epages-cart-overlay-delivery-price"><%= deliveryPrice.formatted %></td>
              </tr>
              <% } %>
              <tr>
                <td colspan="4">
                  <div class="epages-cart-overlay-product-price-desc" data-i18n='subtotal'></div>
                  <div class="epages-cart-overlay-product-shipping">
                    <span data-i18n='include-vat'></span> <a href="<%= shippingUrl %>" target="_blank" data-i18n='shipping'></a>.
                  </div>
                </td>
                <td></td>
                <td class="epages-cart-overlay-product-price">
                  <b><%= subTotal %></b>
                </td>
              </tr>
            </tfoot>
          </table>
          <div class="epages-row">
          <div class="epages-cart-overlay-secure epages-col-xs-10 epages-col-sm-6 epages-col-md-8 epages-col-lg-10" data-i18n='ssl'></div>
          <div class="epages-col-xs-2 epages-col-sm-6 epages-col-md-4 epages-col-lg-2">
          <button class="epages-cart-overlay-checkout-button" data-i18n='checkout'></button></div>
        </div></div>
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
    left = (screen.width - 600)/2
    top = (screen.height - 520)/2
    checkoutWindow = window.open("#{App.rootUrl}/checkout.html", 'newwindow',"width=600px, height=500px, top=#{top}px, left=#{left}px")

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
