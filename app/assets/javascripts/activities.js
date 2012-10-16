$(document).ready(function() {

  var activity_name_validator = function(activity_name, activity_name_elem) {
    console.info("validating" + activity_name + " " + activity_name_elem);
    if (activity_name == activity_name_elem.defaultValue)
      return true;
    var url = "/activities/is_name_unique/" + activity_name.toIdentifier();
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

  $.validator.addMethod("is_activity_name_unique", activity_name_validator, "Activity name is already taken");

  $("#create-update-activity-form form").validate();

});