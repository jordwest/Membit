# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

###
$("#registration-codes-table tbody tr").on 'click', ->
  checkbox = $(this).find('input')
  checkbox.attr('checked', !checkbox.attr('checked'))
###

$("#registration-codes-table tbody").selectable(
  filter: 'tr'
  delay: 50
  cancel: 'input'
  selected: (event, ui) ->
    $(this).find('input').attr('checked', false)
    $(this).find('.ui-selected input').attr('checked', true)
)

$("#registration-codes-table tbody tr input").on 'click', ->
  if $(this).attr('checked')
    $(this).parents('tr').addClass('ui-selected')
  else
    $(this).parents('tr').removeClass('ui-selected')