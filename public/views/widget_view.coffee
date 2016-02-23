class WidgetView extends Backbone.View

  initialize: ->
    @_grabOptions()

  template: _.template """
  <div class="row">
  <div class="epages-shop-search-form col-xs-2 col-sm-6 col-md-4 col-lg-2"></div>
  <div class="epages-shop-cart col-xs-10 col-sm-6 col-md-8 col-lg-10"></div>
  </div>
  <div class="row epages-shop-navigation">
  <div class="epages-shop-sort col-xs"></div>
  <div class="epages-shop-category-list col-xs"></div>
  </div>
  <div class="epages-shop-product-list row" data-i18n='loading'></div>
  <div class="epages-shop-pagination col-xs"></div>

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
