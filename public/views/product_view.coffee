class ProductView extends Backbone.View

  initialize: (options) ->
    { @cart } = options

  className: "epages-shop-product col-lg-3 col-md-3 col-sm-4 col-xs-12"

  events:
    "click .epages-shop-product-link": "openProductDetails"

  template: _.template """
    <a href="<%= link %>" class="epages-shop-product-link">
      <div class="epages-shop-product-list-image-container">
        <img src="<%= image %>"/>
      </div>
      <div class="epages-shop-product-name"><%= name %></div>
      <div class="epages-shop-product-price" style="font-weight: bold">
        <%= price %>
      </div>
    </a>
  """

  render: ->
    @$el.html @template
      image: @model.smallImage()
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
