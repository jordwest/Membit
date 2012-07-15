# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$("#registration-codes-table tbody").selectable
  filter: 'tr'
  cancel: 'input'
  selected: ->
    $('#registration-codes #hover-actions').show()

$('#registration-codes #hover-actions .btn').on 'click', (event, ui) ->
  payload = {}
  # Find selected items
  switch $(event.target).attr('id')
    when 'mark-printed'
      payload.mark = 'printed'
    when 'mark-unprinted'
      payload.mark = 'unprinted'
    when 'mark-tag'
      payload.mark = 'tag'
      payload.tag = prompt("Enter a new tag")

  payload.codes = []
  payload._method = "PUT"
  $("tr.ui-selected").each (index, tr) ->
    payload.codes.push $(tr).data('recid')

  console.log payload
  $.ajax(
    data: payload
    type: "POST"
    success: ->
      location.reload true
  )
