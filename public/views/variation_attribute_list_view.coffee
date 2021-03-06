class VariationAttributeListView extends Backbone.View

  render: ->
    html = @collection.map (variation) ->
      view = new VariationAttributeView(model: variation)
      view.render().el

    @$el.html html
    this
