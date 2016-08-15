class App

  @env: "<%= env %>"

  @rootUrl:
    switch @env
      when "production" then "https://site-production.herokuapp.com"
      else                   "http://localhost:4566"

  @apiUrl:
    switch @env
      when "production" then "https://pm.epages.com/rs"
      when "test"       then "http://localhost:4041/rs"
      else                   "http://localhost:4040/rs"

  @selectors:
    scriptTag:  "#epages-widget"
    shopWidget: ".epages-shop-widget"

  @i18n: (view) ->
    for el in view.$el.find("[data-i18n]")
      $(el).html(App.translations[$(el).data("i18n")])
    for el in view.$el.find("[data-i18n-placeholder]")
      $(el).attr("placeholder", App.translations[$(el).data("i18n-placeholder")])

  @start: ->
    @modal = new Modal()

    scriptTag = $(@selectors.scriptTag)
    shopUrl = scriptTag.data("shop-url")

    matches = shopUrl.match(/(https?:\/\/.+\/rs)\/shops\/([\w() -]+)(\/?)/)
    shopId = matches[2]

    if @env is "production"
      @apiUrl = matches[1]

    # Setting default currency
    if $(@selectors.shopWidget).data('currency') == undefined
      $.ajax
        url: shopUrl.replace(/\/$/, "") + "/currencies",
        async: false,
        dataType: 'json',
        success: (response) => App.currency = response.default
    else
      App.currency = $(@selectors.shopWidget).data('currency')

    # Setting language
    App.lang = "en"
    $.ajax
      url: shopUrl.replace(/\/$/, "") + "/locales",
      async: false,
      dataType: 'json',
      success: (response) => App.lang = response.default.split('_')[0]

    App.translations = null
    $.ajax
      url: "https://site-production.herokuapp.com/locales/" + App.lang + ".json",
      crossDomain: true,
      beforeSend: (request) =>
        request.setRequestHeader("Access-Control-Allow-Origin", '*')
      async: false,
      dataType: 'json',
      success: (response) => App.translations = response
      error: () =>
        # support for wordpress plugin
        $.ajax
          url: "/wp-content/plugins/site-wordpress/assets/locales/" + App.lang + ".json",
          async: false,
          dataType: 'json',
          success: (response) =>
            App.translations = response

    scriptTag.after new LoadingView().render().el

    App.cart = new Cart(null, shopId: shopId)
    App.cart.loadFromStorage()

    # Initialize: widgets
    $(@selectors.shopWidget).each (index, el) =>
      widgetView = new WidgetView(el: el).render()

      # Cart button
      @_setupCartButton(widgetView)

      if widgetView.singleProduct
        @_setupSingleProduct(widgetView, shopId)
      else
        # Product list
        products = @_setupProductList(widgetView, shopId)

        # Pagination
        @_setupPagination(widgetView, products)

        # Taxes
        @_setupTaxes(widgetView, products)

        # Option: Categories
        if widgetView.showCategoryList
          @_setupCategoryList(widgetView, products, shopId)

        # Option: Search
        if widgetView.showSearchForm
          @_setupSearchForm(widgetView, products)

        # Option: Sorting
        if widgetView.showSort
          @_setupSortView(widgetView, products)

  @_setupCartButton: (widgetView) ->
    cartView = new CartView(collection: App.cart).render()
    widgetView.regions.cart.html(cartView.el)

  @_setupProductList: (widgetView, shopId) ->
    products = new Products(
      null,
      shopId: shopId,
      staticCategoryId: widgetView.staticCategoryId,
      productIds: widgetView.productIds,
      resultsPerPage: widgetView.resultsPerPage
    )
    products.fetch(reset: true)

    productsView = new ProductListView(collection: products)
    widgetView.regions.productList.html(productsView.el)
    products

  @_setupCategoryList: (widgetView, products, shopId) ->
    categories = new Categories(null, shopId: shopId)
    categories.fetch(reset: true)

    categoriesView = new CategoryListView(collection: categories).render()
    widgetView.regions.categoryList.append(categoriesView.el)

    products.on "sync", ->
      categoriesView.reset() if products.query

    categoriesView.on "change:category", (selectedCategoryId) ->
      products.selectedCategoryId = selectedCategoryId
      products.query = null # category selection resets search query
      products.fetch(reset: true)

  @_setupSearchForm: (widgetView, products) ->
    searchFormView = new SearchFormView().render()
    widgetView.regions.searchForm.append(searchFormView.el)

    products.on "sync", ->
      searchFormView.reset() if products.selectedCategoryId

    searchFormView.on "change:query", (query) ->
      products.query = query
      products.selectedCategoryId = null # search query resets category selection
      products.fetch(reset: true)

  @_setupSortView: (widgetView, products) ->
    sortView = new SortView().render()
    widgetView.regions.sort.append(sortView.el)

    sortView.on "change", () ->
      products.sort = @sort
      products.direction = @direction
      products.fetch(reset: true)

  @_setupPagination: (widgetView, products) ->
    products.fetch(reset: true).done ->
      paginationView = new PaginationView(collection: products).render()
      widgetView.regions.pagination.append(paginationView.el)

      paginationView.on "change:page", () ->
        products.page = @page
        products.fetch(reset: true)

  @_setupTaxes: (widgetView, products) ->
    taxesView = new TaxesView(collection: products).render()
    widgetView.regions.taxes.append(taxesView.el)

  @_setupSingleProduct: (widgetView, shopId) ->
    product = new Product(url: "#{App.apiUrl}/shops/#{shopId}/products/#{widgetView.singleProduct}")
    productView = new SingleProductView(model: product)
    widgetView.regions.productList.html(productView.el)
    product.fetch(reset: true)
