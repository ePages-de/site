class CartLineItemView extends Backbone.View

  tagName: "tr"

  events:
    "change .epages-cart-overlay-line-item-quantity": "changeQuantity"
    "click .epages-cart-overlay-line-item-remove": "removeLineItem"
    "click .epages-cart-overlay-line-item-quantity-hidden": "changeQuantityH"

  template: _.template """
    <td class="epages-cart-overlay-image">
      <span class="epages-cart-overlay-line-item-quantity-hidden" style="visibility: hidden;" id="h-<%= productId %>"></span>
      <img src="<%= itemImage %>">
    </td>
    <td class="epages-cart-overlay-name"><%= name %></td>
    <td class="epages-cart-overlay-price"><span class="epages-cart-overlay-subhead-narrow" data-i18n='unit-price'></span><%= singleItemPrice %></td>
    <td class="epages-cart-overlay-quantity">
      <span class="epages-cart-overlay-subhead-narrow" data-i18n='quantity' id="s-<%= productId %>"></span><input type="number" class="epages-cart-overlay-line-item-quantity" value="<%= quantity %>">
      <%= unit %>
    </td>
    <td class="epages-cart-overlay-total"><span class="epages-cart-overlay-subhead-narrow" data-i18n='total-price'></span><%= lineItemPrice %></td>
    <td class="epages-cart-overlay-remove">
      <button class="epages-cart-overlay-line-item-remove"
              alt="Remove product"
              id="b-<%= productId %>">
      </button><span class='tooltip' data-i18n='remove-line-item'></span>
    </td>
  """

  render: ->
    @$el.html @template
      itemImage:       @model.get("variationImage") || @model.largeImage()
      name:            @model.name()
      quantity:        @model.quantity()
      unit:            @model.unit()
      singleItemPrice: @model.formattedPrice()
      lineItemPrice:   @model.get("lineItemPrice") || ''
      productId:       @model.get("productId")

    App.i18n(this)
    this

  changeQuantity: (event) ->
    quantity = parseInt(event.target.value)
    top = @model.get("stocklevel")
    if quantity > top
      quantity = top
    @model.set(quantity: quantity)

  changeQuantityH: (event) ->
    elementId = event.target.id.split("h-")[1]
    input = document.getElementById("s-" + elementId).nextSibling
    @model.set(quantity: input.value)

  removeLineItem: (event) ->
    event.preventDefault()
    event.target.disabled = true # disable button

    @model.collection.remove(@model)
