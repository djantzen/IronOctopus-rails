$(document).ready () ->

  $("#city-select").autocomplete({
    minLength: 3,
    source: (request, response)->
      $.ajax(
        type: "GET",
        async: false,
        dataType: "json",
        url: "/cities/search/" + $("#city-select").val(),
        success: (data)->
          response($.map(data.json, (item) ->
            return {
              label: item[0] + ", " + item[1],
              value: item[0] + ", " + item[1]
            }
          ))
      )
    }
  )

  $("#scores-by-day-start-date").datepicker(
    autoclose: true
  )

  $("#scores-by-day-end-date").datepicker(
    autoclose: true
  )

  init_scores_by_day_dates = () ->
    $('#scores-by-day-start-date').datepicker('update', moment().subtract('weeks', 2).calendar());
    $("#scores-by-day-end-date").datepicker('update', new Date());

  init_scores_by_day_dates()

  get_scores_by_day = () ->
    start_date = moment($("#scores-by-day-start-date").val())
    end_date = moment($("#scores-by-day-end-date").val())

    if start_date >= end_date
      init_scores_by_day_dates()
      get_scores_by_day()
      return

    url = window.location.pathname + "/scores_by_day?start_date=" +
          start_date.format("YYYY-MM-DD") + "&end_date=" + end_date.format("YYYY-MM-DD")
    $.ajax(
      type: "GET",
      url: url,
      async: true,
      dataType: "text",
      success: (msg) ->
        eval(msg)
    )

  $("#scores-by-date-show-button").click ->
    get_scores_by_day()

  $("#scores-by-date-show-button").click()

  is_login_unique = (login) ->
    url = "/users/is_login_unique/" + login
    unique = false;
    $.ajax(
      type: "GET",
      url: url,
      async: false,
      dataType: "json",
      success: (msg) ->
        unique = msg;
    )
    return unique;

  $.validator.addMethod("is_login_unique", is_login_unique, "Login taken, please select another");

  is_login_acceptable = (login) ->
    login_pattern = new RegExp(/^[a-z0-9_.]+$/)
    login.match(login_pattern)

  $.validator.addMethod("is_login_acceptable", is_login_acceptable, "Please create a single, lowercase login");

  # Bare ass bones validation. Should be beefed up
  is_email_acceptable = (email) ->
    email_pattern = new RegExp(/@/)
    email.match(email_pattern)

  $.validator.addMethod("is_email_acceptable", is_email_acceptable, "Please enter a valid email address");

  # Bare ass bones validation. Should be beefed up
  is_password_acceptable = (password) ->
    password.length == 0 || password.length > 7

  $.validator.addMethod("is_password_acceptable", is_password_acceptable, "Your password must be at least 8 characters long");

  passwords_match = (confirmation) ->
    password = $("#user_new_password").val();
    confirmation == password

  $.validator.addMethod("passwords_match", passwords_match, "Your passwords do not match")

  $("#new-user-form form").validate()
  $("#user-settings form").validate()
