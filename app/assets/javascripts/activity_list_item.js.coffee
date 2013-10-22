class this.ActivityListItem

  constructor: (@activity_set_form_template) ->
    @activity_set_form_template.click =>
      this.add_to_list()

    @activity_set_form_template.keyup (e) =>
      key = e.which
      activities = $(".activity.facet-included-activity")
      index = activities.index(@activity_set_form_template) # jquery prev/next don't work with dynamic filtered list
      if (key == ENTER_KEY)
        this.add_to_list()
        $("#activity-search-box").focus()
      else if (key == UP_ARROW_KEY || key == LEFT_ARROW_KEY)
        if index == 0
          $("#activity-search-box").focus()
        else
          activities.get(index - 1).focus()
      else if (key == DOWN_ARROW_KEY)
        if index == activities.length - 1
          activities.get(0).focus()
        else
          activities.get(index + 1).focus()

    return @activity_set_form_template

  add_to_list: () =>
    new_activity_set = @activity_set_form_template.find(".activity-set-form-template").clone()
    Util.show_flash("Added " + @activity_set_form_template.find("a:first").text() + " to the routine")
    new_activity_set.hide()
    new_activity_set.removeClass("activity-set-form-template")
    new_activity_set.addClass("activity-set-form")
    id = Util.generate_random_id()
    new_activity_set.find("a.accordion-toggle").attr("href", "#" + id)
    new_activity_set.find("div.accordion-body").attr("id", id)

    if ($("#open-activity-set-group").size() == 0)
      new_activity_group = $(".activity-set-group-template").clone()
      new_activity_group.hide()
      new_activity_group.removeClass("activity-set-group-template")
      new_activity_group.addClass("activity-set-group")
      new_activity_group.attr("id", "open-activity-set-group")
      $("#routine-activity-set-list").append(new_activity_group)
      new_activity_group.fadeIn()
      new ActivitySetGroup(new_activity_group)

    $("#open-activity-set-group").find(".grouped-activity-sets").append(new_activity_set)

    new_activity_set.fadeIn()
    new ActivitySetListItem(new_activity_set)
    return new_activity_set

class this.WorkActivityListItem extends ActivityListItem
  constructor: (@activity_set_form_template) ->
    super

  add_to_list: () =>
    new_activity_set = @activity_set_form_template.find(".activity-set-form-template").clone()
    Util.show_flash("Added " + @activity_set_form_template.find("a:first").text() + " to the routine")
    new_activity_set.hide()
    new_activity_set.removeClass("activity-set-form-template")
    new_activity_set.addClass("activity-set-form")
    id = Util.generate_random_id()
    new_activity_set.find("a.accordion-toggle").attr("href", "#" + id)
    new_activity_set.find("div.accordion-body").attr("id", id)
    $("#routine-activity-set-list").append(new_activity_set)
    new_activity_set.fadeIn()
    new WorkActivitySetListItem(new_activity_set)
    return new_activity_set

class this.ActivitySetGroup

  init_spinners: (activity_set_group_form) ->
    activity_set_group_form.find("input.spinner").spinner({ min: 0 })
    activity_set_group_form.find("input.timespinner").timespinner()

  init_finish_button: (activity_set_group_form) ->
    finish_group_button = @activity_set_group_form_template.find(".okay-activity-set-group-button")
    finish_group_button.click ->
      activity_set_group_form.attr("id", null)
      finish_group_button.remove()

  init_sorting: (activity_set_group_form) ->
    activity_set_group_form.find(".grouped-activity-sets").sortable({ handle: ".handle" }).disableSelection();

  # Pressing enter in the group name causes the delete button to get fired
  init_group_name: (activity_set_group_form) ->
    activity_set_group_form.find(".activity-set-group-name").keypress (e)->
      key = e.which
      if (key == ENTER_KEY)
        return false

  constructor: (@activity_set_group_form_template) ->
    this.init_spinners(@activity_set_group_form_template)
    this.init_finish_button(@activity_set_group_form_template)
    this.init_sorting(@activity_set_group_form_template)
    this.init_group_name(@activity_set_group_form_template)

class this.ActivitySetListItem

  destroy_spinners: (activity_set_form) ->
    activity_set_form.find("input.spinner").spinner("destroy")
    activity_set_form.find("input.timespinner").timespinner("destroy")

  init_spinners: (activity_set_form) ->
    activity_set_form.find("input.spinner").spinner({ min: 0 })
    activity_set_form.find("input.timespinner").timespinner()

  init_comments: (activity_set_form) ->
    form = activity_set_form.find(".activity-set-comments-form")
    form.hide()
    this.toggle_comment_button(activity_set_form)

  toggle_comment_button: (activity_set_form) ->
    form = activity_set_form.find(".activity-set-comments-form")
    button = activity_set_form.find(".activity-set-comments-button")
    if form.find("textarea").val() == ''
      button.removeClass("btn-primary")
    else
      button.addClass("btn-primary")

  init_stopwatch: (activity_set_form) ->
    input = activity_set_form.find("input.timespinner")
    target = input.val()
    input.stopwatch({format: "{MMM}:{ss}"})
    toggle = activity_set_form.find(".toggle-stopwatch-button")
    reset = activity_set_form.find(".reset-stopwatch-button")
    input.stopwatch().bind('tick.stopwatch', (e, elapsed) ->
      if (elapsed == digital_to_seconds(target) * 1000)
        $.playSound('http://ironoctop.us/beep-1.mp3'))

    toggle.click ->
      input.stopwatch("toggle")
      toggle.toggleClass("btn-primary")
      toggle.find("i").toggleClass("icon-start")
      toggle.find("i").toggleClass("icon-stop")
    reset.click ->
      input.val("000:00")
      input.stopwatch("reset")

  wrap_item: (activity_set_form) ->
    new ActivitySetListItem(activity_set_form)

  constructor: (@activity_set_form) ->
    remove_measure_buttons = @activity_set_form.find(".remove-measure-selector-button")
    delete_button = @activity_set_form.find(".delete-activity-set-button")
    okay_button = @activity_set_form.find(".okay-activity-set-button")
    clone_button = @activity_set_form.find(".clone-activity-set-button")
    measure_max_toggle_boxes = @activity_set_form.find(".measure-to-range-box")
    comments_button = @activity_set_form.find(".activity-set-comments-button")
    activity_set_group = @activity_set_form.parents(".activity-set-group")
    @activity_set_form.find(".has-tooltip-top").tooltip({ placement: "top", html: true });
    @activity_set_form.find(".has-tooltip-bottom").tooltip({ placement: "bottom", html: true });
    @activity_set_form.find(".has-tooltip-left").tooltip({ placement: "left", html: true });
    @activity_set_form.find(".has-tooltip-right").tooltip({placement: "right", html: true });

    this.init_spinners(@activity_set_form)
    this.init_stopwatch(@activity_set_form)
    this.init_comments(@activity_set_form)

    comments_button.click ->
      activity_set_form = $(this).parents(".activity-set-form")
      comments_form = activity_set_form.find(".activity-set-comments-form")
      if comments_form.isVisible()
        comments_form.hide("slow")
      else
        comments_form.show("slow")
      if comments_form.find("textarea").val() == ''
        $(this).removeClass("btn-primary")
      else
        $(this).addClass("btn-primary")

    measure_max_toggle_boxes.each ->
      input_controls = $(this).parents(".input-controls")
      measure_min_container = input_controls.find(".measure-min")
      measure_max_container = input_controls.find(".measure-max")

      max_greater = (input_controls) ->
        measure_min_container = input_controls.find(".measure-min")
        measure_max_container = input_controls.find(".measure-max")
        measure_min_val = measure_min_container.find("input").val()
        measure_max_val = measure_max_container.find("input").val()
        measure_min = if measure_min_val.match(DIGITAL_FORMAT) then digital_to_seconds(measure_min_val) else parseInt(measure_min_val)
        measure_max = if measure_max_val.match(DIGITAL_FORMAT) then digital_to_seconds(measure_max_val) else parseInt(measure_max_val)
        measure_max > measure_min

      $(this).change =>
        range_toggle_text = input_controls.find(".range-toggle-text")
        if $(this).is(':checked')
          range_toggle_text.hide()
          measure_max_container.show()
          unless max_greater(input_controls)
            measure_max_container.find("input").val(measure_min_container.find("input").val())
        else
          range_toggle_text.show()
          measure_max_container.hide()
          measure_max_container.find("input").val(measure_min_container.find("input").val())

      if max_greater(input_controls)
        $(this).prop("checked", true)
      else
        $(this).prop("checked", false)
      $(this).change()

    delete_button.click =>
      delete_button.tooltip("destroy") # tooltips hang around...
      activity_set_form = delete_button.parents(".activity-set-form")
      activity_set_form.hide("explode")
      activity_set_form.remove()
      unless activity_set_group.find(".grouped-activity-sets:has(*)").size() > 0
        activity_set_group.remove()

    okay_button.click =>
      okay_button.parents(".collapse").collapse("hide");

    clone_button.click =>
      original = clone_button.parents(".activity-set-form")
      # the spinner icons persist through a clone but are not functional and can't be removed after
      this.destroy_spinners(original)
      clone = original.clone()
      this.wrap_item(clone)
      this.init_spinners(original)
      id = Util.generate_random_id()
      clone.find("a.accordion-toggle").attr("href", "#" + id)
      clone.find("div.accordion-body").attr("id", id)

      original.find("select").each -> # copy over selected attributes since clone() doesn't
        clone.find("select[name='" + $(this).attr("name") + "']").val($(this).val())
      clone.hide();
      clone.insertAfter(original)
      clone.fadeIn();

    return @activity_set_form


class this.WorkActivitySetListItem extends ActivitySetListItem
  init_validator: (activity_set_form) =>
    form = activity_set_form.find("form.new_work")
    form.validate(
      submitHandler: (form_element) =>
        form = $(form_element)
        if (form.valid())
          $.ajax(
            type: form.attr('method')
            url: form.attr('action')
            data: form.serialize()
            success: () =>
              form.find(".collapse").collapse("hide")
              form.find(".performance-control-buttons").remove()
              form.find(".activity-set-done-label").show()
              @show_rest_timer()
          )
          return true
        return false
    )

  init_rest_timer: () ->
    rest_timer_modal = $("#rest-interval-timer").find("input").stopwatch({format: "{M}:{ss}"})

  show_rest_timer: () ->
    rest_interval = @activity_set_form.find(".rest-interval").text().trim()
    rest_timer_modal = $("#rest-interval-timer")
    if digital_to_seconds(rest_interval) > 0
      input = rest_timer_modal.find("input")
      input.val(rest_interval)
      $("#rest-for").text("Rest for " + rest_interval)
      input.stopwatch("start")
      rest_timer_modal.modal()
      setTimeout((->
        input.stopwatch("stop")
        input.stopwatch("reset")
        rest_timer_modal.modal("hide")), digital_to_seconds(rest_interval) * 1000)

  init_instructions: (activity_set_form) ->
    activity_set_form.find(".show-instructions").click () ->
      activity_set_form.find(".instructions-modal").modal();

  wrap_item: (activity_set_form) ->
    new WorkActivitySetListItem(activity_set_form)

  constructor: (@activity_set_form) ->
    super
    this.init_validator(@activity_set_form)
    this.init_instructions(@activity_set_form)
    @activity_set_form.find(".activity-set-done-label").hide();
    id = Util.generate_random_id()
    @activity_set_form.find("a.accordion-toggle").attr("href", "#" + id)
    @activity_set_form.find("div.accordion-body").attr("id", id)
    @init_rest_timer()