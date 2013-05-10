class this.ActivityListItem

  constructor: (@activity_set_form_template) ->
    @activity_set_form_template.click =>
      this.add_to_list()
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
    $("#routine-activity-set-list").append(new_activity_set)
    new_activity_set.fadeIn()
    this.wrap_item(new_activity_set)
    return new_activity_set

  wrap_item: (new_activity_set) =>
    new ActivitySetListItem(new_activity_set)


class this.WorkActivityListItem extends ActivityListItem
  constructor: (@activity_set_form_template) ->
    super

  wrap_item: (new_activity_set) =>
    new WorkActivitySetListItem(new_activity_set)


class this.ActivitySetListItem

  destroy_spinners: (activity_set_form) ->
    activity_set_form.find("input.spinner").spinner("destroy")
    activity_set_form.find("input.timespinner").timespinner("destroy")

  init_spinners: (activity_set_form) ->
    activity_set_form.find("input.spinner").spinner({ min: 0 })
    activity_set_form.find("input.timespinner").timespinner()

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

    this.init_spinners(@activity_set_form)
    this.init_stopwatch(@activity_set_form)

    #  @activity_set_form.find(".remove-measure-selector-button").click ->
    #  $(this).parents(".measure-selector").remove()
    # why do we have to iterate on this one?
    remove_measure_buttons.each ->
      $(this).click =>
        selector = $(this).parents(".measure-selector")
        selector.remove()

    delete_button.click =>
      activity_set_form = delete_button.parents(".activity-set-form")
      activity_set_form.hide("explode")
      activity_set_form.remove()

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
        clone.find("select[name='" + $(this).attr("name") + "']").val($(this).attr("value"))
      clone.hide();
      clone.insertAfter(original)
      clone.fadeIn();

    return @activity_set_form


class this.WorkActivitySetListItem extends ActivitySetListItem
  init_validator: (activity_set_form) ->
    form = activity_set_form.find("form.new_work")
    form.validate(
      submitHandler: (form_element) ->
        form = $(form_element)
        console.log("submit")
        if (form.valid())
          $.ajax(
            type: form.attr('method')
            url: form.attr('action')
            data: form.serialize()
            success: () ->
              form.find(".collapse").collapse("hide")
          )
          return true
        return false
    )

  init_instructions: (activity_set_form) ->
    activity_set_form.find(".show-instructions").click () ->
      $(this).find(".instructions-modal").modal();

  wrap_item: (activity_set_form) ->
    new WorkActivitySetListItem(activity_set_form)

  constructor: (@activity_set_form) ->
    super
    this.init_validator(@activity_set_form)
    this.init_instructions(@activity_set_form)

