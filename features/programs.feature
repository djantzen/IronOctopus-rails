Feature: Create a new program
  As a logged in user
  I want to create a new program
  so that my client is trained properly
  
  Scenario: Creation of a new program
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/programs/new page
    Then I should see "Program Name"
    When I fill in "Program Name" with "New Test Program"
    And I fill in "Program Goal" with "Do New Test Program this way not that way"
    And I press "save-program"
    Then I should see "New Test Program"
    And I should see "Created by Bob Trainer"

  Scenario: Creation of a new program with too short a name
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client/programs/new page
    When I fill in "Program Name" with "N"
    And I fill in "Program Goal" with "Do New Test Program this way not that way"
    And I press "save-program"
    Then I should see "Unable to create/update Program"
    And I should see "Name is too short"
