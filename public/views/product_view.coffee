class ProductView extends Backbone.View

  initialize: (options) ->
    { @cart } = options

  className: "epages-shop-product"

  events:
    "click .epages-shop-product-link": "openProductDetails"

  template: _.template """
    <a href="<%= link %>" class="epages-shop-product-link">
      <div class="epages-shop-product-list-image-container">
        <img class="img-product-list" src="<%= image %>"/>
      </div>
      <div class="epages-shop-product-name"><%= name %></div>
      <div class="epages-shop-product-price">
        <%= price %>
      </div>
    </a>
  """

  render: ->
    @$el.html @template
      image: @model.largeImage()
      name:  @model.name()
      price: @model.productFormattedPrice("card")
      link:  @model.link()

    this

  openProductDetails: (event) ->
    event.preventDefault()

    productDetailView = new ProductDetailView(model: @model)
    @model.loadVariations()
    productDetailView.render()

    App.modal.open(productDetailView)
