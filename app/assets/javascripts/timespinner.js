$.widget( "ui.timespinner", $.ui.spinner, {
  options: {
    // seconds
    step: 1,
    min: 0,
    // minutes
    page: 60
  },

  _parse: function( value ) {
    if ( typeof value === "string" ) {
      return digital_to_seconds(value);
    } else {
      return value;
    }
  },

  _format: function( value ) {
    return seconds_to_digital(value)
  }

});
