class Modal

  constructor: ->
    @commands = new Commands()
    @commands.subscribe "closeModal", @close

  open: (view) ->
    @_modal = picoModal
      content: view.el
      modalStyles:
        "background-color": "white"
        "max-height": "80%"
        "max-width": "1000px"
        "min-width": "500px"
        "overflow": "auto"
        "padding": "20px"
        "width": "95%"
    @_modal.show()

  close: =>
    @_modal?.close()

  closeAll: ->
    @close()
    @commands.send "closeModal"
