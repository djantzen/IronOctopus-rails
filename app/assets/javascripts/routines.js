$(document).ready(function() {

  $("#routine-activity-set-list").sortable({ handle: ".handle" })
    .disableSelection();

  var reset_activity_type_list = function() {
    $("#activity-type-list a.accordion-toggle").html("Type of Activity");
    $("#activity-type-list a.accordion-toggle").removeClass("ui-state-active");
    $("#activity-type-list a.accordion-toggle").parents(".accordion-group").find(".facet").removeClass("ui-state-active");
  }

  $("#activity-type-list a.accordion-toggle").click(function() {
    reset_activity_type_list();
    update_facet_filtered_activities(false);
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

  var duration_validator = function(digital_time) {
    return (digital_time.match(DIGITAL_FORMAT) || digital_time.match(/^\d+$/)) ? true : false;
  }

  $.validator.addMethod("is_routine_name_unique", routine_name_validator, "Routine name is already taken");
  $.validator.addMethod("is_duration_valid", duration_validator, "MMM:SS or integer")

  $("#routine-form-panel form").validate();

  $(".activity").each(function() {
    new ActivityListItem($(this));
  });
  $(".activity-set-form").each(function() {
    new ActivitySetListItem($(this));
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
   * On page load generate a superkey for each activity and bind actions to activity set templates
   */
  $("#activity-list .activity").each(function() {
    var facet_target_superkey = generate_facet_key($(this).find(".faceting-control"), true);
    var facet_target_superkey_node = $(document.createElement("span"));
    facet_target_superkey_node.append(facet_target_superkey);
    facet_target_superkey_node.addClass("faceting-control facet-target-superkey");
    $(this).append(facet_target_superkey_node);
  });

  var clear_selections = function() {
    $("#activity-facets-panel").find(".ui-state-active").each(function() {
        $(this).removeClass("ui-state-active");
    });
    reset_activity_type_list();
    //TODO make resets for each one since this is duplicate
    update_facet_filtered_activities(false);
    $("#activity-type-list .collapse").collapse("show");
    $("#body-part-list .collapse").collapse("hide");
    $("#implement-list .collapse").collapse("hide");
    $("#activity-attribute-list .collapse").collapse("hide");
    $("#clear-selections").hide();
  };

  $("#clear-selections").click(function() {
    clear_selections();
  });

  $('.nav-tabs').button();

  var search_facet_filtered_activities = function(search_box) {
    var facet_key = new RegExp(generate_facet_key($("#activity-search-box"), false));
    var activities = $("#activity-list .facet-included-activity");

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

  /*
   * Updates the list of activities after a facet has been added or removed
   */
  var update_facet_filtered_activities = function(restrict_results) {

    // Get the key describing currently selected facets
    var facet_key = new RegExp(generate_facet_key($("#activity-facets-panel div.ui-state-active .faceting-control"), false));
    // Only examine activities that might change as a result of the facet addition or removal.
    var activities = restrict_results ? $("#activity-list .facet-included-activity"):
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
    $(this).parents(".accordion-group").find("a.accordion-toggle").addClass("ui-state-active");
  });

  /*
   * When a facet is added or removed, apply CSS
   */
  $("#activity-facets-panel .facet").click(function() {
    var restrict_results = true;
    if ($(this).hasClass("ui-state-active")) {
      $(this).removeClass("ui-state-active");
      restrict_results = false;
    } else {
      $(this).addClass("ui-state-active");
    }
    update_facet_filtered_activities(restrict_results);
    $("#clear-selections").show();
  });

  $("#activity-search-box").keyup(function() {
      clear_selections();
      search_facet_filtered_activities($("#activity-search-box"));
  });

//  $(".perform-activity-set-button").click(function() {
////    $(this).remove();
////    $(this).parents(".collapse").collapse("hide");
//    var form = $(this).parents("form");
//    form.submit();
//    return false;
//  });

  $(".skip-activity-set-button").click(function() {
    $(this).parents("form").remove();
    return false;
  });

  $(".new-activity-button").click(function() {
    var container = $(this).parents("#routine-builder-panel");
    var modal = container.find(".modal-activity-select");
    modal.modal("hide");
    $("#modal-activity-builder").modal();
  });

  var clear_activity_form = function() {
    $("#create-update-activity-form form")[0].reset();
  }

  $("#modal-activity-builder form").bind('ajax:complete', function() {
    $("#modal-activity-builder").modal('hide');
    clear_activity_form();
  });

  $("#cancel-activity-builder-button").click(function() {
    $("#modal-activity-builder").modal('hide');
    clear_activity_form();
  });
  clear_selections();
});