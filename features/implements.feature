Feature: Create a new implement
  As a logged in user
  I want to create a new implement
  so that my client is trained properly

  Scenario: Creation of a new implement
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /implements/new page
    When I fill in "Name" with "New Test Implement"
    And I press "Save"
    Then I should see "New Test Implement"

  Scenario: Creation of a new implement with too short a name
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /implements/new page
    When I fill in "Name" with "N"
    And I press "Save"
    Then I should see "Unable to create/update Implement"
    And I should see "Name is too short"
