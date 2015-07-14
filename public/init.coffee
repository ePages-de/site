$.ajaxSettings.accepts.json = null # required to work with the epages API

# TODO: Add a fallback in case <head> cannot be found.
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
