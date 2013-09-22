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

  $(".chart-start-date, .chart-end-date").datepicker(
    autoclose: true
  )

  init_scores_by_day_dates = () ->
    $("#scores-by-day-search-panel .chart-start-date").datepicker('update', moment().subtract('weeks', 1).calendar());
    $("#scores-by-day-search-panel .chart-end-date").datepicker('update', new Date());

  init_scores_by_day_dates()

  get_scores_by_day = () ->
    start_date = moment($("#scores-by-day-search-panel .chart-start-date").val())
    end_date = moment($("#scores-by-day-search-panel .chart-end-date").val())

    if start_date >= end_date
      init_scores_by_day_dates()
      get_scores_by_day()
      return

    url = window.location.pathname + "/scores_by_day"
    params = { "start_date": start_date.format("YYYY-MM-DD"), "end_date": end_date.format("YYYY-MM-DD") }
    Charts.fetch_data($("#scores-by-day-display-panel"), url, params)

  init_activity_type_breakdown_by_day_dates = () ->
    $("#activity-type-breakdown-by-day-search-panel .chart-start-date").datepicker('update', moment().subtract('weeks', 1).calendar());
    $("#activity-type-breakdown-by-day-search-panel .chart-end-date").datepicker('update', new Date());

  init_activity_type_breakdown_by_day_dates()

  get_activity_type_breakdown_by_day = () ->
    start_date = moment($("#activity-type-breakdown-by-day-search-panel .chart-start-date").val())
    end_date = moment($("#activity-type-breakdown-by-day-search-panel .chart-end-date").val())

    if start_date >= end_date
      init_activity_type_breakdown_by_day_dates()
      get_activity_type_breakdown_by_day()
      return

    url = window.location.pathname + "/activity_type_breakdown_by_day"
    params = { "start_date": start_date.format("YYYY-MM-DD"), "end_date": end_date.format("YYYY-MM-DD") }
    Charts.fetch_data($("#activity-type-breakdown-by-day-display-panel"), url, params)

  get_activity_score = () ->
    url = window.location.pathname + "/activity_level_by_day"
    Charts.fetch_data($("#activity-score-display-panel"), url)

  $("#scores-by-day-show-button").click ->
    get_scores_by_day()
  $("#activity-type-breakdown-by-day-show-button").click ->
    get_activity_type_breakdown_by_day()

  $("#scores-by-day-show-button").click()
  $("#activity-type-breakdown-by-day-show-button").click()
  if $("#activity-score-display-panel").size() == 1
    get_activity_score()

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
