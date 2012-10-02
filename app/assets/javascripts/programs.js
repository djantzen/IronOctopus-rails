$(document).ready(function() {

  $('#available-routines-list li').draggable({
    helper: 'clone'
  });



  $('#weekly-schedule li').droppable({
    drop: function(event, ui) {
      $(this).append($(ui.draggable).clone());
    }
  });

});
