class ProductView extends Backbone.View

  initialize: (options) ->
    { @cart } = options

  className: "epages-shop-product epages-col-xs-12 epages-col-sm-8 epages-col-md-8 epages-col-lg-4"

  events:
    "click .epages-shop-product-link": "openProductDetails"

  template: _.template """
    <a href="<%= link %>" class="epages-shop-product-link">
      <div class="epages-shop-product-list-image-container">
        <img class="img-product-list-thumbnail" src="<%= image %>"/>
      </div>
      <div class="epages-shop-product-name"><%= name %></div>
      <% if(manufacturerPrice) { %>
        <div class="epages-shop-product-manufacturer-price">
          <div data-i18n="old-price"></div>
          <div class="price"> <%= manufacturerPrice %></div>
        </div>
      <% } %>
      <div class="epages-shop-product-price">
        <%= price %>
      </div>
      <% if(basePrice) { %>
        <div class="epages-shop-product-base-price">( <%= basePrice %> )</div>
      <% } %>
    </a>
  """

  render: ->
    @$el.html @template
      image: @model.smallImage()
      name:  @model.name()
      price: @model.productFormattedPrice("card")
      link:  @model.link()
      basePrice: @model.basePrice()
      manufacturerPrice: @model.manufacturerPrice()
    App.i18n(this)
    this

  openProductDetails: (event) ->
    event.preventDefault()

    productDetailView = new ProductDetailView(model: @model)
    @model.loadVariations()
    productDetailView.render()

    App.modal.open(productDetailView)
