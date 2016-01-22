class CartLineItemView extends Backbone.View

  tagName: "tr"

  events:
    "change .epages-cart-overlay-line-item-quantity": "changeQuantity"
    "click .epages-cart-overlay-line-item-remove": "removeLineItem"

  template: _.template """
    <td>
      <img src="<%= thumbnail %>">
    </td>
    <td><%= name %></td>
    <td><%= singleItemPrice %></td>
    <td>
      <select class="form-control epages-cart-overlay-line-item-quantity">
        <% _.map([1,2,3,4,5], function(num) { %>
          <option value="<%= num %>" <%= quantity === num ? "selected" : void 0 %> >
            <%= num %>
          </option>
        <% }); %>
      </select>
      <%= unit %>
    </td>
    <td>
      <button class="epages-cart-overlay-line-item-remove"
              alt="Remove product">
      </button>
    </td>
    <td><%= lineItemPrice %></td>
  """

  render: ->
    @$el.html @template
      thumbnail:       @model.thumbnailImage()
      name:            @model.name()
      quantity:        @model.quantity()
      unit:            @model.unit()
      singleItemPrice: @model.formattedPrice()
      lineItemPrice:   @model.formattedTotalPrice()
    this

  changeQuantity: (event) ->
    quantity = parseInt(event.target.value)
    @model.set(quantity: quantity)

  removeLineItem: (event) ->
    event.preventDefault()
    event.target.disabled = true # disable button

    @model.collection.remove(@model)
