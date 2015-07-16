class App

  @rootUrl: "https://developer.epages.com/api"

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

  @_initLoadingIndicator: ->
    $loading = $("<div id=epages-shop-widget-loading></div>")
    $("body").prepend($loading)
    $(document).on "ajaxStart", ->
      $loading.show()
    $(document).on "ajaxStop", ->
      $loading.hide()

  @start: ->
    shopId = $(@selectors.scriptTag).data("shopid")

    App.cart = new Cart(null, shopId: shopId)

    @_initLoadingIndicator()

    # Widgets
    $(@selectors.shopWidget).each ->
      widgetView = new WidgetView(el: $(this)).render()

      # Products
      products = new Products(null, shopId: shopId)
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

    # Cart views
    $(@selectors.cartWidget).each ->
      cartView = new CartView(el: $(this), model: App.cart).render()
