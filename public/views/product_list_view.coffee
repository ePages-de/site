class ProductListView extends Backbone.View
  tagName: "ul"

  render: ->
    html = @collection.map (product) ->
      view = new ProductView(model: product)
      view.render().el

    @$el.html html
    this
