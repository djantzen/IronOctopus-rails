$(document).ready(function() {

  var activity_name_validator = function(activity_name, activity_name_elem) {
    console.info("validating" + activity_name + " " + activity_name_elem);
    if (activity_name == activity_name_elem.defaultValue)
      return true;
    var url = "/activities/is_name_unique/" + activity_name.toIdentifier();
    var unique = false;
    $.ajax({
//      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
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

  var valid_activity_video_link = function(video_uri) {
    if (video_uri == null || video_uri === "") return true;
    console.log("validating " +  video_uri);
    youtube = new RegExp(/^http:\/\/www\.youtube\.com\/watch\?v=\w+$/);
    return video_uri.match(youtube) ? true : false;
  }

  $.validator.addMethod("is_activity_name_unique", activity_name_validator, "Activity name is already taken");
  $.validator.addMethod("valid_activity_video_link", valid_activity_video_link, "Should look like http://www.youtube.com/watch?v=k3Mvyt4pBQQ");

  $("#create-update-activity-form form").validate();

  // Deselect regions on page load with body parts deselected
  $("input.body-part:not(:checked)").each(function() {
      $(this).parents(".region-container").find("input.region").attr('checked', false);
  });

  // Body parts are selected if the region is deselected
  $("input.region").click(function() {
    var body_parts = $(this).parents(".region-container").find("input.body-part");
    if ($(this).is(':checked')) {
      body_parts.prop('checked', 'checked');
      body_parts.attr('checked', 'checked');
    } else {
      body_parts.prop('checked', "false");
      body_parts.removeAttr("checked");
    }
  });

  // Region is selected if all the body parts are selected
  $("input.body-part").click(function() {
    var region_container = $(this).parents(".region-container");
    var region = region_container.find("input.region");

    if ($(this).is(":not(:checked)"))
      region.attr('checked', false);
    else if (region_container.find("input.body-part:not(:checked)").size() == 0) {
      region.prop('checked', 'checked');
      region.attr('checked', 'checked');
    }

  });

});