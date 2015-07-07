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
  _.each document.getElementsByClassName(App.className), (el) ->
    widget = new WidgetView(el: el)
    widget.init()
    widget.render()
    widget.loadProducts()
    widget.loadCategoryList()


setup()
insertStyles()
initializeWidgets()
