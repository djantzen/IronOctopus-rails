Feature: Viewing my homepage
  As a logged in user
  I should be able create and perform my own routines
  so that I can train myself properly

  Scenario: As a logged in non-trainer I can create my own routines
    Given I log in as "sally_the_client" with "password"
    And I am on the /users/sally_the_client page
    Then I should see "Create new program for Sally"
    And I should see "Create new routine for Sally"

  Scenario: As a logged in trainer I can create my own routines
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/bob_the_trainer page
    Then I should see "Create new program for Bob"
    And I should see "Create new routine for Bob"

  Scenario: As a logged in user I can visit my own settings page
    Given I log in as "sally_the_client" with "password"
    And I am on the /users/sally_the_client/settings page
    Then I should see "New Password"
    And I should see "Confirm Password"

  Scenario: As a logged in user I can change my own password
    Given I log in as "sally_the_client" with "password"
    And I am on the /users/sally_the_client/settings page
    When I fill in "New Password" with "newpassword"
    And I fill in "Confirm Password" with "newpassword"
    And I press "Save"
    Then I should see "Settings Updated"
    Then I should see "Sally Client"
    When I log out
    And I log in as "sally_the_client" with "password"
    Then I should see "Login"
    And I log in as "sally_the_client" with "newpassword"
    Then I should see "Sally Client"
