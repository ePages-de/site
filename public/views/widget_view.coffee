class WidgetView extends Backbone.View

  initialize: ->
    @_grabOptions()

  template: _.template """
    <div class="epages-shop-cart"></div>
    <div class="epages-shop-navigation">
      <div class="epages-shop-category-list"></div>
      <div class="epages-shop-sort"></div>
      <div class="epages-shop-search-form"></div>
      <div class="epages-shop-cart"></div>
    </div>

    <div class="epages-shop-product-list">Loading ...</div>

    <style type="text/css">
      .epages-shop-navigation {
        margin-bottom: 50px;
      }
      .epages-shop-navigation {
        clear: both;
      }
      .epages-shop-navigation > div {
        float: left;
        margin-right: 1em;
      }
      .epages-shop-product-list {
        clear: both;
      }
      .epages-shop-cart {
        float: right;
        margin-right: 0;
      }
      .epages-cart-button {
        background: url(#{App.rootUrl}/images/cart.png) left center no-repeat;
        padding-left: 25px;
        padding-right: 2px;
        cursor: pointer;
        border: 0;
        outline: none;
      }
    </style>
  """

  render: ->
    @$el.html @template()
    @_initRegions()
    this

  _grabOptions: ->
    @showCategoryList = @$el.data("category-list") != undefined
    @showSearchForm   = _.contains [undefined, true], @$el.data("search-form")
    @showSort         = _.contains [undefined, true], @$el.data("sort")
    @staticCategoryId = @$el.data("category-id")
    @productIds       = @$el.data("product-ids")?.split(/, */)

  _initRegions: ->
    @regions =
      productList:  @$(".epages-shop-product-list")
      categoryList: @$(".epages-shop-category-list")
      searchForm:   @$(".epages-shop-search-form")
      sort:         @$(".epages-shop-sort")
      cart:         @$(".epages-shop-cart")
