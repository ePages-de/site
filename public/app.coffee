class Products
  @url: (shopId) ->
    "https://site-cors-api-proxy.herokuapp.com/https://developer.epages.com/api/shops/#{shopId}/products"

  @all: (shopId, fn) ->
    reqwest @url(shopId), (response) ->
      fn _.map response.items, (item) ->
        new Product(item)


class Product
  constructor: (attributes) ->
    @attributes = attributes

  template: _.template """
    <div class="product">
      <img src="<%= image %>"/>
      <div class="product-name"><%= name %></div>
      <div class="product-price"><%= price %></div>
    </div>
  """

  render: ->
    @template
      image: _.findWhere(@attributes.images, classifier: "Small").url
      name:  @attributes.name
      price: @attributes.priceInfo.price.formatted


class Widget
  @className: "eps-site-widget"

  @all: ->
    _.map document.getElementsByClassName(@className), (el) ->
      new Widget
        el: el

  constructor: (options = {}) ->
    @$el = options.el

  grabShopId: ->
    @shopId = @$el.getAttribute("data-shopid")

    if !@shopId or !@shopId.length
      @render "Widget container is missing a data-shopid attribute."

  render: (html) ->
    @$el.innerHTML = html


initializeWidget = (widget) ->
  widget.render "Loading ..."

  Products.all widget.shopId, (products) ->
    html = _.map products, (product) ->
      product.render()

    widget.render html.join("")


initializeWidgets = ->
  _.each Widget.all(), (widget) ->
    widget.grabShopId()
    initializeWidget(widget)


initializeWidgets()