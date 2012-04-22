$(document).ready(function() {
    
    $("#activity-sets").sortable({ handle: ".handle" })
      .disableSelection()
        .selectable({ filter: ".activity-set-form", // make sure not to mark every child as selected
                      selected: function(event, ui) { console.info($(this));
                      }
                    }); 

    $(".activity").click(function() {
      var new_activity_set = $(this).find(".activity-set-form-template").clone(true);
      new_activity_set.removeClass("activity-set-form-template");
      new_activity_set.addClass("activity-set-form");
      $("#activity-sets").append(new_activity_set);
    });

    /*
     * Function for generating the key for a facet based on facet nodes. Will look for text within.
     * Join pattern defaults to the empty string but is regex string for facets (not facet-targets).
     */
    var generate_facet_key = function(facet_nodes, is_superkey) {
      var join_pattern = is_superkey ? "" : "\\w*?";
      var facets = [];
      facet_nodes.each(function() {
        facets.push($(this).text().trim());
      });

      var facet_key = facets.sort().join(join_pattern).toIdentifier();
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
    
        // wire up the delete button        
        $(this).find(".activity-set-form-template .delete-activity-set-button").click(function() {
          $(this).parent().remove();
        });
        // wire up the clone button
        $(this).find(".activity-set-form-template .clone-activity-set-button").click(function() {
          var original = $(this).parent();
          var clone = original.clone(true);
          original.find("select").each(function() { // copy over selected attributes since clone() doesn't
            clone.find("select[name='" + $(this).attr("name") + "']").val($(this).attr("value"));
          });
          clone.insertAfter(original);
        });
    
    });
    
    /*
     * Updates the list of activities after a facet has been added or removed
     */
    var update_facet_filtered_activities = function(restrict_results) {
      
      // Get the key describing currently selected facets  
      var facet_key = new RegExp(generate_facet_key($("#activity-facets-panel div.facet-selected .faceting-control"), false));
      // Only examine activities that might change as a result of the facet addition or removal.
      var activities = restrict_results ? $("#activity-list .facet-included-activity"):
        $("#activity-list .facet-excluded-activity");

      activities.each(function() {
        var activity = $(this);
        var facet_target_superkey = activity.find("span.facet-target-superkey").text();
        
        if (facet_target_superkey.match(facet_key)) {
          console.info("MATCH for " + facet_key + " facet superkey " + facet_target_superkey);
          activity.removeClass("facet-excluded-activity");
          activity.addClass("facet-included-activity");
        } else {
          console.info("no match for " + facet_key + " facet superkey " + facet_target_superkey);
          activity.removeClass("facet-included-activity");
          activity.addClass("facet-excluded-activity");
        }
      });
    }

    /*
     * When a facet is added or removed, apply CSS
     */
    $("#activity-facets-panel div.facet").click(function() {
      var facet_name = $(this).find(".faceting-control").text().trim();
      var restrict_results = true;
      if ($(this).hasClass("facet-selected")) {
        $(this).removeClass("facet-selected");
        restrict_results = false;
      } else {
        $(this).addClass("facet-selected");
      }
      update_facet_filtered_activities(restrict_results);
    });

});