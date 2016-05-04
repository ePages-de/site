class Modal

  constructor: ->
    @commands = new Commands()
    @commands.subscribe "closeModal", @close

  open: (view) ->
    @_modal = picoModal
      content: view.el
      
    @_modal.show()

  close: =>
    @_modal?.close()

  closeAll: ->
    @close()
    @commands.send "closeModal"
