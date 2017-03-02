@AmountBox = React.createClass
  render: ->
   React.DOM.div
    className: 'col-md-4'
    React.DOM.div
      className: "panel panel-#{ @props.type }"
      React.DOM.div
        className: 'panel-heading'
        @props.text
      React.DOM.div
        className: 'panel-body'
        React.DOM.p null, amountFormat(@props.amount) #if you want the text/amount inside a <p> inside a <div>, you need to pass a null
        # amountFormat(@props.amount)  # if you want the text/amount raw inside div
