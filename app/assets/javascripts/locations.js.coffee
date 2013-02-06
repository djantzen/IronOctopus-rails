$(document).ready () ->
  $("#city-select").autocomplete({
  minLength: 3,
  source: (request, response)->
    $.ajax({
    type: "GET",
    async: false,
    dataType: "json",
    url: "/cities/search/" + $("#city-select").val(),
    success: (data)->
      response($.map(data.json, (item) ->
        return {
        label: item[0] + ", " + item[1],
        value: item[0] + ", " + item[1]
        }
      ))
    #          open: ->
    #            alert("open")
    #            $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" )
    #          close: ->
    #            alert("close")
    #            $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" )
    })
  })

  $("#location-create-update-form form").validate();
