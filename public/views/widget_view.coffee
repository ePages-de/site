class WidgetView extends Backbone.View

  initialize: ->
    @_defineRegions()

  template: _.template """
    <div class="epages-shop-category-list"></div>
    <div class="epages-shop-product-list">Loading ...</div>
  """

  render: ->
    @$el.html @template()
    @_initRegions()

  shopId: ->
    @$el.data("shopid")

  showCategoryList: ->
    @$el.data("category-list") != undefined

  _defineRegions: ->
    @regions =
      productList: ".epages-shop-product-list"
      categoryList: ".epages-shop-category-list"

  _initRegions: ->
    for name, className of @regions
      @regions[name] = @$(className)
