setup = ->
  $.ajaxSettings.accepts.json = null # required to work with the epages API

insertStyles = ->
  style = """
    <style type="text/css" id="epages-shop-styles">
      .epages-shop-widget  {
        overflow: auto;
      }
      .epages-shop-widget .epages-shop-product {
        float: left;
        width: 100px;
        margin: 10px;
        height: 200px;
      }
    </style>
  """
  head = document.getElementsByTagName("head")[0]
  head.insertAdjacentHTML("afterbegin", style)

initializeWidgets = ->
  $(App.className).each ->
    widget = new WidgetView(el: this)
    widget.render()

    widget.$el.data("widget", widget)

    if widget.showCategoryList()
      App.loadCategoryList(widget: widget)

    App.loadProducts(widget: widget)


setup()
insertStyles()
initializeWidgets()
