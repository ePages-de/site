class ProductDetailView extends Backbone.View

  events:
    "change select": "updateVariations"

  updateVariations: =>
    matchingVariationItem = _.find @model.attributes.variationItems.models, (item) =>
      _.all item.attributes.attributeSelection, (selection) =>
        _.some @model.attributes.variationAttributes.models, (attribute) ->
          attribute.get("name") == selection.name &&
          attribute.get("selected") == selection.value

    if matchingVariationItem
      p = new Product(url: matchingVariationItem.get("link").href)
      p.fetch(
        success: (newModel) =>
          newModel.set("variationItems", @model.attributes.variationItems)
          newModel.set("variationAttributes", @model.attributes.variationAttributes)
          @model = newModel
          @render())

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
    oldVariations = @$el.find("#variations")

    @$el.html @template
      name: @model.name()
      id: @model.id()
      image: @model.mediumImage()
      description: @model.get("description")
      availability: @model.get("availability")
      availabilityText: @model.get("availabilityText")
      price: @model.price()
      shopId: "TODO" # TODO

    if @variationsLoaded == true
      @$el.find("#variations").html(oldVariations)
    else
      @model.loadVariations()
        .done =>
          @$el.find("#variations").
            html(new VariationAttributeListView( \
              collection: @model.get("variationAttributes")).render().el)
        .fail =>
          @$el.find("#variations").html "No variations found"
        .always =>
          @variationsLoaded = true
    this
