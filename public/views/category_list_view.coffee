class CategoryListView extends Backbone.View

  initialize: ->
    @listenTo @collection, "reset", @render

  tagName: "label"

  events:
    "change select": "onSelectionChange"

  template: _.template """
  <div class="input-group">
  <span data-i18n='category'></span><select class="form-control" id="sel1"></div>
  """
  render: ->
    return this if @collection.isEmpty()

    html = @collection.at(0).subCategories().map (category) ->
      view = new CategoryListItemView(model: category)
      view.render().el

    allProducts = new SubCategory(title: "All products")
    allView = new CategoryListItemView(model: allProducts)
    allView.render()

    html.unshift(allView.el)

    @$el.html @template()
    @$("select").html html
    App.i18n(this)
    this

  reset: ->
    @$el.find("option:first").attr("selected", true)

  onSelectionChange: (event) ->
    @trigger "change:category", event.target.value
