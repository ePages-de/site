class CategoryListView extends Backbone.View
  render: ->
    html = @collection.map (category) ->
      view = new CategoryListItemView(model: category)
      view.render()

    html.join("")
