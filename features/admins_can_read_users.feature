Feature: Only administrators may view the list of users
  As a logged in user
  I can only see the list of users if I am an admin
  so that I can better understand usage of the system

  Scenario: As a logged in non-admin I cannot see any users
    Given I log in as "sally_the_client" with "password"
    And I am on the /users page
    Then I should not see "Sally Client"

  Scenario: As a logged in admin I can see all users
    Given I log in as "administrator" with "password"
    And I am on the /users page
    Then I should see "Sally Client"
    And I should see "Bob Trainer"
