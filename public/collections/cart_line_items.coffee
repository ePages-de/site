class CartLineItems extends Backbone.Collection

  initialize: (models, options) ->
    { @cart } = options

  model: Product

  _prepareModel: (attributes, options) ->
    model = super
    return model unless model

    model.cart = @cart
    model
