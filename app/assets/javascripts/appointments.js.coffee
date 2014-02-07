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
      appointment_id = @appointment_div.parent().attr("id")
      routine_name = @appointment_div.find(".routine-name").text().trim();
      $("#routine_client").val(login)
      $("#routine_routine_date_time_slot").val(appointment_id)
      if routine_name
        $("form#new_routine").attr("method", "PUT")
        $("form#new_routine").attr("action", "/users/" + login + "/routines/" + routine_name.toIdentifier())
        url = "/users/" + login + "/routines/" + routine_name.toIdentifier() + ".js"
        $.ajax(
          url : url,
          type : "GET",
          dataType: "text",
          error : (e) ->
            console.log(e.message)
          success : (msg) ->
            eval(msg)
        )
      else
        $("form#new_routine").attr("method", "POST")
        $("form#new_routine").attr("action", "/users/" + login + "/routines")
      $("#modal-routine-builder").modal()
      $("#ajax-source-id").text(appointment_id)

  constructor: (@appointment_div) ->
    this.init_delete_button()
    this.init_create_routine_button()