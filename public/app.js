"use strict";
/*eslint-env jquery */
/*global Backbone, _ */

// Main application file for the SITe widget.

(function(window, document, undefined) {
  var Product = Backbone.Model.extend({
    //url: "http://site-cors-api-proxy.herokuapp.com/https://developer.epages.com/api/shops/DemoShop/products",
    idAttribute: "productId",
    defaults: function() {
      return {
        "productId": "12341234-1234-1234-1234-123412341234",
        "name": "Berghaus Paclite Jacket - Men (default)",
        "shortDescription": "Weatherproof. Small pack size. Ultra light. (default)",
        "description": "Weatherproof and compact. Ultra light.  <br />Material: weatherproof breathable Gore-Tex Paclite. Outer material: 100% Ripstop nylon. Reglan sleeves fit perfectly, because the shoulder is seamlessly connected to the arms. 380 g/L.",
        "images": [
        {
          "url": "http://restapi-sandbox.epages.de/WebRoot/Store/Shops/DemoShop/Products/be_40401/be_40401_blue_m.jpg",
          "classifier": "Medium"
        },
        {
          "url": "http://restapi-sandbox.epages.de/WebRoot/Store/Shops/DemoShop/Products/be_40401/be_40401_blue.jpg",
          "classifier": "Large"
        },
          {
            "url": "http://restapi-sandbox.epages.de/WebRoot/Store/Shops/DemoShop/Products/be_40401/be_40401_blue_s.jpg",
            "classifier": "Small"
          },
          {
            "url": "http://restapi-sandbox.epages.de/WebRoot/Store/Shops/DemoShop/Products/be_40401/be_40401_blue_xs.jpg",
            "classifier": "Thumbnail"
          }
        ],
        "priceInfo": {
          "quantity": {
            "amount": 1,
            "unit": "piece(s)"
          },
          "price": {
            "taxType": "GROSS",
            "formatted": "199.95 €",
            "amount": 199.95,
            "currency": "EUR"
          },
          "depositPrice": null,
          "ecoParticipationPrice": null,
          "priceWithDeposits": {
            "taxType": "GROSS",
            "formatted": "199.95 €",
            "amount": 199.95,
            "currency": "EUR"
          },
          "manufacturerPrice": null,
          "basePrice": null
        },
        "forSale": false,
        "specialOffer": false,
        "deliveryWeight": null,
        "shippingMethodsRestrictedTo": null,
        "availabilityText": "",
        "availability": null,
        "energyLabelsString": null,
        "energyLabelSourceFile": null,
        "productDataSheet": null,
        "links": [
        {
          "rel": "self",
          "href": "http://restapi-sandbox.epages.de/rs/shops/DemoShop/products/52CF164D-CFF7-E6BA-6BBA-D5809AAA9D2F",
          "title": null
        },
        {
          "rel": "custom-attributes",
          "href": "http://restapi-sandbox.epages.de/rs/shops/DemoShop/products/52CF164D-CFF7-E6BA-6BBA-D5809AAA9D2F/custom-attributes",
          "title": null
        },
          {
            "rel": "variations",
            "href": "http://restapi-sandbox.epages.de/rs/shops/DemoShop/products/52CF164D-CFF7-E6BA-6BBA-D5809AAA9D2F/variations",
            "title": null
          }
        ]
      };
    }
  });

  var ProductList = Backbone.Collection.extend({
    url: "http://site-cors-api-proxy.herokuapp.com/https://developer.epages.com/api/shops/DemoShop/products",
    model: Product,
    parse: function(data) {
      return data.items;
    }
  });

  var Products = new ProductList();

  var ProductView = Backbone.View.extend({
    tagName: "div",
    template: _.template("<div class='product'><img src='<%= _.findWhere(images, {classifier: 'Small'}).url %>'/><div class='product-name'><%= name %></div><div class='product-price'><%= priceInfo.price.formatted %></div></div>"),
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    }
  });

  var ProductsView = Backbone.View.extend({
    el: $(".eps-site-widget"),
    initialize: function() {
      this.listenTo(Products, "all", this.render);
      Products.fetch();
    },
    render: function() {
      if (Products.length > 0) {
        var result = "";
        Products.each( function(product) {
          var pv = new ProductView({model: product}).render().el;
          result += pv.outerHTML;
        });
        this.$el.html(result);
      } else {
        this.$el.html("loading...");
      }
      return this;
    }
  });

  new ProductsView().render();

  // var AppView = Backbone.View.extend({
  //   el: $(".eps-site-widget"),
  // });
  //
  // var App = new AppView;

}(window, document, undefined));
