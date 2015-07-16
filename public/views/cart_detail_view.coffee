class CartDetailView extends Backbone.View

  initialize: =>
    @listenTo @model, "update", @render

  events:
    "click .epages-cart-overlay-checkout-button": "checkout"

  template: _.template """
    <div class="epages-cart-overlay">
      <h3>Shopping cart</h3>
      <div class="epages-cart-overlay-not-empty" style="display:none">
        <table class="epages-cart-overlay-line-items">
          <thead>
            <tr>
              <th></th>
              <th>Qty</th>
              <th>Unit</th>
              <th>Description</th>
              <th>Unit price</th>
              <th>Total price</th>
              <th></th>
            </tr>
          </thead>
          <tbody></tbody>
          <tfoot>
            <tr>
              <td colspan="5"><b>Price includes VAT, plus <a href="#">Shipping</a>.</b></td>
              <td><b><%= subTotal %></b></td>
              <td></td>
            </tr>
          </tfoot>
        </table>
        <button class="epages-cart-overlay-checkout-button">Checkout</button>
      </div>
      <div class="epages-cart-overlay-is-empty" style="display:none">
        <p>Your cart is empty.</p>
      </div>
    </div>

    <style type="text/css">
      .epages-cart-overlay table {
        border: 1px solid #ccc;
        border-left: 0;
        border-right: 0;
        width: 100%;
      }
      .epages-cart-overlay table th {
        text-align: left;
        padding: 15px 10px 0;
      }
      .epages-cart-overlay table td {
        padding: 10px;
      }
      .epages-cart-overlay-checkout-button {
        float: right;
        margin: 20px auto 10px;
      }
    </style>
  """

  render: ->
    @$el.html @template
      subTotal: @model.get("lineItemsSubTotal")?.formatted

    if @model.isEmpty()
      @$(".epages-cart-overlay-is-empty").show()
    else
      html = @model.lineItems.map (lineItem) ->
        view = new CartLineItemView(model: lineItem)
        view.render().el

      @$(".epages-cart-overlay-line-items tbody").html html
      @$(".epages-cart-overlay-not-empty").show()

    this

  checkout: ->
    console.log "checkout"
    window.location.href = @model.get("checkoutUrl")
