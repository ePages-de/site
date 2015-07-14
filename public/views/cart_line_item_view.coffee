class CartLineItemView extends Backbone.View

  tagName: "tr"

  template: _.template """
  <td>
    <img src="<%= thumbnail %>">
  </td>
  <td><%= quantity %></td>
  <td><%= unit %></td>
  <td><%= name %></td>
  <td><%= singleItemPrice %></td>
  <td><%= lineItemPrice %></td>
  <td>TODO</td>
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
