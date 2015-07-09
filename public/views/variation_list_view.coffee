class VariationListView extends Backbone.View

  render: ->
    html = @collection.map (variation) ->
      view = new VariationView(model: variation)
      view.render().el

    @$el.html html
    this
