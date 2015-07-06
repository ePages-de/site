class CategoryListItemView extends Backbone.View
  template: _.template """
    <li><%= name %></li>
  """

  render: ->
    @template(name: @model.name())
