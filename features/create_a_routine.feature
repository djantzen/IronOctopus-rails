Feature: Create a new routine
  As a logged in user
  I want to create a new routine
  so that my client is trained properly
  
  Scenario: Creation of a new routine
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    Then I should see "Routine Name"
    When I fill in "Routine Name" with "New Test Routine"
    And I fill in "Routine Goal" with "Do New Test Routine this way not that way"
    And I press "save-routine"
    Then I should see "New Test Routine"
    And I should see "Created by Bob Trainer"

  Scenario: Creation of a new routine with too short a name
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    When I fill in "Routine Name" with "N"
    And I fill in "Routine Goal" with "Do New Test Routine this way not that way"
    And I press "save-routine"
    Then I should see "Unable to create/update Routine"
    And I should see "Name is too short"

  @javascript
  Scenario: Clicking on an activity adds it to the routine
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    When I click "#benchpress"
    Then I should see "Added Bench Press to the routine"
    And there should be 1 activity sets
    When I click "#routine-activity-set-list .activity-set-form:nth(1) .clone-activity-set-button"
    Then there should be 2 activity sets
    When I click "#routine-activity-set-list .activity-set-form:nth(2) .delete-activity-set-button"
    Then there should be 1 activity sets

  @javascript
  Scenario: Importing activity sets and behavior from another routine
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    And I click "#import-routine-button"
    Then I should see "Select a routine to import"
    When I select "Sally Client" from "client-for-routines-dropdown"
    And I select "Whole Body Mix" from "routines-for-client-dropdown"
    When I click "#import-routine-submit-button"
    Then there should be 2 activity sets
    When I click "#routine-activity-set-list .activity-set-form:nth(1) .clone-activity-set-button"
    Then there should be 3 activity sets
    When I click "#routine-activity-set-list .activity-set-form:nth(2) .delete-activity-set-button"
    Then there should be 2 activity sets

  @javascript
  Scenario: I can add a ranged activity set to a routine
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    When I click "#benchpress"
    Then there should be 1 activity sets
    Given I find the 1st activity set
    When I fill in minimum Repetitions with "13"
    And I make Repetitions a ranged measure
    When I fill in maximum Repetitions with "15"
    And I fill in "Routine Name" with "New Test Routine"
    And I fill in "Routine Goal" with "Perform a range of repetitions"
    And I press "Save Routine"
    Then I should see "Bench Press Repetitions 13 to 15"

  @javascript
  Scenario: Clearing facets restores list to full
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    Then there should be 10 activities in the list
    And I click "#facet-plyometric"
    Then there should be 1 activities in the list
    When I click "#facet-plyometric"
    Then there should be 10 activities in the list

  @javascript
  Scenario: I can filter activities by clicking facets and searching together
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    When I click "#facet-push"
    Then there should be 6 activities in the list
    When I click "#facet-resistance"
    Then there should be 5 activities in the list
    When I click "#facet-compound"
    Then there should be 5 activities in the list
    When I click "#facet-tricepsbrachii"
    Then there should be 3 activities in the list
    When I click "#facet-bench"
    Then there should be 2 activities in the list
    When I click "#facet-bench"
    Then there should be 3 activities in the list
    When I click "#facet-tricepsbrachii"
    Then there should be 5 activities in the list
    When I click "#facet-compound"
    Then there should be 5 activities in the list
    When I click "#facet-resistance"
    Then there should be 6 activities in the list
    When I fill in "activity-search-box" with "Dumbbell"
    Then there should be 2 activities in the list

  @javascript
  Scenario: When I copy activity sets the metrics and units are copied to the new set
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    When I click "#benchpress"
    Then I should see "Added Bench Press to the routine"
    And there should be 1 activity sets
    Given I find the 1st activity set
    When I fill in minimum Resistance with "100"
    And I select "Kilograms" from "routine_activity_sets__resistance_unit"
    When I click "#routine-activity-set-list .activity-set-form:nth(1) .clone-activity-set-button"
    Then there should be 2 activity sets
    Given I find the 2nd activity set
    Then minimum Resistance should be "100"
    And Resistance units should be "Kilograms"

  @javascript
  Scenario: When I choose a distance in kilometers it is stored in meters and returned in kilometers
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    When I click "#treadmillrun"
    Then there should be 1 activity sets
    Given I find the 1st activity set
    When I fill in minimum Distance with "8"
    And I select "Kilometers" from "routine_activity_sets__distance_unit"
    And I fill in "Routine Name" with "New Test Routine"
    And I fill in "Routine Goal" with "Perform a distance in kilometers"
    And I press "Save Routine"
    Given I am on the /users/sally_the_client/routines/newtestroutine page
    Then I should see "Treadmill Run Distance 8.0 Kilometers"

  @javascript
  Scenario: When I choose a distance in miles it is stored in meters and returned in miles
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    When I click "#treadmillrun"
    Then there should be 1 activity sets
    Given I find the 1st activity set
    When I fill in minimum Distance with "8"
    And I select "Miles" from "routine_activity_sets__distance_unit"
    And I fill in "Routine Name" with "New Test Routine"
    And I fill in "Routine Goal" with "Perform a distance in miles per hour"
    And I press "Save Routine"
    Given I am on the /users/sally_the_client/routines/newtestroutine page
    Then I should see "Treadmill Run Distance 8.0 Miles"

  # This runs last because it adds an activity and fixtures aren't reloaded between scenarios apparently
  @javascript
  Scenario: I can create a new activity on the routine builder screen
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/routines/new page
    Then "#modal-activity-builder" should not be visible
    When I click "#new-activity-button"
    And "#modal-activity-builder" should be visible
    And I click "#activity-builder-trapezius"
    And "#modal-activity-builder" should not be clear
    And I fill in "Activity Name" with "Triple Ab Blaster"
    And I fill in "Instructions" with "Blast yer abs three times!"
    And I press "Save Activity"
    Then within "#activity-list" I should see "Triple Ab Blaster"
    And "#modal-activity-builder" should not be visible
    And "#modal-activity-builder" should be clear

