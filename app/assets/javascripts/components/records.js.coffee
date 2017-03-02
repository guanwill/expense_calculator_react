#this is component to display list of records
@Records = React.createClass #the var here must match the react_component 'Records' in index.html.erb

  #getInitialState method will generate the initial state of our component.
  getInitialState: ->  #can use 'this.props' or '@props'
    react_records: this.props.abc

  #getDefaultProps will initialize our component's properties in case we forget to send any data when instantiating it
  getDefaultProps: ->
    react_records: []

  credits: ->
    credits = @state.react_records.filter (val) ->
      val.amount >= 0
    credits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
    # credits = this.state.records.filter(function(val) {
    #   return val.amount >= 0;
    # });
    #The reduce() method applies a function against an accumulator and each value of the array (from left-to-right) to reduce it to a single value.
  debits: ->
    debits = @state.react_records.filter (val) ->
      val.amount < 0
    debits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
  balance: ->
    @debits() + @credits()

  # addRecord: (entry) ->
  #   react_records = this.state.react_records.slice()
  #   console.log(react_records)
  #   react_records.push(entry) #pushes new entry to the list
  #   @setState react_records: react_records

  addRecord: (record) ->
    react_records = React.addons.update(@state.react_records, { $push: [record] })
    @setState react_records: react_records

  # deleteRecord: (entry) ->
  #   react_records = this.state.react_records.slice()
  #   index = react_records.indexOf(entry)
  #   react_records.splice index, 1
  #   @replaceState react_records: react_records

  deleteRecord: (record) ->
    index = @state.react_records.indexOf(record)
    react_records = React.addons.update(@state.react_records, { $splice: [[index, 1]] })
    @replaceState react_records: react_records
    # difference between setState and replaceState is that the first one will only update one key of the state object, the second one will completely override the current state of the component with whatever new object we send.

  updateRecord: (record, data) ->
    index = @state.react_records.indexOf(record)
    react_records = React.addons.update(@state.react_records, { $splice: [[index, 1, data]] })
    @replaceState react_records: react_records

  render: ->
    React.DOM.div
      className: 'records container'
      React.DOM.h2
        className: 'title'
        'Expense Calculator'

      #Render summary div component
      React.DOM.div
        className: 'row'
        React.createElement AmountBox, type: 'success', amount: @credits(), text: 'Credit'
        React.createElement AmountBox, type: 'danger', amount: @debits(), text: 'Debit'
        React.createElement AmountBox, type: 'info', amount: @balance(), text: 'Balance'

      # Render record form
      React.createElement(RecordForm, handleNewRecord: @addRecord)
      React.DOM.hr null

      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Date'
            React.DOM.th null, 'Title'
            React.DOM.th null, 'Amount'
            React.DOM.th null, 'Actions'
        React.DOM.tbody null,
          for abc in this.state.react_records
            # Render individual records
            React.createElement Record, key: abc.id, abc: abc, handleDeleteRecord: @deleteRecord, handleEditRecord: @updateRecord
            #When we handle dynamic children (in this case, records) we need to provide a key property to the dynamically generated elements so React won't have a hard time refreshing our UI, that's why we send key: record.id along with the actual record when creating Record elements.


# Open your project's config/application.rb file and add config.react.addons = true at the bottom of the Application block:
# we have access to the state helpers through React.addons.update, which will process our state object (or any other object we send to it) and apply the provided commands. The two commands we will be using are $push and $splice
