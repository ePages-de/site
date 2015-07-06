class SubCategory extends Backbone.Model
  id: ->
    split = @attributes.href.split("/")
    split[split.length - 1]

  name: ->
    @attributes.title
