class WidgetView extends Backbone.View

  initialize: ->
    @_defineRegions()

  template: _.template """
    <select class="epages-shop-category-list"></select>
    <div class="epages-shop-product-list">Loading ...</div>
  """

  render: ->
    @$el.html @template()
    @_initRegions()

  shopId: ->
    @$el.data("shopid")

  _defineRegions: ->
    @regions =
      productList: ".epages-shop-product-list"
      categoryList: ".epages-shop-category-list"

  _initRegions: ->
    for name, className of @regions
      @regions[name] = @$(className)
