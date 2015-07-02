describe 'Integration', ->
  $widget = null
  jasmine.DEFAULT_TIMEOUT_INTERVAL = 2000

  beforeEach (done) ->
    jasmine.getFixtures().set(
      '<div class="epages-shop-widget" data-shopid="DemoShop">FIXTURE</div>' +
      '<script src=http://localhost:4321/site.js></script>'
    )
    $widget = $j('.epages-shop-widget')
    expect($widget.text()).toEqual("FIXTURE")
    waitForWidget = setInterval(->
      if $widget.text() != 'FIXTURE'
        done()
        clearInterval(waitForWidget)
    , 10)

  it 'loads site.js from another server', ->
    expect($widget).toExist()
    expect($widget.data("shopid")).toEqual("DemoShop")
    expect($widget.text()).toEqual("Loading ...")
