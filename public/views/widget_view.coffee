class WidgetView extends Backbone.View
  init: ->
    @$el.data("widget", this)
    @_grabShopId()

  initialize: ->
    @_defineRegions()

  template: _.template """
    <select class="epages-shop-category-list"></select>
    <div class="epages-shop-loading">Loading ...</div>
    <div class="epages-shop-product-list"></div>
  """

  render: ->
    @$el.html @template()
    @_initRegions()

  _grabShopId: ->
    @shopId = @$el.attr("data-shopid")

    if !@shopId or !@shopId.length
      @render "Widget container is missing a data-shopid attribute."
  _defineRegions: ->
    @regions =
      productList: ".epages-shop-product-list"
      categoryList: ".epages-shop-category-list"

  _initRegions: ->
    for name, className of @regions
      @regions[name] = @$(className)
