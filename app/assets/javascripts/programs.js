$(document).ready(function() {

  $(".edit-selected-routine-button").click(function() {
    $(this).parents(".calendar-day").find(".modal-routine-select").modal();
  });

  $(".okay-selected-routine-button").click(function() {
    var container = $(this).parents(".calendar-day");
    var modal = container.find(".modal-routine-select");
    if (container.find("select").val()) {
      var selected = container.find("option:selected").html();
      container.find(".display-name").html(selected);
    } else {
      container.find(".display-name").html(null);
    }
    modal.modal("hide");
  });

  $(".new-routine-button").click(function() {
    $("#modal-routine-builder").modal();
  });

  var clear_routine_form = function() {
    $("#routine-form-panel form")[0].reset();
    $("#routine_name").attr("value", null);
    $("#routine_goal").attr("value", "None specified");
    $("#modal-routine-builder .activity-set-group").remove();
  }

  $("#routine-builder-panel form").bind('ajax:complete', function() {
    var routine_name = $("#routine_name").val();
    $("select.routine-select").append("<option value=" + routine_name.toIdentifier() + ">" + routine_name + "</option>");
    $("#modal-routine-builder").modal('hide');
    var source_id = $("#ajax-source-id").text().replace(/:/g, "\\:");
    $("#" + source_id).find(".routine-name").text(routine_name);
    clear_routine_form();
  });

  $("#cancel-routine-builder-button").click(function() {
    $("#modal-routine-builder").modal('hide');
    clear_routine_form();
  });

  $("#weekday-program-button").click(function() {
    $("#scheduled-program").hide();
    $("#weekday-program").show();
    $("#program_type").val("Weekday");
  });

  $("#scheduled-program-button").click(function() {
    $("#weekday-program").hide();
    $("#scheduled-program").show();
    $("#program_type").val("Scheduled");
  });

  var program_name_validator = function(program_name,routine_name_elem) {
    console.info("validating " + program_name + " " + routine_name_elem);
    if (program_name == routine_name_elem.defaultValue)
      return true;
    var url = "/users/" + $("#program_client").val() + "/programs/is_name_unique/" + program_name.toIdentifier();
    var unique = false;
    $.ajax({
      type: "GET",
      url: url,
      async: false,
      dataType:"json",
      success: function(msg)
      {
        unique = msg;
      }
    })
    return unique;
  }

  $.validator.addMethod("is_program_name_unique", program_name_validator, "Program name is already taken");
  $("#new_program").validate();

  if ($("#program_type").val() == "Weekday") {
    $("#scheduled-program").hide();
    $("#weekday-program").show();
  } else if ($("#program_type").val() == "Scheduled") {
    $("#weekday-program").hide();
    $("#scheduled-program").show();
  }

});
