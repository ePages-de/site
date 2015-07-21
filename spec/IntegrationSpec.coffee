waitUntil = (condition, args..., next) ->
  interval = setInterval ->
    if condition(args...)
      clearInterval(interval)
      next()
  , 10


class TestWidget
  constructor: (options) ->
    @$el = options.el

  $: (selector) =>
    @$el.find(selector)

  hasCategoryList: =>
    @$("option").length > 0

  hasProductList: =>
    @$(".epages-shop-product").length > 0

  isReady: =>
    @hasCategoryList() && @hasProductList()

  variationsLoaded: =>
    $(".pico-content").find(".epages-shop-variation").length > 0

  hasCategoryOption: (name) =>
    @$("option:contains(#{name})").length > 0

  selectCategory: (name) =>
    value = @$("option:contains(#{name})").val()
    @$("select").val(value).change()

  hasProduct: (name) =>
    @$(".epages-shop-product-name:contains(#{name})").length == 1

  productLink: (name) =>
    @$("a .epages-shop-product-name:contains(#{name})")


describe "Widget", ->
  jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000

  beforeEach ->
    @$container = $ """
      <div id="test-container">
        <div id="widget-with-categories" class="epages-shop-widget" data-category-list>FIXTURE1</div>
        <div id="widget-default" class="epages-shop-widget">FIXTURE2</div>
        <div id="widget-disabled" class="epages-shop-widget" data-search-form=false data-sort=false>FIXTURE2</div>
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


  it "loads categories, product details and variations", (done) ->
    widget = new TestWidget
      el: $("#widget-with-categories")

    waitUntil widget.isReady, ->
      expect( widget.hasCategoryOption("Shoes") ).toBeTruthy()
      widget.selectCategory("Shoes")

      waitUntil widget.hasProduct, "Meindl RFS Tibet", ->
        widget.productLink("Meindl RFS Tibet").click()

        waitUntil widget.variationsLoaded, ->
          expect(
            $("label[for='epages-shop-variation-USSize']").is(':visible')
          ).toBeTruthy()
          done()

  it "enabled search form and sort by default", (done) ->
    widget = new TestWidget
      el: $("#widget-default")

    $(document).on "ajaxStop", ->
      expect(widget.$(".epages-shop-category-list").html()).toEqual ""
      expect(widget.$(".epages-shop-search-form form").length).toEqual 1
      expect(widget.$(".epages-shop-sort a").length).toEqual 3
      done()

  it "allows disabled search form and sort", (done) ->
    widget = new TestWidget
      el: $("#widget-disabled")

    $(document).on "ajaxStop", ->
      expect(widget.$(".epages-shop-search-form").html()).toEqual ""
      expect(widget.$(".epages-shop-sort").html()).toEqual ""
      done()
