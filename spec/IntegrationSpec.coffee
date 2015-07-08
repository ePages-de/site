waitFor = (condition, next) ->
  interval = setInterval(->
    if condition()
      next()
      clearInterval(interval)
  , 10)

describe 'Integration', ->
  jasmine.DEFAULT_TIMEOUT_INTERVAL = 5000

  beforeEach ->
    jasmine.getFixtures().set """
      <div
        class="epages-shop-widget"
        data-shopid="DemoShop"
        data-category-list>FIXTURE1</div>
      <div class="epages-shop-widget" data-shopid="DemoShop">FIXTURE2</div>
      <script src=http://localhost:4321/site.js></script>
    """

  it 'loads site.js from another server', (done) ->
    $widget = jQuery('.epages-shop-widget:first')
    ready = ->
      $widget.find("option").length > 0 &&
      $widget.find(".epages-shop-product").length > 0

    waitFor ready, ->
      changeEvent = document.createEvent "MouseEvent"
      changeEvent.initEvent('change', true, true)
      expect($widget.find("option:contains(Equipment)")).toExist()
      $widget.find("select").val(jQuery("option:contains(Equipment)").val())
      document.getElementsByTagName("select")[0].dispatchEvent(changeEvent)

      categoryLoaded = ->
        $widget.find(".epages-shop-product-name:contains(Mag-Lite)").length == 1

      waitFor categoryLoaded, ->
        done()
