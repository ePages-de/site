class ProductView extends Backbone.View

  events:
    "click .epages-shop-product-link": "openProductDetails"

  template: _.template """
    <div class="epages-shop-product">
      <a href="#" class="epages-shop-product-link"><img src="<%= image %>"/></a>
      <div class="epages-shop-product-name"><%= name %></div>
      <div class="epages-shop-product-price" style="font-weight: bold">
        <%= price %>
      </div>
    </div>
  """

  render: ->
    @$el.html @template
      image: _.findWhere(@model.attributes.images, classifier: "Small").url
      name:  @model.attributes.name
      price: @model.attributes.priceInfo.price.formatted

    this

  openProductDetails: (event) ->
    event.preventDefault()
    picoModal("Here goes the modal.").show()