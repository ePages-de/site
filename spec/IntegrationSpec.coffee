waitFor = (condition, next) ->
  interval = setInterval ->
    if condition()
      clearInterval(interval)
      next()
  , 10


class TestWidget
  constructor: (options) ->
    @$el = options.el

  $: (selector) ->
    @$el.find(selector)

  hasCategoryList: ->
    @$("option").length > 0

  hasProductList: ->
    @$(".epages-shop-product").length > 0

  variationsLoaded: ->
    $(".pico-content").find(".epages-shop-variation").length > 0

  hasCategoryOption: (name) ->
    @$("option:contains(#{name})").length > 0

  selectCategory: (name) ->
    value = @$("option:contains(#{name})").val()
    @$("select").val(value).change()

  hasProduct: (name) ->
    @$(".epages-shop-product-name:contains(#{name})").length == 1

  productLink: (name) ->
    @$("a .epages-shop-product-name:contains(#{name})")


describe "Integration", ->
  jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000

  beforeEach ->
    @$container = $ """
      <div id="test-container">
        <div class="epages-shop-widget" data-category-list>FIXTURE1</div>
        <div class="epages-shop-widget">FIXTURE2</div>
      </div>
    """

    # Creating the script tag via Zepto does not load the script.
    script = document.createElement("script")
    script.type = "text/javascript"
    script.src  = "http://localhost:4321/site.js"
    script.id   = "epages-widget"
    script.dataset.shopid = "mindmatters"

    @$container.append script
    $(document.body).append @$container

  afterEach ->
    @$container.remove()

  it "loads site.js from another server", (done) ->
    widget = new TestWidget(el: $(".epages-shop-widget:first"))

    widgetLoaded = ->
      widget.hasCategoryList() && widget.hasProductList()

    waitFor widgetLoaded, ->
      expect(widget.hasCategoryOption("Shoes")).toBeTruthy()
      widget.selectCategory("Shoes")

      categoryLoaded = ->
        widget.hasProduct("Meindl RFS Tibet")

      waitFor categoryLoaded, ->
        widget.productLink("Meindl RFS Tibet").click()

        waitFor widget.variationsLoaded, ->
          expect( $("label[for='epages-shop-variation-USSize']").is(':visible') ).toBeTruthy()
          done()

