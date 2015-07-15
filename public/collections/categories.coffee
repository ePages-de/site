class Categories extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId } = options

  model: Category

  url: ->
    "#{App.rootUrl}/shops/#{@shopId}/categories"
