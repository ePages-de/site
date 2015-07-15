class CartLineItemView extends Backbone.View

  tagName: "tr"

  events:
    'click .epages-cart-overlay-line-item-destroy': 'destroyLineItem'

  template: _.template """
  <td>
    <img src="<%= thumbnail %>">
  </td>
  <td><%= quantity %></td>
  <td><%= unit %></td>
  <td><%= name %></td>
  <td><%= singleItemPrice %></td>
  <td><%= lineItemPrice %></td>
  <td><a href="#" class="epages-cart-overlay-line-item-destroy">Remove</a></td>
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

  destroyLineItem: (event) ->
    event.preventDefault()
    @model.destroy()
