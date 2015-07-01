urls =
  products: (shopId) -> "https://site-cors-api-proxy.herokuapp.com/https://developer.epages.com/api/shops/#{shopId}/products"

templates =
  product: _.template """
    <div class="product">
      <img src="<%= image %>"/>
      <div class="product-name"><%= name %></div>
      <div class="product-price"><%= price %></div>
    </div>
  """

initializeWidget = (container, shopId) ->
  container.innerHTML = "Loading ..."

  reqwest urls.products(shopId), (response) ->
    html = _.map response.items, (product) ->
      templates.product
        image: _.findWhere(product.images, classifier: "Small").url
        name:  product.name
        price: product.priceInfo.price.formatted

    container.innerHTML = html.join("")

initializeWidgets = ->
_.each document.getElementsByClassName("eps-site-widget"), (container) ->
  shopId = container.getAttribute("data-shopid")

  if !shopId or !shopId.length
    container.innerHTML = "Widget container is missing a data-shopid attribute."

  initializeWidget(container, shopId)


initializeWidgets()