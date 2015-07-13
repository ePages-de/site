class ProductDetailView extends Backbone.View

  events:
    "change select": "updateVariations"

  initialize: =>
    @listenTo @model, "change", @render

  updateVariations: =>
    matchingVariationItem = @model.get("variationItems").find (item) =>
      _.all item.get("attributeSelection"), (selection) =>
        @model.get("variationAttributes").some (attribute) ->
          attribute.get("name") == selection.name &&
          attribute.get("selected") == selection.value

    if matchingVariationItem
      p = new Product(url: matchingVariationItem.get("link").href)
      p.fetch
        success: (newModel) =>
          @model.set(newModel.toJSON())
          @render()

  template: _.template """
    <div>
      <h2><%= name %></h2>
      <p><%= id %> <%= description %></p>
      availabilityText: <%= availabilityText %><br/>
      availability: <%= availability %><br/>
      price: <%= price %><br/>
      shopId: <%= shopId %><br/>
      variations: <div id="variations"></div>
      <br/>
      <img src="<%= image %>" />
      <a href="#TODO">
        Versandinformation
      </a>
    </div>

  """

  render: ->
    @$el.html @template
      name: @model.name()
      id: @model.id()
      image: @model.mediumImage()
      description: @model.get("description")
      availability: @model.get("availability")
      availabilityText: @model.get("availabilityText")
      price: @model.price()
      shopId: "TODO" # TODO

    @$el.find("#variations").html(
      new VariationAttributeListView(
        collection: @model.variationAttributes()
      ).render().el)

    this
