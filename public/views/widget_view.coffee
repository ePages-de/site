class WidgetView extends Backbone.View

  initialize: ->
    @_grabOptions()

  template: _.template """
  <div class="row-fluid col-xs-12 col-md-12 col-lg-12">
  <div class="epages-shop-cart"></div>
  </div>
  <div class="row">
  <div class="epages-shop-navigation">
  <div class="epages-shop-search-form col-xs-6 col-md-3 col-lg-3"></div>
  <div class="epages-shop-sort col-xs-6 col-md-3 col-lg-3"></div>
  <div class="epages-shop-category-list col-xs-6 col-md-3 col-lg-3"></div>
  </div>
  </div>
  <div class="epages-shop-product-list" data-i18n='loading'></div>
  <div class="epages-shop-pagination"></div>

"""


  render: ->
    @$el.html @template()
    @_initRegions()
    App.i18n(this)
    this

  _grabOptions: ->
    @showCategoryList = _.contains [true], @$el.data("category-list")
    @showSearchForm   = _.contains [undefined, true], @$el.data("search-form")
    @showSort         = _.contains [undefined, true], @$el.data("sort")
    @resultsPerPage   = @$el.data("products-per-page") || 12
    @staticCategoryId = @$el.data("category-id")
    @productIds       = @$el.data("product-ids")?.split(/, */)

  _initRegions: ->
    @regions =
      productList:  @$(".epages-shop-product-list")
      categoryList: @$(".epages-shop-category-list")
      searchForm:   @$(".epages-shop-search-form")
      sort:         @$(".epages-shop-sort")
      pagination:   @$(".epages-shop-pagination")
      cart:         @_findCart()

  _findCart: ->
    external_cart = $(":not(.epages-shop-widget) > .epages-shop-cart").first()
    internal_cart = @$(".epages-shop-cart")
    if external_cart.length > 0 then external_cart else internal_cart
