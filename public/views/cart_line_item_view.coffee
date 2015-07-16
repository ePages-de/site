class CartLineItemView extends Backbone.View

  tagName: "tr"

  events:
    "change .epages-cart-overlay-line-item-quantity": "changeQuantity"
    "click .epages-cart-overlay-line-item-remove": "removeLineItem"

  template: _.template """
  <td>
    <img src="<%= thumbnail %>">
  </td>
  <td>
    <select class="epages-cart-overlay-line-item-quantity">
      <% _.map([1,2,3,4,5], function(num) { %>
        <option value="<%= num %>" <%= quantity === num ? "selected" : void 0 %> ><%= num %></option>
      <% }); %>
    </select>
    <%= unit %>
  </td>
  <td><%= name %></td>
  <td><%= singleItemPrice %></td>
  <td><%= lineItemPrice %></td>
  <td><a href="#" class="epages-cart-overlay-line-item-remove">Remove</a></td>
  """

  render: ->
    @$el.html @template
      thumbnail:       @model.thumbnailImage()
      name:            @model.name()
      quantity:        @model.quantity()
      unit:            @model.unit()
      singleItemPrice: @model.singleItemPrice()
      lineItemPrice:   @model.lineItemPrice()
    this

  changeQuantity: (event) ->
    quantity = parseInt(event.target.value)
    App.cart.changeQuantity(@model, quantity)

  removeLineItem: (event) ->
    event.preventDefault()
    App.cart.removeLineItem(@model)
