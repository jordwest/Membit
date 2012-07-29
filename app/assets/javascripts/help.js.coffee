# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("div.question > p.answer").hide()
  $("div.question > a.question").on "click", ->
    $(this).parent().find("p.answer").slideToggle(200)

  $("a.inline-help-toggle").on "click", ->
    $("div.inline-help").slideToggle(200)