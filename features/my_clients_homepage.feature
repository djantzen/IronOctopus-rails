Feature: Viewing my clients homepage
  As a logged in trainer
  I should be able create routines for my client
  so that I can train them properly

  Scenario: As a logged in trainer I can create routines for my client
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client page
    Then I should see "Create new program for Sally"
    And I should see "Create new routine for Sally"

  Scenario: As a logged in trainer I cannot visit homepages of non clients
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/mary_the_trainer page
    Then I should not see "Create new program for Mary"
    And I should not see "Create new routine for Mary"
    And I should see "Create new routine for Bob"

  Scenario: As a logged in user I cannot visit someone else's settings page
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/mary_the_trainer/settings page
    Then I should not see "New Password"
    And I should see "Bob Trainer"

