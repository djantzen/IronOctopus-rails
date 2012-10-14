$(document).ready(function() {

//  $('#available-routines-list li').draggable({
//    helper: 'clone'
//  });
//  $('#weekly-schedule .weekday-bucket').droppable({
//    drop: function(event, ui) {
//      var routine = $(ui.draggable).clone();
//        $(this).html(routine);
//    }
//  });

  $("#program-builder-panel form").validate();

  $(".edit-selected-routine-button").click(function() {
    $(this).parents(".calendar-day").find(".modal-routine-select").modal();
  });

  $(".okay-selected-routine-button").click(function() {
    var container = $(this).parents(".calendar-day");
    var modal = container.find(".modal-routine-select");
    var selected = container.find("option:selected").html();
    container.find(".display-name").html(selected);
    modal.modal("hide");
  });

  $(".new-routine-button").click(function() {
    var container = $(this).parents(".calendar-day");
    var modal = container.find(".modal-routine-select");
    modal.modal("hide");
    $("#modal-routine-builder").modal();
  });

  var clear_routine_form = function() {
    var routine_name = $("#routine_name").val();
    $("select.routine-select").append("<option value=" + routine_name.toIdentifier() + ">" + routine_name + "</option>");
    $("#modal-routine-builder form input").val(null);
    $("#modal-routine-builder .activity-set-form").remove();
  }

  $("#modal-routine-builder form").bind('ajax:complete', function() {
    $("#modal-routine-builder").modal('hide');
    clear_routine_form();
  });

  $("#cancel-routine-builder-button").click(function() {
    $("#modal-routine-builder").modal('hide');
    clear_routine_form();
  });

  $("#weekday-program-button").click(function() {
    $("#scheduled-program").hide();
    $("#weekday-program").show();
    $("#program_type").val("weekday");
  });

  $("#scheduled-program-button").click(function() {
    $("#weekday-program").hide();
    $("#scheduled-program").show();
    $("#program_type").val("scheduled");
  });

  $("#date-picker").datepicker({
    showOtherMonths: true,
    selectOtherMonths: true,
    showWeek: true,
    firstDay: 1,
    onSelect: function(dateText, inst) {

      console.info(inst);
      // pop up a dialog with available routines and time.
    }
  });

});
