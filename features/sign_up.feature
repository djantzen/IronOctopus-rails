Feature: Sign up
  As an unauthorized user
  I want to sign up with my details
  So that I can login

  Scenario: Self sign up happy path
    Given I am on the sign up page
    When I fill in "Email" with "george_the_trainer@gmail.com"
    And I fill in "First name" with "George"
    And I fill in "Last name" with "Trainer"
    And I fill in "Login" with "george_the_trainer"
    And I fill in "Password" with "Password"
    And I fill in "Password confirmation" with "Password"
    And I press "Sign Up"
  #    Then I should land on the index page
    Then I should be registered

  Scenario: Self sign up password doesn't match confirmation
    Given I am on the sign up page
    When I fill in "Email" with "george_the_trainer@gmail.com"
    And I fill in "First name" with "George"
    And I fill in "Last name" with "Trainer"
    And I fill in "Login" with "george_the_trainer"
    And I fill in "Password" with "Secret"
    And I fill in "Password confirmation" with "Password"
    And I press "Sign Up"
    Then the sign up form should be shown again
    And I should see "Password doesn't match confirmation"
    And I should not be registered
