// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree
//= require bootstrap
//= require underscore
//= require modernizr

console.info("application load");

//var to_identifier_regexp = new RegExp("[\\s(){}\"_'\-]", "g");
var to_identifier_regexp = new RegExp("[^a-zA-Z0-9]", "g");
String.prototype.toIdentifier = function() {
  return this.replace(to_identifier_regexp, '').toLowerCase();
};

var seconds_to_digital = function(seconds) {
  var format = "%03d:%02d"
  var digital = null;

  if (seconds <= 60) {
    digital = sprintf(format, 0, seconds);
  } else {
    var minutes = seconds / 60;
    var remaining_seconds = seconds % 60;
    digital = sprintf(format, minutes, remaining_seconds);
  }
  return digital;
}

var digital_to_seconds = function(digital) {
  var p = new RegExp(/^\d{1,3}:\d{1,2}$/);
  if (!digital.match(p)) {
    return 0
  }
  var minutes = parseInt(digital.split(':')[0])
  var seconds = parseInt(digital.split(':')[1])
  var in_seconds = (minutes * 60) + seconds;
  return in_seconds;
}

var Flasher = function() {
  var f = function() { alert("flash") };
  flash: f
}

$(document).ready(function() {
  $(".has-tooltip").tooltip({ delay: { show: 500, hide: 100 }});
  $(".has-tooltip-bottom").tooltip({ delay: 500, placement: "bottom" });
  $(".has-tooltip-left").tooltip({ delay: 500, placement: "left" });
  $(".has-tooltip-right").tooltip({ delay: 500, placement: "right" });



//  yepnope({
//    test: Modernizr.inputtypes.email && Modernizr.input.required && Modernizr.input.placeholder && Modernizr.input.pattern,
//    test: Modernizr.inputtypes.number,
//    nope: 'h5f.js',
//    callback: function(url, result, key) {
//      H5F.setup(document.getElementById('edit_routine_154786800'));
//    }
//  });
});