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
//= require bootstrap-datepicker
//= require moment


console.info("application load");

google.load('visualization', '1', {packages:['corechart']});

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

var DIGITAL_FORMAT = new RegExp(/^\d{1,3}:\d{1,2}$/);
var LEFT_ARROW_KEY = 37;
var UP_ARROW_KEY = 38;
var RIGHT_ARROW_KEY = 39;
var DOWN_ARROW_KEY = 40;
var BACKSPACE_KEY = 8;
var ENTER_KEY = 13;
var ESC_KEY = 27;
var DELETE_KEY = 46;
var SPACE_KEY = 32;
var digital_to_seconds = function(digital) {
  if (!digital.match(DIGITAL_FORMAT)) {
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

jQuery.fn.isVisible = function() {
  return this.css('display') != 'none';
}

jQuery.fn.visible = function() {
  return this.css('visibility', 'visible');
}

jQuery.fn.invisible = function() {
  return this.css('visibility', 'hidden');
}

jQuery.fn.visibilityToggle = function() {
  return this.css('visibility', function(i, visibility) {
    return (visibility == 'visible') ? 'hidden' : 'visible';
  });
}

var get_chart_data = function(chart_container, url, params) {

  chart_container.find(".chart-container").html("");
  chart_container.find(".loading-indicator").show();

  // http://zargony.com/2012/02/29/google-charts-on-your-site-the-unobtrusive-way
  $.getJSON(url, params, function (data) {
    // Create DataTable from received chart data
    var table = new google.visualization.DataTable();
    $.each(data.cols, function () { table.addColumn.apply(table, this); });
    table.addRows(data.rows);
    // Draw the chart
    var chart = new google.visualization.ChartWrapper();
    chart.setChartType(data.type);
    chart.setDataTable(table);
    chart.setOptions(data.options);
    chart.setOption('width', chart_container.width());
    chart.setOption('height', chart_container.height());
    chart_container.find(".loading-indicator").hide();
    chart.draw(chart_container.find(".chart-container")[0]);
  });

}

$(document).ready(function() {
  $(".has-tooltip-top").tooltip({ placement: "top", html: true });
  $(".has-tooltip-bottom").tooltip({ placement: "bottom", html: true });
  $(".has-tooltip-left").tooltip({ placement: "left", html: true });
  $(".has-tooltip-right").tooltip({placement: "right", html: true });

  var flash_content = $("#flash").html().trim();
  if (flash_content.length > 0) {
    Util.show_flash(flash_content);
  }

  // Google Analytics
  if (document.location.hostname.search("ironoctop.us") !== -1) {
    (function (i, s, o, g, r, a, m) {
      i['GoogleAnalyticsObject'] = r;
      i[r] = i[r] || function () {
        (i[r].q = i[r].q || []).push(arguments)
      }, i[r].l = 1 * new Date();
      a = s.createElement(o),
        m = s.getElementsByTagName(o)[0];
      a.async = 1;
      a.src = g;
      m.parentNode.insertBefore(a, m)
    })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

    ga('create', 'UA-41971719-1', 'ironoctop.us');
    ga('send', 'pageview');
  }
  // End Google Analytics

});