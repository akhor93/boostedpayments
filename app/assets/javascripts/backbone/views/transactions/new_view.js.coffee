VenmoGroups.Views.Transactions ||= {}

class VenmoGroups.Views.Transactions.NewView extends Backbone.View
  template: JST['backbone/templates/transactions/new']

  initialize: ->
    @model = new @collection.model()

  events:
    'submit #new-transaction': 'save'
    'remove-memberbox': 'updateFields'
    'add-memberbox': 'updateFields'
    'change #transaction-amount': 'updateTotal'

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()

    transactionDetails = $(e.currentTarget).serializeObject();
    @model.save(transactionDetails, {
      success: (transaction) ->
        that.collection.add(transaction)
        window.location.hash = "#/groups/"
    });

  updateFields: ->
    @updateNumPeople()
    @updateTotal()

  updateNumPeople: ->
    @numPeople = 0
    for e in $('#venmo-onebox-names .member-box')
      @numPeople++
    @$('#num-people-text').html(@numPeople)

  updateTotal: ->
    @total = @numPeople * $('#transaction-amount').val()
    @$('#transaction-total').html(@total.toFixed(2))


  render: (options) ->
    group = if @options.group then @options.group.toJSON() else null
    @$el.html(@template({
      model: @model.toJSON()
      group: group
      action: @options.action
    }))
    # Work around so JqueryUI and Bootstrap play nice
    if $.fn.button.noConflict
      btn = $.fn.button.noConflict()
      $.fn.btn = btn

    @$('#actions').buttonset()
    @$("form").backboneLink(@model)
    return this