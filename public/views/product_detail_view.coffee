class ProductDetailView extends Backbone.View

  template: _.template """
    <div>
      Name: <%= name %><br/>
      Description: <%= description %><br/>
      availabilityText: <%= availabilityText %>
      price: <%= price %>
      <br/>
      <img src="<%= image %>" />
      <a href="http://pm.epages.com/epages/<%= shopId %>/de_DE/?ObjectPath=Categories/Shipping">Versandinformation</a>
    </div>

  """

  render: ->
    @$el.html @template
      name: @model.name()
      image: @model.mediumImage()
      description: @model.get("description")
      availabilityText: @model.get("availabilityText")
      price: @model.price()
      shopId: "TODO" # TODO

    this
