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
    console.log("validating " +  video_uri);
    youtube = new RegExp(/^http:\/\/www\.youtube\.com\/watch\?v=\w+$/);
    return video_uri.match(youtube) ? true : false;
  }

  $.validator.addMethod("is_activity_name_unique", activity_name_validator, "Activity name is already taken");
  $.validator.addMethod("valid_activity_video_link", valid_activity_video_link, "Should look like http://www.youtube.com/watch?v=k3Mvyt4pBQQ");

  $("#create-update-activity-form form").validate();


});