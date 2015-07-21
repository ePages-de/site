class WidgetView extends Backbone.View

  initialize: ->
    @_defineRegions()
    @_grabOptions()

  template: _.template """
    <div class="epages-shop-category-list"></div>
    <div class="epages-shop-search-form"></div>
    <div class="epages-shop-product-list">Loading ...</div>

    <style type="text/css">
      .epages-shop-category-list {
        float: left;
        margin-right: 1em;
      }
      .epages-shop-product-list {
        clear: both;
      }
    </style>
  """

  render: ->
    @$el.html @template()
    @_initRegions()
    this

  _grabOptions: ->
    @showCategoryList = @$el.data("category-list") != undefined
    @showSearchForm = _.contains [undefined, true], @$el.data("search-form")
    @categoryId = @$el.data("category-id")
    @productIds = @$el.data("product-ids")?.split(/, */)

  _defineRegions: ->
    @regions =
      productList: ".epages-shop-product-list"
      categoryList: ".epages-shop-category-list"
      searchForm: ".epages-shop-search-form"

  _initRegions: ->
    for name, className of @regions
      @regions[name] = @$(className)
