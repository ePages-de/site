class CategoryListItemView extends Backbone.View
  tagName: "option"

  attributes: ->
  	value: @model.id()

  template: _.template """
    <%= name %>
  """

  render: ->
    @$el.html @template(name: @model.name())
    this
