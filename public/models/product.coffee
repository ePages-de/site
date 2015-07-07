class Product extends Backbone.Model

  name: ->
    @get("name")

  price: ->
    @get("priceInfo").price.formatted

  image: ->
    _.findWhere(@get("images"), classifier: "Small").url

  link: ->
    _.findWhere(@get("links"), rel: "self").href
