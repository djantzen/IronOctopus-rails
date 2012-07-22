Feature: Register new client
  As an authorized user
  I want to create a login for a new client
  So that they can log in

  Scenario: Register client happy path
    Given I am on the sign up page
    When I fill in "Email" with "allison_the_client@gmail.com"
    And I fill in "First name" with "Allison"
    And I fill in "Last name" with "Client"
    And I fill in "Login" with "allison_the_client"
    And I fill in "Password" with "Password"
    And I fill in "Password confirmation" with "Password"
    And I press "Sign Up"
    Then Client should be registered
    And I should be the trainer
