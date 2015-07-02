describe 'Hello Word', ->
  $widget = null

  beforeEach (done) ->
    jasmine.getFixtures().set(
      '<div class="eps-site-widget" data-shopid="DemoShop">FIXTURE</div>' +
      '<script src=http://localhost:4566/site.js></script>'
    )
    $widget = $j('.eps-site-widget')
    expect($widget.text()).toEqual("FIXTURE")
    setTimeout(done, 100)

  it 'works', ->
    expect($widget).toExist()
    expect($widget.data("shopid")).toEqual("DemoShop")
    expect($widget.text()).toEqual("WIDGET")
