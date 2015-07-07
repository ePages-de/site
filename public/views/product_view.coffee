class ProductView extends Backbone.View

  events:
    "click .epages-shop-product-link": "openProductDetails"

  template: _.template """
    <div class="epages-shop-product">
      <a href="<%= link %>" class="epages-shop-product-link"><img src="<%= image %>"/></a>
      <div class="epages-shop-product-name"><%= name %></div>
      <div class="epages-shop-product-price" style="font-weight: bold">
        <%= price %>
      </div>
    </div>
  """

  render: ->
    @$el.html @template
      image: @model.image()
      name:  @model.name()
      price: @model.price()
      link:  @model.link()

    this

  openProductDetails: (event) ->
    event.preventDefault()
    picoModal("Here goes the modal.").show()