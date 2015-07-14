class Categories extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId } = options

  model: Category

  url: ->
    "https://developer.epages.com/api/shops/#{@shopId}/categories"
