class App

  @className: ".epages-shop-widget"

  @loadProducts: (options) ->
    { widget, categoryId } = options

    products = new Products(null, widget: widget, categoryId: categoryId)
    products.fetch
      success: ->
        view = new ProductListView(collection: products)
        view.render()
        widget.regions.productList.html(view.el)

  @loadCategoryList: (options) ->
    { widget } = options

    categories = new Categories(null, widget: widget)
    categories.fetch
      success: ->
        view = new CategoryListView(collection: categories)
        view.render()
        widget.regions.categoryList.append(view.el)
