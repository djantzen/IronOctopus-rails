Feature: Viewing my clients homepage
  As a logged in trainer
  I should be able create routines for my client
  so that I can train them properly

  Scenario: As a logged in trainer I can create routines for my client
    Given I log in as "bob_the_trainer" with "password"
    And I am on the /users/sally_the_client page
    Then I should see "Create new program for Sally"
    And I should see "Create new routine for Sally"

# As bob, I can
#  create routines and programs for myself
#  perform routines
#  visit sallys page
#    create routines and programs
#    not perform routines
#  visit mary's page
#    cannot create routines and programs
#