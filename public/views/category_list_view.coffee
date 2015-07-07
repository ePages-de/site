class CategoryListView extends Backbone.View
  tagName: "ul"

  render: ->
    html = @collection.map (category) ->
      view = new CategoryListItemView(model: category)
      view.render().el

    @$el.html html
    this
