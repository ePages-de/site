class ProductView extends Backbone.View
  template: _.template """
    <div class="epages-shop-product">
      <img src="<%= image %>"/>
      <div class="epages-shop-product-name"><%= name %></div>
      <div class="epages-shop-product-price" style="font-weight: bold">
        <%= price %>
      </div>
    </div>
  """

  render: ->
    @template
      image: _.findWhere(@model.attributes.images, classifier: "Small").url
      name:  @model.attributes.name
      price: @model.attributes.priceInfo.price.formatted
