class Product extends Backbone.Model

  name: ->
    @get("name")

  price: ->
    @get("priceInfo").price.formatted

  smallImage: ->
    _.findWhere(@get("images"), classifier: "Small").url

  mediumImage: ->
    _.findWhere(@get("images"), classifier: "Medium").url

  largeImage: ->
    _.findWhere(@get("images"), classifier: "Large").url

  link: ->
    _.findWhere(@get("links"), rel: "self").href
