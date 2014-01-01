class this.Appointment
  init_delete_button : () =>
    button = @appointment_div.find(".delete-appointment")
    button.click =>
      cell = @appointment_div.parents(".day-planner-time-slot:first")
      url = document.URL.match(/(.*?)day_planner/)[1] + "appointments/" + cell.attr("id")
      $.ajax(
        url : url,
        type : "DELETE",
        dataType: "text",
        error : (e) ->
          console.log(e.message)
        success : (msg) ->
          eval(msg)
      )

  constructor: (@appointment_div) ->
    this.init_delete_button()