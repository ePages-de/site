describe 'Hello Word', ->
  beforeEach ->
    jasmine.getFixtures().set(
      '<div class="eps-site-widget" data-shopid="DemoShop">FIXTURE</div>' +
      '<script src=http://localhost:4566/site.js async=true></script>' +
      '<script>console.log("fixtures work");</script>'
    )

  it 'works', ->
    $widget = $j('.eps-site-widget')
    expect($widget).toExist()
    expect($widget.data("shopid")).toEqual("DemoShop")
    expect($widget.text()).toEqual("ASDF")
