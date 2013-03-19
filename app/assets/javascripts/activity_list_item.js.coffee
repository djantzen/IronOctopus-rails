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
    new_activity_set.show("puff")
    new ActivitySetListItem(new_activity_set)
    return new_activity_set

class this.ActivitySetListItem

  destroy_spinners: (activity_set_form) ->
    activity_set_form.find("input.spinner").spinner("destroy")
    activity_set_form.find("input.timespinner").timespinner("destroy")

  init_spinners: (activity_set_form) ->
    activity_set_form.find("input.spinner").spinner({ min: 0 })
    activity_set_form.find("input.timespinner").timespinner()

  init_stopwatch: (activity_set_form) ->
    input = activity_set_form.find("input.timespinner")
    input.stopwatch({format: "{MMM}:{ss}"})
    toggle = activity_set_form.find(".toggle-stopwatch-button")

    toggle.click ->
      input.stopwatch("toggle")
      toggle.toggleClass("btn-primary")
      toggle.find("i").toggleClass("icon-start")
      toggle.find("i").toggleClass("icon-stop")

  constructor: (@activity_set_form) ->
    @activity_set_form.find(".remove-measure-selector-button").click ->
      $(this).parents(".measure-selector").remove()

    delete_button = @activity_set_form.find(".delete-activity-set-button")
    okay_button = @activity_set_form.find(".okay-activity-set-button")
    clone_button = @activity_set_form.find(".clone-activity-set-button")

    this.init_spinners(@activity_set_form)
    this.init_stopwatch(@activity_set_form)

    delete_button.click =>
      activity_set_form = delete_button.parents("div.activity-set-form")
      activity_set_form.hide("explode")
      activity_set_form.remove()

    okay_button.click =>
      okay_button.parents(".collapse").collapse("hide");

    clone_button.click =>
      original = clone_button.parents("div.activity-set-form")
      # the spinner icons persist through a clone but are not functional and can't be removed after
      this.destroy_spinners(original)
      clone = new ActivitySetListItem(original.clone())
      this.init_spinners(original)
      id = Util.generate_random_id()
      clone.find("a.accordion-toggle").attr("href", "#" + id)
      clone.find("div.accordion-body").attr("id", id)
      original.find("select").each -> # copy over selected attributes since clone() doesn't
        clone.find("select[name='" + $(this).attr("name") + "']").val($(this).attr("value"))
      clone.hide();
      clone.insertAfter(original)
      clone.show("puff");


    return @activity_set_form
