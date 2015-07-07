class ProductDetailView extends Backbone.View

  template: _.template """
    <div>
      HERE GOES THE PRODUCT DETAILS
    </div>
  """

  render: ->
    @$el.html @template()
    this
