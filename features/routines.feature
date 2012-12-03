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
