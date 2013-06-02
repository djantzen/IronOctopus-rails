Feature: Perform work against a routine
  As a logged in user
  I want to record my work
  so that my trainer knows what I'm doing and I have a log of my accomplishments

  @javascript
  Scenario: I am able to add an unplanned activity to the routine
    Given I log in as "sally_the_client" with "password"
    And I am on the /users/sally_the_client/routines/wholebodymix/perform page
    When I click "#benchpress"
    Then I should see "Added Bench Press to the routine"
    And there should be 3 activity sets
    When I click "#routine-activity-set-list .activity-set-form:nth(1) .clone-activity-set-button"
    Then there should be 4 activity sets
    When I click "#routine-activity-set-list .activity-set-form:nth(2) .delete-activity-set-button"
    Then there should be 3 activity sets

  @javascript
  Scenario: I can filter activities by searching and reset
    Given I log in as "sally_the_client" with "password"
    And I am on the /users/sally_the_client/routines/wholebodymix/perform page
    Then there should be 10 activities
    When I fill in "activity-search-box" with "Bench Press"
    Then there should be 2 activities
    When I click "#clear-selections"
    Then there should be 10 activities
