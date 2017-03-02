@RecordForm = React.createClass
  getInitialState: ->
    title: ''
    date: ''
    amount: ''

  handleChange: (e) ->
      name = e.target.name
      console.log(name)
      @setState "#{ name }": e.target.value

  valid: ->
      @state.title && @state.date && @state.amount

  # handleSubmit: (e) ->
  #   e.preventDefault()
  #   $.post '', { record: @state }, (data) =>
  #     console.log('handle submit data: ' + data)
  #     @props.handleNewRecord data
  #     @setState @getInitialState()
  #   , 'JSON'

  handleSubmit: (e) ->
    e.preventDefault()
    $.ajax
      url: ''
      type: 'POST'
      dataType: 'JSON'
      data: {
        record: this.state
      }
      success: (data) =>
        this.props.handleNewRecord(data) #this submit button will trigger addRecord method in records
        @setState (@getInitialState()) #after submitting data and adding record, return state to initial, which mean all fields emptied


    #The success callback is the key of this process, after successfully creating the new record someone will be notified about this action and the state is restored to its initial value.
    #Do you remember early in the post when I mentioned that components communicate with other components through properties (or @props)? Well, this is it. Our current component sends data back to the parent component through @props.handleNewRecord to notify it about the existence of a new record.
    #As you might have guessed, wherever we create our RecordForm element, we need to pass a handleNewRecord property with a method reference into it, something like React.createElement RecordForm, handleNewRecord: @addRecord. Well, the parent Records component is the "wherever", as it has a state with all of the existing records, we need to update its state with the newly created record.
    #Add the new addRecord method inside records.js.coffee and create the new RecordForm element, just after the h2 title (inside the render method).

  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit

      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'date'
          className: 'form-control'
          placeholder: 'Date'
          name: 'date'
          value: @state.date
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Title'
          name: 'title'
          value: @state.title
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'number'
          className: 'form-control'
          placeholder: 'Amount'
          name: 'amount'
          value: @state.amount
          onChange: @handleChange

      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        disabled: !@valid()
        'Create record'

#Notice how we are defining the value attribute to set the input's value
#onChange attribute to attach a handler method which will be called on every keystroke; the handleChange handler method will use the name attribute to detect which input triggered the event and update the related state value:

#We are just using string interpolation to dynamically define object keys, equivalent to @setState title: e.target.value when name equals title. But why do we have to use @setState? Why can't we just set the desired value of @state as we usually do in regular JS Objects? Because @setState will perform 2 actions, it:
  #Updates the component's state
  #Schedules a UI verification/refresh based on the new state
#It is very important to have this information in mind every time we use state inside our components.

#We defined a disabled attribute with the value of !@valid(), meaning that we are going to implement a valid method to evaluate if the data provided by the user is correct.
