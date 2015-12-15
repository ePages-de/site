class ProductListView extends Backbone.View

  initialize: ->
    @listenTo @collection, "reset", @render

  className: "row"

  render: ->
    if @collection.length == 0
      html = '<div class="alert alert-danger"><strong data-i18n="no-products">No products found</strong></div>'
    else
      html = @collection.map (product) ->
        view = new ProductView(model: product)
        view.render().el

    @$el.html html
    App.i18n(this)
    this
