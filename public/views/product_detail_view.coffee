class ProductDetailView extends Backbone.View

  template: _.template """
    <div>
      <h2><%= name %></h2>
      <p><%= description %></p>
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
      image: @model.mediumImage()
      description: @model.get("description")
      availability: @model.get("availability")
      availabilityText: @model.get("availabilityText")
      price: @model.price()
      shopId: "TODO" # TODO

    @model.variations.fetch
      reset: true
      success: =>
        @$el.find("#variations").
          html(new VariationListView(collection: @model.variations).render().el)
      error: =>
        @$el.find("#variations").html "No variations found"

    this
