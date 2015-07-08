waitFor = (condition, next) ->
  interval = setInterval(->
    if condition()
      next()
      clearInterval(interval)
  , 10)

describe 'Integration', ->
  jasmine.DEFAULT_TIMEOUT_INTERVAL = 2000

  beforeEach ->
    jasmine.getFixtures().set """
      <div class="epages-shop-widget" data-shopid="DemoShop">FIXTURE1</div>
      <div class="epages-shop-widget" data-shopid="DemoShop">FIXTURE2</div>
      <script src=http://localhost:4321/site.js></script>
    """

  it 'loads site.js from another server', (done) ->
    $widget = $j('.epages-shop-widget:first')
    ready = -> $widget.text().indexOf("FIXTURE") == -1

    waitFor ready, ->
      expect($widget).toExist()
      expect($widget).toContainText("Loading")
      done()
