class ProductListView extends Backbone.View

  render: ->
    html = @collection.map (product) ->
      view = new ProductView(model: product)
      view.render().el

    @$el.html html
    @$el.append """
      <style type="text/css">
        .epages-shop-product-link {
          text-decoration: none;
          color: inherit;
        }
        .epages-shop-product-link:hover {
          text-decoration: underline;
        }
      </style>
    """
    this
