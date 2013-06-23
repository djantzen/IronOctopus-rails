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

# As bob, I can
#  create routines and programs for myself
#  perform routines
#  visit sallys page
#    create routines and programs
#    not perform routines
#  visit mary's page
#    cannot create routines and programs
#