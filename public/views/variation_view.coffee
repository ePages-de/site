class VariationView extends Backbone.View
  className: "epages-shop-variation"

  #events:

  template: _.template """
    <label for="epages-shop-variation-<%= name %>"><%= displayName %></label>
    <select name="epage-shop-variation-<%= name %>">
    </select>
  """

  optionTemplate: _.template """
      <option value="<%= value %>"><%= displayValue %></option>
  """

  render: ->
    @$el.html @template
      name: @model.name()
      displayName: @model.displayName()
    @$el.find("select").html @model.get("values").map (option) =>
      @optionTemplate
        value: option.value
        displayValue: option.displayValue
    this
