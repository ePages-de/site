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

  hasCategoryOption: (name) ->
    @$("option:contains(#{name})").length > 0

  selectCategory: (name) ->
    value = @$("option:contains(#{name})").val()
    @$("select").val(value).change()

  hasProduct: (name) ->
    @$(".epages-shop-product-name:contains(#{name})").length == 1


describe "Integration", ->
  jasmine.DEFAULT_TIMEOUT_INTERVAL = 5000

  beforeEach ->
    jasmine.getFixtures().set """
      <div class="epages-shop-widget"
           data-shopid="DemoShop"
           data-category-list>FIXTURE1</div>

      <div class="epages-shop-widget"
           data-shopid="DemoShop">FIXTURE2</div>

      <script src=http://localhost:4321/site.js></script>
    """

  it "loads site.js from another server", (done) ->
    widget = new TestWidget(el: $j(".epages-shop-widget:first"))

    widgetLoaded = ->
      widget.hasCategoryList() && widget.hasProductList()

    waitFor widgetLoaded, ->
      expect(widget.hasCategoryOption("Equipment")).toBeTruthy()
      widget.selectCategory("Equipment")

      categoryLoaded = ->
        widget.hasProduct("Mag-Lite")

      waitFor categoryLoaded, ->
        done()

