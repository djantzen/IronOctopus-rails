$(document).ready(function() {

  var implement_name_validator = function(implement_name, implement_name_elem) {
    console.info("validating" + implement_name + " " + implement_name_elem);
    if (implement_name == implement_name_elem.defaultValue)
      return true;
    var url = "/implements/is_name_unique/" + implement_name.toIdentifier();
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

  $.validator.addMethod("is_implement_name_unique", implement_name_validator, "Implement name is already taken");

  $("#create-update-implement-form form").validate();

});

