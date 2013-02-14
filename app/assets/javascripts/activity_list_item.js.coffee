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
  constructor: (@activity_set_form) ->


    @activity_set_form.find(".remove-measure-selector-button").click ->
#      debugger
      $(this).parents(".measure-selector").remove()

    delete_button = @activity_set_form.find(".delete-activity-set-button")
    okay_button = @activity_set_form.find(".okay-activity-set-button")
    clone_button = @activity_set_form.find(".clone-activity-set-button")
    try
      # the spinner icons persist through a clone but can't be easily removed.
      # try/catch this because on the first load there won't be a spnner to destroy.
      @activity_set_form.find("input.measure").spinner("destroy");
    catch error

    @activity_set_form.find("input.measure").spinner();

    delete_button.click =>
      activity_set_form = delete_button.parents("div.activity-set-form")
      activity_set_form.hide("explode")
      activity_set_form.remove()

    okay_button.click =>
      okay_button.parents(".collapse").collapse("hide");

    clone_button.click =>
      original = clone_button.parents("div.activity-set-form")
      try
        # the spinner icons persist through a clone but can't be easily removed
        # try/catch this because on the first load there won't be a spnner to destroy.
        original.find("input.measure").spinner("destroy");
      catch error

      clone = new ActivitySetListItem(original.clone())
      original.find("input.measure").spinner();
      id = Util.generate_random_id()
      clone.find("a.accordion-toggle").attr("href", "#" + id)
      clone.find("div.accordion-body").attr("id", id)
      original.find("select").each -> # copy over selected attributes since clone() doesn't
        clone.find("select[name='" + $(this).attr("name") + "']").val($(this).attr("value"))
      clone.hide();
      clone.insertAfter(original)
      clone.show("puff");


    return @activity_set_form
