Feature: Create a new trainer profile
  As a logged in trainer
  I want to create a profile that shows up in organic search results
  so that I can acquire new customers

  Scenario: I have the option to create a profile on my home page and no others
    Given I log in as "mary_the_trainer" with "password"
    And I am on mary_the_trainer's homepage
    Then I should see "Create a Trainer Profile"
    When I am on bob_the_trainer's homepage
    Then I should not see "Create a Trainer Profile"

  Scenario: I am able to create a new profile
    Given I log in as "bob_the_trainer" with "password"
    And I am on bob_the_trainer's homepage
    And I click "Create a Trainer Profile"
    Then I should see "Creative"
    When I fill in "Creative" with "Yeah I'm rad yo!"
    And I fill in "Phone" with "(555)555-5555"
    And I fill in "Email" with "bad@assery.com"
    And I press "Save"
    Then I should see "About Bob Yeah I'm rad yo!"
