class App

  @className: ".epages-shop-widget"

  @loadProducts: (options) ->
    { categoryId, event, widget } = options

    widget = @_findWidget(event) if event

    products = new Products(null, shopId: widget.shopId, categoryId: categoryId)
    products.fetch
      success: =>
        widget.regions.loading.hide()

        view = new ProductListView
          el: widget.regions.productList
          collection: products
        view.render()

  @loadCategoryList: (options) ->
    { widget } = options

    categories = new Categories(null, shopId: widget.shopId)
    categories.fetch
      success: =>
        view = new CategoryListView
          el: widget.regions.categoryList
          collection: categories
        view.render()

  @_findWidget: (event) ->
    $(event.target).parents(App.className).data("widget")
