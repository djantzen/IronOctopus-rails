Feature: Invite a user
  As an authorized user
  I want to email a new or existing user and
  invite them to be my client

  Scenario: Invitation of a new user
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/bob_the_trainer/invitations/new page
    Then I should see "2 licenses"
    When I fill in "Email" with "jill_the_client@gmail.com"
    And I press "Send Invitation"
    Then Jill should receive an invitation email
    And I should see "An invitation has been sent to jill_the_client@gmail.com"
    And jill_the_client@gmail.com should be registered
    And jill_the_client@gmail.com should be confirmed
    And jill_the_client@gmail.com should be a client of bob_the_trainer@gmail.com
    And the invitation should be accepted
    Given I am on the /users/bob_the_trainer/invitations/new page
    Then I should see "1 licenses"

  Scenario: Invitation of an existing user
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/bob_the_trainer/invitations/new page
    Then I should see "2 licenses"
    When I fill in "Email" with "jim_the_client@gmail.com"
    And I press "Send Invitation"
    Then Jim should receive an invitation email
    And I should see "An invitation has been sent to jim_the_client@gmail.com"
    And jim_the_client@gmail.com should be registered
    And jim_the_client@gmail.com should be confirmed
    And jim_the_client@gmail.com should be a client of bob_the_trainer@gmail.com
    And the invitation should be accepted
    Given I am on the /users/bob_the_trainer/invitations/new page
    Then I should see "1 licenses"
