$ = jQuery

baseXml =
  '<ruby>
  	<rb>$2</rb>
  	<rp>(</rp>
  	<rt>$3</rt>
  	<rp>)</rp>
  </ruby>'

$.fn.extend {}=
  rubyann: () ->

    #regex = ///#{startChar}((\S+?),(\S+?))#{endChar}///g
    regex = /(^|\s)(\S+?)\[(\S+?)\]/g

    @each ->
      html = $(@).html()
      newHtml = html.replace regex, baseXml
      $(@).html(newHtml) if newHtml isnt html