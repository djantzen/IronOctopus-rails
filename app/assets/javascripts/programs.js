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

  $(".new-routine-button").click(function() {
    $("#modal-routine-builder").modal();
  });

  var clear_routine_form = function() {
    var routine_name = $("#routine_name").val();
    $(".weekday-bucket select").append("<option value=" + routine_name.toIdentifier() + ">" + routine_name + "</option>");
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
  });

  $("#scheduled-program-button").click(function() {
    $("#weekday-program").hide();
    $("#scheduled-program").show();
  });

  $("#date-picker").datepicker({
    showOtherMonths: true,
    selectOtherMonths: true,
    showWeek: true,
    firstDay: 1,
    onSelect: function(dateText, inst) {
      // pop up a dialog with available routines and time.
    }

  });

});
