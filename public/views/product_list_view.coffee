class ProductListView extends Backbone.View

  initialize: ->
    @listenTo @collection, "reset", @render

  className: "row"

  render: ->
    html = @collection.map (product) ->
      view = new ProductView(model: product)
      view.render().el

    @$el.html html
    this
