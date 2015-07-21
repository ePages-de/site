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

  @modal: (view) ->
    @_modal = picoModal
      content: view.el
      modalStyles:
        "min-width": "500px"
        "max-width": "1000px"
        "width": "95%"
        "background-color": "white"
        "padding": "20px"
    @_modal.show()

  @closeModal: ->
    @_modal?.close()

  @start: ->
    scriptTag = $(@selectors.scriptTag)
    shopId = scriptTag.data("shopid")

    scriptTag.after new StylesView().render().el
    scriptTag.after new LoadingView().render().el

    App.cart = new Cart(null, shopId: shopId)

    # Widgets
    $(@selectors.shopWidget).each ->
      widgetView = new WidgetView(el: this).render()

      # Products
      products = new Products(
        null,
        shopId: shopId,
        categoryId: widgetView.categoryId
        productIds: widgetView.productIds
      )
      products.fetch(reset: true)

      # Products view
      productsView = new ProductListView(collection: products)
      widgetView.regions.productList.html(productsView.el)

      # Categories
      if widgetView.showCategoryList
        categories = new Categories(null, shopId: shopId)
        categories.fetch(reset: true)

        # Categories view
        categoriesView = new CategoryListView(collection: categories)
        widgetView.regions.categoryList.append(categoriesView.el)

        # Categories view events
        categoriesView.on "change:category", (categoryId) ->
          products.categoryId = categoryId
          products.fetch(reset: true)

      # Search form
      if widgetView.showSearchForm
        searchFormView = new SearchFormView
        widgetView.regions.searchForm.append(searchFormView.render().el)

        searchFormView.on "change:query", (query) ->
          products.query = query
          products.fetch(reset: true)

      # Sorting
      if widgetView.showSort
        sortView = new SortView
        widgetView.regions.sort.append(sortView.render().el)

        sortView.on "change", () ->
          products.sort = @sort
          products.direction = @direction
          console.log "app.coffee", @sort, @direction
          products.fetch(reset: true)

    # Cart views
    $(@selectors.cartWidget).each ->
      new CartView(el: $(this), model: App.cart).render()
