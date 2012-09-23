$(document).ready(function() {

    $("#routine-activity-set-list").sortable({ handle: ".handle" })
      .disableSelection();

    $("#routine-activity-set-list form").validate();

    $("#collapse-activity-set-button").click(function() {
      $(".collapse").collapse("toggle");
    });

    $(".okay-activity-set-button").click(function() {
      $(this).parents(".collapse").collapse("hide");
    });


    $(".activity").click(function() {
      var new_activity_set = $(this).find(".activity-set-form-template").clone(true);
      new_activity_set.hide();
      new_activity_set.removeClass("activity-set-form-template");
      new_activity_set.addClass("activity-set-form");
      var id = generate_random_id();
      new_activity_set.find("a.accordion-toggle").attr("href", "#" + id);
      new_activity_set.find("div.accordion-body").attr("id", id);
      $("#routine-activity-set-list").append(new_activity_set);
      new_activity_set.show("slow");
    });

    var generate_random_id = function() {
      return Math.round(Math.random()*10000);
    }

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
        update_facet_filtered_activities(false);
    };

    $(".clear-selections").click(function() {
        clear_selections();
    });

  $('.nav-tabs').button();

    // wire up the delete button
    $(".delete-activity-set-button").click(function() {
      var activity_set_form = $(this).parents("div.activity-set-form");
      activity_set_form.remove();
    });
    // wire up the clone button
    $(".clone-activity-set-button").click(function() {
      var original = $(this).parents("div.activity-set-form");
      var clone = original.clone(true);
      var id = generate_random_id();
      clone.find("a.accordion-toggle").attr("href", "#" + id);
      clone.find("div.accordion-body").attr("id", id);
      original.find("select").each(function() { // copy over selected attributes since clone() doesn't
        clone.find("select[name='" + $(this).attr("name") + "']").val($(this).attr("value"));
      });
      clone.insertAfter(original);
    });

    var search_facet_filtered_activities = function(search_box) {
        var facet_key = new RegExp(generate_facet_key($("#activity-search-box"), false));
        var activities = $("#activity-list div.facet-included-activity");

        activities.each(function() {
            var activity = $(this);
            var facet_target_superkey = activity.find("span.facet-target-superkey").text();

            if (facet_target_superkey.match(facet_key)) {
//                console.info("MATCH for " + facet_key + " facet superkey " + facet_target_superkey);
                activity.removeClass("facet-excluded-activity");
                activity.addClass("facet-included-activity");
            } else {
//                console.info("no match for " + facet_key + " facet superkey " + facet_target_superkey);
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

    /*
     * When a facet is added or removed, apply CSS
     */
    $("#activity-facets-panel .facet").click(function() {
      var facet_name = $(this).find(".faceting-control").text().trim();
      var restrict_results = true;
      if ($(this).hasClass("ui-state-active")) {
        $(this).removeClass("ui-state-active");
        restrict_results = false;
      } else {
        $(this).addClass("ui-state-active");
      }
      update_facet_filtered_activities(restrict_results);
    });

    $("#activity-search-box").keyup(function() {
        clear_selections();
        search_facet_filtered_activities($("#activity-search-box"));
    });

    $(".increment").click(function() {
      var measure_selector_node = $(this).parents("div.measure_selector");
      var measure_node = measure_selector_node.find(".measure");
      var measure = parseFloat(measure_node.val());
      var interval = parseFloat(measure_selector_node.find("span.measure_interval").text());
      console.info(measure + interval);
      measure_node.val(measure + interval);
    });

    $(".decrement").click(function() {
      var measure_selector_node = $(this).parents("div.measure_selector");
      var measure_node = measure_selector_node.find(".measure");
      var measure = parseFloat(measure_node.val());
      var interval = parseFloat(measure_selector_node.find("span.measure_interval").text());
      console.info(measure - interval);
      measure_node.val(measure - interval);
    });

    $(".perform-activity-set-button").click(function() {
        var form = $(this).parents("form");
        form.hide(1000);
        form.submit();
        form.remove();
        return false;
    });
});