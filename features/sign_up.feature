Feature: Sign up
  As an unauthorized user
  I want to sign up with my details
  So that I can login

  Scenario: Self sign up happy path
    Given I am on the /users/new page
    When I fill in "Email" with "george_the_trainer@gmail.com"
    And I fill in "First name" with "George"
    And I fill in "Last name" with "Trainer"
    And I fill in "Login" with "george_the_trainer"
    And I fill in "Password" with "Password"
    And I fill in "Password confirmation" with "Password"
    And I press "Sign Up"
    Then george_the_trainer@gmail.com should be registered
    And george_the_trainer@gmail.com should not be confirmed
    And I should receive a registration email
    Then george_the_trainer@gmail.com should be confirmed

  Scenario: Self sign up password doesn't match confirmation
    Given I am on the /users/new page
    When I fill in "Email" with "george_the_trainer@gmail.com"
    And I fill in "First name" with "George"
    And I fill in "Last name" with "Trainer"
    And I fill in "Login" with "george_the_trainer"
    And I fill in "Password" with "Secret"
    And I fill in "Password confirmation" with "Password"
    And I press "Sign Up"
    Then I should see "Password doesn't match confirmation"
    And george_the_trainer@gmail.com should not be registered

  Scenario: I have registered and can now log in
    Given I log in as "bob_the_trainer" with "password"
    Then I should see "Log Out"
