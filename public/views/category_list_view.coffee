class CategoryListView extends Backbone.View
  tagName: "ul"

  render: ->
    html = @collection.map (category) ->
      view = new CategoryListItemView(model: category)
      view.render()
      view.$el.prop("outerHTML")

    @$el.html html.join("")
    this
