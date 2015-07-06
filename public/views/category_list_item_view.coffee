class CategoryListItemView extends Backbone.View
  tagName: "li"

  template: _.template """
    <%= name %>
  """

  render: ->
    @$el.html @template(name: @model.name())
    this
