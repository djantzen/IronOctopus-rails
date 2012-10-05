$(document).ready(function() {

  $('#available-routines-list li').draggable({
    helper: 'clone'
  });

  $("#program-builder-panel form").validate();


  $('#weekly-schedule .weekday-bucket').droppable({
    drop: function(event, ui) {
      var routine = $(ui.draggable).clone();
//        <%= hidden_field_tag "program[weekday][program]", routine.permalink %>
//debugger;
        $(this).html(routine);
    }
  });

});
