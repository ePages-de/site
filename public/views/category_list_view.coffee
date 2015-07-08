class CategoryListView extends Backbone.View
  tagName: "select"

  events:
    "change": "onSelectionChange"

  render: ->
    html = @collection.at(0).subCategories().map (category) ->
      view = new CategoryListItemView(model: category)
      view.render().el

    allProducts = new SubCategory(title: "All products")
    allView = new CategoryListItemView(model: allProducts)
    allView.render()

    html.unshift(allView.el)

    @$el.html html
    this

  onSelectionChange: (event) ->
    App.loadProducts
      categoryId: event.target.value
      event: event
