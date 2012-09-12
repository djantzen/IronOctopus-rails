//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready(function() {

    $("#new-feedback-button").click(function() {
        $("#new-feedback-form").modal();
    });


    $("#new-feedback-form form").bind('ajax:complete', function() {
        $("#new-feedback-form").modal('hide');
        $("#new-feedback-form textarea").val(null);
    });

    $("#cancel-feedback-button").click(function() {
        $("#new-feedback-form textarea").val(null);
    });
});