# SITe

SITe is javascript widget that allows webmasters to embed an epages shop into
their website. The live demo is on http://site-production.herokuapp.com/

## For webmasters

### Getting started

1. Embed the javascript tag right before the closing ```</html>``` in your
   webpage:
    ```html
    <script src="https://TODO/site.js" async="true" id="epages-widget" data-shop-url="YOUR_API_URL"></script>
    ```

2. Insert the widget ```div``` into your page. This is where the products will be shown.
    ```html
    <div class="epages-shop-widget"></div>
    ```

### Widget options

The widget supports multiple options that can be combined:

* **data-category-list** (default: disabled):  
  To display a drop down with all of your categories, add `data-category-list` to the widget ```div```:

    ```html
    <div class="epages-shop-widget" data-category-list="true"></div>
    ```

* **data-search-form** (default: enabled):  
  To hide the search form, add `data-search-form="false"` to the widget ```div```:

    ```html
    <div class="epages-shop-widget" data-search-form="false"></div>
    ```

* **data-sort** (default: enabled):  
  To hide the sorting options, add  `data-sort="false"` to the widget ```div```:

    ```html
    <div class="epages-shop-widget" data-sort="false"></div>
    ```

* **data-product-ids** (default: empty):  
  To only show preselected products, add their comma-separated IDs to the `data-product-ids` attribute:

    ```html
    <div class="epages-shop-widget" data-product-ids="559CE8CA-40A4-01E2-5957-D5809AB3FEA7,559CE8CB-05B5-5A70-1349-D5809AB3FEA1"></div>
    ```

* **data-category-id** (default: empty):  
  To only show one preselected category, add the ```data-category-id``` attribute:

    ```html
    <div class="epages-shop-widget" data-category-id="559CE8D5-181B-4F27-37BC-D5809AB3FE11"></div>
    ```
  This disables the category drop-down.

* **data-product-details** (default: empty):
  To only show a preselected product, add the ```data-product-details``` attribute:


    ```html
    <div class="epages-shop-widget" data-product-details="563742F8-E839-B779-74D0-0A0C05E64C62"></div>
    ```

* **data-products-per-page** (default: 12):  
  To only show a specific number of products per page, add the ```data-products-per-page``` attribute:

    ```html
    <div class="epages-shop-widget" data-products-per-page="6"></div>
    ```

### Custom shopping cart position

By default, the shopping cart is displayed within the widget itself. You can place the shopping cart at
a custom position by inserting your own cart  ```div``` somewhere into the page.

```html
<div class="epages-shop-cart"></div>
```

## For developers

### Installation with docker

If it's the first time or you want to update the package.json you have to build it first:

```sh
docker-compose build
```

After that, you'll only have to do:

```sh
docker-compose up
```

### Installation without docker

```sh
npm install
```

### Usage

Starting the test server:

```sh
NODE_ENV=development npm start
```

Building the JavaScript (Development):

```
NODE_ENV=development gulp build
```

Building the JavaScript (Production):

```
NODE_ENV=production gulp build
```

Watch for changes and build for development:

```
NODE_ENV=development gulp watch
```

### Testing

Tests are run against a caching proxy for the API. When adding new tests you
have to record new responses with `REPLAY=record npm test` and then modify the
new files in ./fixtures/ by deleting the "accept-language" and
"accept-encoding" headers from requests to workaround different chrome version
on your machine and CircleCI

```sh
NODE_ENV=development npm test # or npm run watch to keep running
```

### License
SITe is released under the [MIT License](http://opensource.org/licenses/MIT).
