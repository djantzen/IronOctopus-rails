class this.DayPlannerCell
  add_appointment: (cell, client_login) ->
    url = document.URL.match(/(.*?)day_planner/)[1] + "appointments"
    id = cell.id
    $.post(
      url,
      appointment :
        client_login : client_login,
        date_time_slot_id : id
    )

  update_appointment: (old_cell, new_cell, appointment) ->
    console.log(old_cell.attr("id"))
    console.log(new_cell.attr("id"))
    #move the routine
    url = document.URL.match(/(.*?)day_planner/)[1] + "appointments/" + old_cell.attr("id")
    $.ajax(
      url : url,
      type : "PUT",
      dataType: "text",
      data :
        new_date_time_slot_id : new_cell.attr("id")
      error : (e) ->
        console.log(e.message)
      success : (msg) ->
        eval(msg)
    )


  constructor: (@day_planner_cell_div) ->
    @day_planner_cell_div.droppable(
      tolerance : "pointer"
      disabled : @day_planner_cell_div.find(".appointment").size() != 0
      drop : (event, ui) =>
        if (ui.draggable.hasClass("appointment"))
          old_day_planner_cell = ui.draggable.parents(".day-planner-time-slot")
          @update_appointment(old_day_planner_cell, $(event.target), ui.draggable.find(".appointment"))
        else
          @add_appointment(event.target, ui.draggable.find(".client-login").text().trim())
    )


$(document).ready () ->
  $('#day-planner-client-list .client').draggable(
    cursor : 'move'
    helper : "clone"
  );

  # TODO only on future timeslots
  $(".day-planner-time-slot").each ->
    new DayPlannerCell($(this))

  $(".appointment").each ->
    if $(this).html().trim() != ""
      new Appointment($(this))
