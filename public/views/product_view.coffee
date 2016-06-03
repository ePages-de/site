class ProductView extends Backbone.View

  initialize: (options) ->
    { @cart } = options

  className: "epages-shop-product"

  events:
    "click .epages-shop-product-link": "openProductDetails"

  template: _.template """
    <a href="<%= link %>" class="epages-shop-product-link">
      <div class="epages-shop-product-list-image-container">
        <img class="img-product-list" data-object-fit="contain" src="<%= image %>"/>
      </div>
      <div class="epages-shop-product-list-text-container">
	      <div class="epages-shop-product-name"><%= name %></div>
	      <% if(manufacturerPrice) { %>
	        <div class="epages-shop-product-manufacturer-price">
	          <label data-i18n='manufacturer-price'></label>&nbsp;<span><%= manufacturerPrice %></span>
	        </div>
	      <% } %>
	      <div class="epages-shop-product-price">
	        <%= price %>
	      </div>
	      <% if(basePrice) { %>
	        <div class="epages-shop-product-base-price">(<%= basePrice %>)</div>
	      <% } %>
	    </div>
    </a>
  """

  render: ->
    @$el.html @template
      image: @model.largeImage()
      name:  @model.name()
      price: @model.formattedPrice()
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
