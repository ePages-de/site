class App

  @className: ".epages-shop-widget"

  @loadProducts: (options) ->
    { categoryId, event, widget } = options

    widget = @_findWidget(event) if event

    products = new Products(null, shopId: widget.shopId(), categoryId: categoryId)
    products.fetch
      success: ->
        view = new ProductListView(collection: products)
        view.render()
        widget.regions.productList.html(view.el)

  @loadCategoryList: (options) ->
    { widget } = options

    categories = new Categories(null, shopId: widget.shopId())
    categories.fetch
      success: ->
        view = new CategoryListView(collection: categories)
        view.render()
        widget.regions.categoryList.append(view.el)

  @_findWidget: (event) ->
    $(event.target).parents(App.className).data("widget")
