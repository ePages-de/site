$.ajaxSettings.accepts.json = null # required to work with the epages API

# TODO: Add a fallback in case <head> cannot be found.
style = """
  <style type="text/css" id="epages-shop-styles">
    #epages-shop-widget-loading {
      background-image: url(#{App.rootUrl}/images/spinner.gif);
      background-color: white;
      border-radius: 6px;
      display: none;
      height: 32px;
      left: 50%;
      position: fixed;
      top: 50px;
      width: 32px;
      z-index: 10002;
    }
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
