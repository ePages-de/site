class ProductView extends Backbone.View
  className: "epages-shop-product"

  events:
    "click .epages-shop-product-link": "openProductDetails"

  template: _.template """
    <a href="<%= link %>" class="epages-shop-product-link">
      <img src="<%= image %>"/>
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
      price: @model.price()
      link:  @model.link()

    this

  openProductDetails: (event) ->
    event.preventDefault()

    productDetailView = new ProductDetailView(model: @model)
    @model.loadVariations()
    productDetailView.render()

    modal = picoModal(
      content: productDetailView.el
      modalStyles:
        "min-width": "500px"
        "max-width": "1000px"
        "width": "95%"
        "background-color": "white"
        "padding": "20px"
    )
    modal.show()
