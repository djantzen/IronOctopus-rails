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

  constructor: (@day_planner_cell_div) ->
    @day_planner_cell_div.droppable(
      tolerance: "pointer"
      drop: (event, ui) => @add_appointment(event.target, ui.draggable.find(".login").text().trim())
    )


$(document).ready () ->
  $('#day-planner-client-list .client').draggable(
    cursor: 'move'
    helper: "clone"
  );

  $(".day-planner-time-slot").each ->
    new DayPlannerCell($(this))

  $(".appointment").each ->
    if $(this).html().trim() != ""
      new Appointment($(this))
