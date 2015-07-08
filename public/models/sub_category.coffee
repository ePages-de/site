class SubCategory extends Backbone.Model
  id: ->
    return "" unless @get("href")

    split = @get("href").split("/")
    split[split.length - 1]

  name: ->
    @get("title")
