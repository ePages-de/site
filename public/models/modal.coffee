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

  removePicos: ->
    if $('.epages-cart-overlay').length > 0
      localStorage.setItem('epages-shop-quantity-change', 0)
    if $('.pico-overlay').length > 0
      _.map $('.pico-overlay'), (pico) -> pico.parentNode.removeChild pico
    if $('.pico-content').length > 0
      _.map $('.pico-content'), (pico) -> pico.parentNode.removeChild pico
