$(document).ready(function() {

  $("#available-body-part-list .activity-attribute").click(function() {
    if ($(this).hasClass("ui-state-active")) {
      $(this).removeClass("ui-state-active");
      $(this).find("input.activity-attribute-control").remove();
    } else {
      $(this).addClass("ui-state-active");
      $(this).append("<input name='activity[body_parts][]' type='hidden' value='" + $(this).attr("id") + "' class='activity-attribute-control'>");
    }
  });

  $("#available-implement-list div.activity-attribute").click(function() {
    if ($(this).hasClass("ui-state-active")) {
      $(this).removeClass("ui-state-active");
      $(this).find("input.activity-attribute-control").remove();
    } else {
      $(this).addClass("ui-state-active");
      $(this).append("<input name='activity[implements][]' type='hidden' value='" + $(this).attr("id") + "' class='activity-attribute-control'>");
    }
  });

  $("#available-metric-list div.activity-attribute").click(function() {
    if ($(this).hasClass("ui-state-active")) {
      $(this).removeClass("ui-state-active");
      $(this).find("input.activity-attribute-control").remove();
    } else {
      $(this).addClass("ui-state-active");
      $(this).append("<input name='activity[metrics][]' type='hidden' value='" + $(this).attr("id") + "' class='activity-attribute-control'>");
    }
  });

  $("#available-activity-attribute-list div.activity-attribute").click(function() {
    if ($(this).hasClass("ui-state-active")) {
      $(this).removeClass("ui-state-active");
      $(this).find("input.activity-attribute-control").remove();
    } else {
      $(this).addClass("ui-state-active");
      $(this).append("<input name='activity[activity_attributes][]' type='hidden' value='" + $(this).attr("id") + "' class='activity-attribute-control'>");
    }
  });


    // on click on an attribute
  // if currently selected, remove class .selected-activity-attribute and remove hidden tag .activity-attribute-control
  // if not current selected, add class .selected-activity-attribute and append hiddent tag .activity-attribute-control
  var update_selected_attributes = function() {
    
  }

});