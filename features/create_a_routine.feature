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
    And I press "save-routine"
    Then I should see "Bench Press Repetitions 13 to 15"
