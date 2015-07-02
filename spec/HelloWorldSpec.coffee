describe 'Hello Word', ->
  $widget = null

  beforeEach (done) ->
    jasmine.getFixtures().set(
      '<div class="epages-shop-widget" data-shopid="DemoShop">FIXTURE</div>' +
      '<script src=http://localhost:4566/site.js></script>'
    )
    $widget = $j('.epages-shop-widget')
    expect($widget.text()).toEqual("FIXTURE")
    waitForWidget = setInterval(->
      console.log "text: " + $widget.text()
      if $widget.text() != 'FIXTURE'
        done && clearInterval(waitForWidget)
    , 10)

  it 'works', ->
    expect($widget).toExist()
    expect($widget.data("shopid")).toEqual("DemoShop")
    expect($widget.text()).toEqual("WIDGET")
