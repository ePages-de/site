class VariationAttributeView extends Backbone.View
  className: "epages-shop-variation"

  events:
    "change": "onChange"

  template: _.template """
    <label for="epages-shop-variation-<%= name %>"><%= displayName %></label>
    <select name="epage-shop-variation-<%= name %>">
    </select>
  """

  optionTemplate: _.template """
    <option
      value="<%= value %>"
      <%= selected === value ? "selected=selected" : null %>>
      <%= displayValue %>
    </option>
  """

  onChange: (event) ->
    @model.set("selected", event.target.value)

  render: ->
    @$el.html @template
      name: @model.get("name")
      displayName: @model.get("displayName")
    @$el.find("select").html(@model.get("values").map((option) =>
      @optionTemplate
        value: option.value
        selected: @model.get("selected")
        displayValue: option.displayValue).join(""))
    @$el.find("select").prepend(
      @optionTemplate
        value: null
        displayValue: "Choose"
        selected: @model.get("selected"))
    this
