class Categories extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId } = options

  model: Category

  url: ->
    "#{App.apiUrl}/shops/#{@shopId}/categories"
