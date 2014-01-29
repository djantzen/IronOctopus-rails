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

  init_create_routine_button : () =>
    button = @appointment_div.find(".edit-selected-routine-button")
    button.click =>
      login = @appointment_div.find(".client-login").text().trim()
      $("form#new_routine").attr("action", "/users/" + login + "/routines")
      $("#modal-routine-builder").modal()

  constructor: (@appointment_div) ->
    this.init_delete_button()
    this.init_create_routine_button()