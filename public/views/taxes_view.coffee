class TaxesView extends Backbone.View

  initialize: ->
    @listenTo @collection, "reset", @render


  template: _.template """
    <span data-i18n="<% if (taxType == 'GROSS') { %>include-vat-prices<% } else { %>exclude-vat-prices<% } %>"></span>
    <a href="<%= shippingUrl %>" target="_blank" data-i18n="shipping"></a>
  """

  render: ->
    if typeof(@collection.models[0]) != "undefined"
      @$el.html @template
        taxType:      @collection.models[0].attributes.priceInfo.price.taxType
        shippingUrl:  @collection.shippingUrl
    App.i18n(this)
    this
