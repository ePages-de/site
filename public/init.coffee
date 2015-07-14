$.ajaxSettings.accepts.json = null # required to work with the epages API

# TODO: move this out into a CSS file and add a fallback
#       in case the <head> cannot be found.
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

App.start()
