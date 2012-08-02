//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready(function() {

    $("#new-feedback-button").click(function() {
        $("#new-feedback-form").dialog({ dialogClass: "new-feedback-form-dialog", height: 300, width: 450 });
    });

    $("#new-feedback-form form").bind('ajax:complete', function() {
        $("#new-feedback-form").dialog("close");
        $("#new-feedback-form textarea").val(null);
    });

});