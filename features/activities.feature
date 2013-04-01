Feature: Create a new activity
  As a logged in user
  I want to create a new activity
  so that my client is trained properly
  
  Scenario: Creation of a new activity
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /activities/new page
    When I fill in "Name" with "New Test Activity"
    And I fill in "Instructions" with "Do New Test Activity this way not that way"
    And I select "Cycling" from "activity[activity_type]"
    And I press "Save"
    Then I should see "New Test Activity"
    And I should see "Cycling"

  Scenario: Creation of a new activity with too short a name
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /activities/new page
    When I fill in "Name" with "N"
    And I fill in "Instructions" with "Do New Activity this way not that way"
    And I press "Save"
    Then I should see "Unable to create/update Activity"
    And I should see "Name is too short"

  @javascript
  Scenario: Creation of a new activity with too short a name triggers Javascript validation
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /activities/new page
    When I fill in "Name" with "N"
    And I fill in "Instructions" with "Do New Activity this way not that way"
    And I press "Save"
    Then I should see "Please enter at least 4 characters"
