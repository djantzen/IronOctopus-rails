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



$(document).ready(function() {
  $(".has-tooltip").tooltip({ delay: 500 });
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