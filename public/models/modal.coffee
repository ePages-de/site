class Modal

  constructor: ->
    @commands = new Commands()
    @commands.subscribe "closeModal", @close

  open: (view) ->
    @_modal = picoModal
      content: view.el
      modalStyles:
        "background-color": "white"
        "position": "fixed"
        "left": "50%"
        "top": "10%"
        "max-height": "80%"
        "max-width": "1000px"
        "min-width": "200px"
        "overflow": "auto"
        "width": "100%"

    @_modal.show()

  close: =>
    @_modal?.close()

  closeAll: ->
    @close()
    @commands.send "closeModal"
