Feature: Only administrators may view the list of feedback
  As a logged in user
  I can only see the list of feedback if I am an admin
  so that I can better gather feedback about the system

  Scenario: As a logged in non-admin I cannot see any users
    Given I log in as "sally_the_client" with "password"
    And I am on the /feedback page
    Then I should not see "Release the Kraken!"

  Scenario: As a logged in admin I can see all users
    Given I log in as "administrator" with "password"
    And I am on the /feedback page
    Then I should see "Release the Kraken!"
