#this component renders the individual record
#this Record component will display a table row containing table cells for each record attribute.

@Record = React.createClass

    handleDelete: (e) ->
      e.preventDefault()
      $.ajax
        method: 'DELETE'
        url: "/records/#{ @props.abc.id }"
        dataType: 'JSON'
        success: () =>
          @props.handleDeleteRecord(@props.abc)

          #When the delete button gets clicked, handleDelete sends an AJAX request to the server to delete the record in the backend and, after this, it notifies the parent component about this action through the handleDeleteRecord handler available through props, this means we need to adjust the creation of Record elements in the parent component to include the extra property handleDeleteRecord, and also implement the actual handler method in the parent:
          # Basically, our deleteRecord method copies the current component's records state, performs an index search of the record to be deleted, splices it from the array and updates the component's state, pretty standard JavaScript operations.
          # We introduced a new way of interacting with the state, replaceState; the main difference between setState and replaceState is that the first one will only update one key of the state object, the second one will completely override the current state of the component with whatever new object we send.

    handleEdit: (e) ->
      e.preventDefault()
      data =
        title: (@refs.title).value
        date: (@refs.date).value
        amount: (@refs.amount).value
      $.ajax
        method: 'PUT'
        url: "/records/#{ @props.abc.id }"
        dataType: 'JSON'
        data: {
          record: data
        }
        success: (data) =>
          @setState edit: false
          @props.handleEditRecord @props.abc, data

    # Setting up edit function
    getInitialState: ->
      edit: false

    handleToggle: (e) ->
      e.preventDefault()
      @setState edit: !@state.edit
      # The edit flag will default to false, and handleToggle will change edit from false to true and vice versa, we just need to trigger handleToggle from a user onClick event.

    render: ->
      if @state.edit
        @recordForm()
      else
        @recordRow()

    recordRow: ->
    # render: ->
      React.DOM.tr null,
        React.DOM.td null, @props.abc.date
        React.DOM.td null, @props.abc.title
        React.DOM.td null, amountFormat(@props.abc.amount)
        React.DOM.td null,
          React.DOM.a
             className: 'btn btn-danger'
             onClick: @handleDelete
             'Delete'
          React.DOM.a
             className: 'btn btn-default'
             onClick: @handleToggle
             'Edit'


    recordForm: ->
      React.DOM.tr null,
        React.DOM.td null,
          React.DOM.input
            className: 'form-control'
            type: 'date'
            defaultValue: @props.abc.date
            ref: 'date'
        React.DOM.td null,
          React.DOM.input
            className: 'form-control'
            type: 'text'
            defaultValue: @props.abc.title
            ref: 'title'
        React.DOM.td null,
          React.DOM.input
            className: 'form-control'
            type: 'number'
            defaultValue: @props.abc.amount
            ref: 'amount'
        React.DOM.td null,
          React.DOM.a
            className: 'btn btn-default'
            onClick: @handleEdit
            'Update'
          React.DOM.a
            className: 'btn btn-danger'
            onClick: @handleToggle
            'Cancel'




# if component dont change the props, then dont need state? so therefore no need getinitialstate?
