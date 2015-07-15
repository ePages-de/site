class VariationAttributeListView extends Backbone.View

  render: ->
    html = @collection.map (variation) ->
      view = new VariationAttributeView(model: variation)
      view.render().el

    # TODO: Ist das okay? Wie könnte man sonst Table-Rows einschieben?
    @$el.find("tr:last-of-type").before html
    this
