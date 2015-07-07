class WidgetView extends Backbone.View
  init: ->
    @_grabShopId()

  regions:
    loading: ".esw-loading"
    content: ".esw-content"
    categoryList: ".esw-category-list"

  template: _.template """
    <ul class="esw-category-list"></ul>
    <div class="esw-loading">Loading ...</div>
    <div class="esw-content"></div>
  """

  render: ->
    @$el.html @template()
    @_initRegions()

  loadProducts: ->
    products = new Products(null, shopId: @shopId)
    products.fetch
      success: =>
        @regions.loading.hide()

        view = new ProductListView
          el: @regions.content
          collection: products
        view.render()

  loadCategoryList: ->
    categories = new Categories(null, shopId: @shopId)
    categories.fetch
      success: =>
        view = new CategoryListView
          el: @regions.categoryList
          collection: categories
        view.render()

  _grabShopId: ->
    @shopId = @$el.attr("data-shopid")

    if !@shopId or !@shopId.length
      @render "Widget container is missing a data-shopid attribute."

  _initRegions: ->
    for name, className of @regions
      @regions[name] = @$(className)
