class CartLineItems extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId, @cartId } = options

  model: CartLineItem

  _prepareModel: (attributes, options) ->
    model = super
    return model unless model

    model.shopId = @shopId
    model.cartId = @cartId
    model
