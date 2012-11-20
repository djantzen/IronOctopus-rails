Feature: Reset a password
  As a registered, but non-logged in user
  I want to request a password reset and receive a temporary password via email

  Scenario: Password reset
    Given I am on the / page
    Then I should see "Forgot Password?"
    When I click "Forgot Password?"
    Then I should see "Email Address"
    When I fill in "Email" with "jim_the_client@gmail.com"
    And I press "Reset Password"
    Then I should see "A password reset link has been sent to jim_the_client@gmail.com"
    And there should exist a PasswordResetRequest for jim_the_client@gmail.com
    And I should receive a reset email
    Then I should see "New Password"
    And I fill in "New Password" with "updated_password"
    And I fill in "Confirm Password" with "updated_password"
    And I press "Save"
    Then I should see "Login"
    And the PasswordResetRequest for jim_the_client@gmail.com should be used

