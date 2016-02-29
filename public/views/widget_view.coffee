class WidgetView extends Backbone.View

  initialize: ->
    @_grabOptions()

  template: _.template """
  <div class="epages-row">
  <div class="epages-shop-search-form epages-col-xs-4 epages-col-sm-4 epages-col-md-3 epages-col-lg-3"></div>
  <div class="epages-shop-cart epages-col-xs-8 epages-col-sm-8 epages-col-md-9 epages-col-lg-9"></div>
  </div>
  <div class="epages-row epages-shop-navigation">
  <div class="epages-shop-sort epages-col-xs-4 epages-col-sm-3 epages-col-md-3 epages-col-lg-3"></div>
  <div class="epages-shop-category-list epages-col-xs-4 epages-col-sm-3 epages-col-md-3 epages-col-lg-3"></div>
  </div>
  <div class="epages-shop-product-list epages-row" data-i18n='loading'></div>

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
