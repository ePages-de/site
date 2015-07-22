class App

  @env: "<%= env %>"

  @rootUrl:
    switch @env
      when "production" then "https://site-prototype.herokuapp.com"
      else                   "http://localhost:4566"

  @apiUrl:
    switch @env
      when "production" then "https://pm.epages.com/rs"
      when "test"       then "http://localhost:4041/rs"
      else                   "http://localhost:4040/rs"

  @selectors:
    scriptTag:  "#epages-widget"
    shopWidget: ".epages-shop-widget"
    cartWidget: ".epages-cart-widget"


  @start: ->
    @modal = new Modal()

    scriptTag = $(@selectors.scriptTag)
    shopId = scriptTag.data("shopid")

    scriptTag.after new StylesView().render().el
    scriptTag.after new LoadingView().render().el

    App.cart = new Cart(null, shopId: shopId)

    # Initialize: widgets
    $(@selectors.shopWidget).each (index, el) =>
      widgetView = new WidgetView(el: el).render()

      products = @_setupProductList(widgetView, shopId)

      # Option: Categories
      if widgetView.showCategoryList
        @_setupCategoryList(widgetView, products, shopId)

      # Option: Search
      if widgetView.showSearchForm
        @_setupSearchForm(widgetView, products)

      # Option: Sorting
      if widgetView.showSort
        @_setupSortView(widgetView, products)

    # Initialize: carts
    $(@selectors.cartWidget).each ->
      new CartView(el: $(this), model: App.cart).render()


  @_setupProductList: (widgetView, shopId) ->
    products = new Products(
      null,
      shopId: shopId,
      staticCategoryId: widgetView.staticCategoryId
      productIds: widgetView.productIds
    )
    products.fetch(reset: true)

    # Products view
    productsView = new ProductListView(collection: products)
    widgetView.regions.productList.html(productsView.el)
    products

  @_setupCategoryList: (widgetView, products, shopId) ->
    categories = new Categories(null, shopId: shopId)
    categories.fetch(reset: true)

    # Categories view
    categoriesView = new CategoryListView(collection: categories)
    widgetView.regions.categoryList.append(categoriesView.el)

    products.on "sync", ->
      categoriesView.reset() if products.query

    # Categories view events
    categoriesView.on "change:category", (selectedCategoryId) ->
      products.selectedCategoryId = selectedCategoryId
      products.query = null # category selection resets search query
      products.fetch(reset: true)

  @_setupSearchForm: (widgetView, products) ->
    searchFormView = new SearchFormView
    widgetView.regions.searchForm.append(searchFormView.render().el)

    products.on "sync", ->
      searchFormView.reset() if products.selectedCategoryId

    searchFormView.on "change:query", (query) ->
      products.query = query
      products.selectedCategoryId = null # search query resets category selection
      products.fetch(reset: true)

  @_setupSortView: (widgetView, products) ->
    sortView = new SortView
    widgetView.regions.sort.append(sortView.render().el)

    sortView.on "change", () ->
      products.sort = @sort
      products.direction = @direction
      products.fetch(reset: true)
