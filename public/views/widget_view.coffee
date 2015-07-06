class WidgetView extends Backbone.View
  init: ->
    @_grabShopId()

  regions:
    loading: "esw-loading"
    content: "esw-content"
    categoryList: "esw-category-list"

  template: _.template """
    <div class="esw-category-list"></div>
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

        html = products.map (product) ->
          view = new ProductView(model: product)
          view.render()

        @regions.content.html html.join("")

  loadCategoryList: ->
    categories = new Categories(null, shopId: @shopId)
    categories.fetch
      success: =>
        view = new CategoryListView(collection: categories)
        @regions.categoryList.html view.render()

  _grabShopId: ->
    @shopId = @$el.attr("data-shopid")

    if !@shopId or !@shopId.length
      @render "Widget container is missing a data-shopid attribute."

  _initRegions: ->
    for name, className of @regions
      @regions[name] = @$(".#{className}")
