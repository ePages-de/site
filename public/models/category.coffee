class Category extends Backbone.Model
  id: ->
    @attributes.categoryId

  name: ->
    @attributes.name

  subCategories: ->
    _.map @attribures.subCategories, (attributes) ->
      new SubCategory(attributes)
