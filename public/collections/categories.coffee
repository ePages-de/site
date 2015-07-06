class Categories extends Backbone.Collection
  initialize: (models, options) ->
    { @shopId } = options

  model: Category

  url: ->
    "http://crossorigin.me/https://developer.epages.com/api/shops/#{@shopId}/categories"
