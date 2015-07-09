class Categories extends Backbone.Collection

  initialize: (models, options) ->
    { @widget } = options

  model: Category

  url: ->
    "https://developer.epages.com/api/shops/#{@widget.shopId}/categories"
