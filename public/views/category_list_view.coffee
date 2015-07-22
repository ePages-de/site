class CategoryListView extends Backbone.View

  initialize: ->
    @listenTo @collection, "reset", @render

  tagName: "select"

  events:
    "change": "onSelectionChange"

  render: ->
    return this if @collection.isEmpty()

    html = @collection.at(0).subCategories().map (category) ->
      view = new CategoryListItemView(model: category)
      view.render().el

    allProducts = new SubCategory(title: "All products")
    allView = new CategoryListItemView(model: allProducts)
    allView.render()

    html.unshift(allView.el)

    @$el.html html
    this

  reset: ->
    @$el.find("option:first").attr("selected", true)

  onSelectionChange: (event) ->
    @trigger "change:category", event.target.value
