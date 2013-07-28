$(document).ready ->
  $(".control-box").on "click", sendControlMessage
    
sendControlMessage = (e) ->
  if $(this).hasClass('color')
    dataObj = color: $(this).css 'background-color'
  else
    dataObj = shape: $(this).attr('class').split(/\s+/).pop()

  $.ajax "/control-box",
    type: "GET"
    data: dataObj
    error: -> alert 'Whoops!'
    success: (data) -> 
