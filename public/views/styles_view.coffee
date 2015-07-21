class StylesView extends Backbone.View

  tagName: "style"

  attributes:
    type: "text/css"

  template: _.template """
    #epages-shop-widget-loading {
      background-image: url(#{App.rootUrl()}/images/spinner.gif);
      background-color: white;
      border-radius: 6px;
      display: none;
      height: 32px;
      left: 50%;
      position: fixed;
      top: 50px;
      width: 32px;
      z-index: 10002;
    }
    .epages-shop-widget  {
      overflow: auto;
    }
  """

  render: ->
    @$el.html @template()
    this
