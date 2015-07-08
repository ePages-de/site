class WidgetView extends Backbone.View
  init: ->
    @$el.data("widget", this)
    @_grabShopId()

  regions:
    loading: ".esw-loading"
    content: ".esw-content"
    categoryList: ".esw-category-list"

  template: _.template """
    <select class="esw-category-list"></select>
    <div class="esw-loading">Loading ...</div>
    <div class="esw-content"></div>
  """

  render: ->
    @$el.html @template()
    @_initRegions()

  _grabShopId: ->
    @shopId = @$el.attr("data-shopid")

    if !@shopId or !@shopId.length
      @render "Widget container is missing a data-shopid attribute."

  _initRegions: ->
    for name, className of @regions
      @regions[name] = @$(className)
