class LoadingView extends Backbone.View

  id: "epages-shop-widget-loading"

  render: ->
    clickButton = ->
      _isACloseButton = ->
        if event.target.className == " pico-close fa fa-2x fa-times-circle undefined" or event.target.className == " pico-overlay "
          App.modal.removePicos()

      document.addEventListener 'click', _isACloseButton

    clickButton()
    $(document).on "ajaxStart", => @$el.show()
    $(document).on "ajaxStop",  => @$el.hide()
    this
