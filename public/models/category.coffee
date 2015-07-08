class Category extends Backbone.Model
  id: ->
    @attributes.categoryId

  name: ->
    @attributes.name

  subCategories: ->
    _.map @attributes.subCategories, (attributes) ->
      new SubCategory(attributes)
