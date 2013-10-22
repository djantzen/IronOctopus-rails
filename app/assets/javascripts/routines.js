$(document).ready(function() {

  $("#routine-activity-set-list").sortable({ handle: ".handle" })
    .disableSelection();

  var reset_activity_type_list = function() {
    $("#activity-type-list a.accordion-toggle").html("Type of Activity");
    $("#activity-type-list a.accordion-toggle").removeClass("facet-selected");
    $("#activity-type-list a.accordion-toggle").parents(".accordion-group").find(".facet").removeClass("facet-selected");
  }

  $("#activity-type-list a.accordion-toggle").click(function() {
    reset_activity_type_list();
    var narrowing_activities = false;
    update_facet_filtered_activities(narrowing_activities);
    update_facet_counts();
  });

  var routine_name_validator = function(routine_name, routine_name_elem) {
    console.info("validating " + routine_name + " " + routine_name_elem);
    if (routine_name == routine_name_elem.defaultValue)
      return true;
    var url = "/users/" + $("#routine_client").val() + "/routines/is_name_unique/" + routine_name.toIdentifier();
    var unique = false;
    $.ajax({
      type: "GET",
      url: url,
      async: false,
      dataType:"json",
      success: function(msg)
      {
        unique = msg;
      }
    })
    return unique;
  }

  $.validator.addMethod('positive_number',
    function (value) {
      return Number(value) >= 0;
    }, 'Enter a positive number.');

  var duration_validator = function(digital_time) {
    return (digital_time.match(DIGITAL_FORMAT) || digital_time.match(/^\d+$/)) ? true : false;
  }

  $.validator.addMethod("is_routine_name_unique", routine_name_validator, "Routine name is already taken");
  $.validator.addMethod("is_duration_valid", duration_validator, "MMM:SS or integer")

  $("#routine-form-panel form").validate();
  $(".activity-set-group").each(function() {
    new ActivitySetGroup($(this));
  });
  $(".activity.assigned").each(function() {
    new ActivityListItem($(this));
  });
  $(".activity.work").each(function() {
    new WorkActivityListItem($(this));
  });
  $(".activity-set-form.assigned").each(function() {
    new ActivitySetListItem($(this));
  });
  $(".activity-set-form.work").each(function() {
    new WorkActivitySetListItem($(this));
  });

  /*
   * Function for generating the key for a facet based on facet nodes. Will look for text within.
   * Join pattern defaults to the empty string but is regex string for facets (not facet-targets).
   */
  var generate_facet_key = function(facet_nodes, is_superkey) {
    var join_pattern = is_superkey ? "" : "\\w*?";
    var facets = [];
    facet_nodes.each(function() {
      var text = $(this).text() || $(this).val();

      text.trim().split(/\s+/).forEach(function(term) {
        facets.push(term.trim().toIdentifier());
      });
    });
    var facet_key = _.uniq(facets).sort().join(join_pattern);
    return facet_key;
  }

  /*
   * On page load generate a superkey for each activity
   */
  $("#activity-list .activity").each(function() {
    var facet_target_superkey = generate_facet_key($(this).find(".faceting-control"), true);
    var facet_target_superkey_node = $(document.createElement("span"));
    facet_target_superkey_node.append(facet_target_superkey);
    facet_target_superkey_node.addClass("faceting-control facet-target-superkey");
    $(this).append(facet_target_superkey_node);
  });

  $('.nav-tabs').button();

  $("#activity-search-box").keyup(function(e) {
    var key = e.which;
    if (key == DOWN_ARROW_KEY || key == RIGHT_ARROW_KEY)
      $(".activity.facet-included-activity:first").focus();
    else {
      var narrowing_results = ((key == BACKSPACE_KEY || key == DELETE_KEY)? false : true);
      update_facet_filtered_activities(narrowing_results);
      if (key == SPACE_KEY || $("#activity-search-box").val() == "")
        update_facet_counts();
    }

  });

  /*
   * Updates the list of activities after a facet has been added or removed
   */
  var update_facet_filtered_activities = function(narrowing_results) {

    facet_nodes = $("#activity-search-box").add($("#activity-facets-panel div.facet-selected .faceting-control"));
    facet_key = new RegExp(generate_facet_key(facet_nodes, false));

    // Only examine activities that might change as a result of the facet addition or removal.
    var activities = narrowing_results ? $("#activity-list .facet-included-activity"):
      $("#activity-list .facet-excluded-activity");

    activities.each(function() {
      var activity = $(this);
      var facet_target_superkey = activity.find("span.facet-target-superkey").text();

      if (facet_target_superkey.match(facet_key)) {
//          console.info("MATCH for " + facet_key + " facet superkey " + facet_target_superkey);
        activity.removeClass("facet-excluded-activity");
        activity.addClass("facet-included-activity");
      } else {
//          console.info("no match for " + facet_key + " facet superkey " + facet_target_superkey);
        activity.removeClass("facet-included-activity");
        activity.addClass("facet-excluded-activity");
      }
    });
  }

  $("#activity-type-list .facet").click(function() {
    $(this).parents(".collapse").collapse("hide");
    var facet = $(this).find("a").text();
    $(this).parents(".accordion-group").find("a.accordion-toggle").html(facet);
    $(this).parents(".accordion-group").find("a.accordion-toggle").addClass("facet-selected");
  });

  $(".new_work").find(".collapse").collapse("hide");

  /*
  When a facet is chosen, loop over all facets and for each loop over all activities and increment count
   */
  var update_facet_counts = function() {
    var facet_included_activities = $("#activity-list .facet-included-activity");
    var faceting_controls = $("#activity-facets-panel .faceting-control");

    faceting_controls.each(function() {

      facet_control = $(this);
      facet_key = new RegExp(generate_facet_key($(this), false));
      var facet_count = 0;

      facet_included_activities.each(function() {
        var activity = $(this);
        var facet_target_superkey = activity.find("span.facet-target-superkey").text();
        if (facet_target_superkey.match(facet_key)) {
          facet_count++;
        }
      });
      facet_control.parents(".facet").find(".facet-count").html("(" + facet_count + ")");

    });


  }

  /*
   * When a facet is added or removed, apply CSS
   */
  $("#activity-facets-panel .facet").click(function() {
    var narrowing_results = true;
    if ($(this).hasClass("facet-selected")) {
      var id = $(this).find("a").attr("id");
      $("#selected-facet-list").find("#facet-selected-" + id).parents(".facet-selected").remove();
      $(this).removeClass("facet-selected");
      narrowing_results = false;
    } else {
      $(this).addClass("facet-selected");
      if (!$(this).hasClass("activity-type")) {
        var clone = $(this).clone();
        var id = $(this).find("a").attr("id");
        clone.find("a").attr("id", "facet-selected-" + id);

        $("#selected-facet-list").append(clone);
        $("#selected-facet-list").find("#facet-selected-" + id).click(function() {
          $(this).parents(".facet-selected").remove();
          var elem = $("#activity-facets-panel .facet").find("#" + id);
          elem.click();
        });
      }
    }
    if ($("#selected-facet-list div").length > 0) {
      $("#applied-filters-label").show("slow");
    } else {
      $("#applied-filters-label").hide("slow");
    }
    update_facet_filtered_activities(narrowing_results);
    update_facet_counts();
  });
  $("#applied-filters-label").hide();

  $("#new-activity-button").click(function() {
    var container = $(this).parents("#routine-builder-panel");
    var modal = container.find(".modal-activity-select");
    modal.modal("hide");
    $("#modal-activity-builder").modal();
  });

  $("#import-routine-button").click(function() {
    $("#modal-import-routine").modal();
  });

  // Disable enter key since it somehow calls delete on the first activity set
  $("#new_routine input").keypress(function(e) {
    key = e.which;
    if (key == ENTER_KEY) {
      return false;
    }
  })

  $("#import-routine-submit-button").click(function() {
    var routine = $("#routines-for-client-dropdown").val();
    var url = "/users/" + $("#client-for-routines-dropdown").val() +
              "/routines/" + routine.toIdentifier() + "/activity_sets.js";
    $.ajax({
      type: "GET",
      url: url,
      async: false,
      dataType: "text",
      error: function(msg) {
        console.log("error parsing %o", msg);
        Util.show_flash("Unable to import activity sets from " + routine, 3000);
      },
      success: function(msg)
      {
        eval(msg);
        Util.show_flash("Imported activity sets from " + routine, 3000);
      }
    })
    $("#modal-import-routine").modal('hide');
  });

  $("#client-for-routines-dropdown").change(function() {
    var login = $(this).val();
    var url = "/users/" + login + "/routines.js";
    $.ajax({
      type: "GET",
      url: url,
      async: false,
      dataType: "text",
      success: function(msg) {
        eval(msg);
      },
      error: function(msg) {
        console.log("error parsing %o", msg);
      }
    })
  });

  $("#client-for-routines-dropdown").change();

  var clear_activity_form = function() {
    $("#create-update-activity-form form")[0].reset();
    // reset doesn't clear nested checkboxes...
    $("#create-update-activity-form form:nth(0)").find("input:checkbox").removeAttr("checked");
  }

  $("#modal-activity-builder form").bind('ajax:complete', function() {
    $("#modal-activity-builder").modal('hide');
    clear_activity_form();
  });

  $("#cancel-activity-builder-button").click(function() {
    $("#modal-activity-builder").modal('hide');
    clear_activity_form();
  });

  var clear_selections = function() {
    $("#activity-facets-panel").find(".ui-state-active").each(function() {
      $(this).removeClass("ui-state-active");
    });
    reset_activity_type_list();
    update_facet_filtered_activities(false);
    $("#activity-type-list .collapse").collapse("show");
    $("#body-part-list .collapse").collapse("hide");
    $("#implement-list .collapse").collapse("hide");
    $("#activity-attribute-list .collapse").collapse("hide");
    //    $("#activity-search-box").val("");
//   $("#clear-selections").hide();
  };

  $("#clear-selections").click(function() {
    clear_selections();
  });

  clear_selections();
  update_facet_counts();
});