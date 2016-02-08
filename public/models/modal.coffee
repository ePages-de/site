class Modal

  constructor: ->
    @commands = new Commands()
    @commands.subscribe "closeModal", @close

  open: (view) ->
    @_modal = picoModal
      content: view.el
      modalStyles:
        "background-color": "white"
        "max-height": "100%"
        "max-width": "1000px"
        "min-width": "200px"
        "overflow": "scroll"
        "padding": "20px"
        "width": "95%"
    @_modal.show()

  close: =>
    @_modal?.close()

  closeAll: ->
    @close()
    @commands.send "closeModal"
