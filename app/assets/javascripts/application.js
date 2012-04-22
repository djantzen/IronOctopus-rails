// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

console.info("applicationload");

var to_identifier_regexp = new RegExp("[\\s(){}\"_'\-]", "g");
String.prototype.toIdentifier = function() {
  return this.replace(to_identifier_regexp, '').toLowerCase();
};