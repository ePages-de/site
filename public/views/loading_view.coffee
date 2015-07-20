class LoadingView extends Backbone.View

  id: "epages-shop-widget-loading"

  render: ->
    $(document).on "ajaxStart", => @$el.show()
    $(document).on "ajaxStop",  => @$el.hide()
    this
