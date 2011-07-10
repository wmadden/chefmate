@menu
Feature: Manage dishes on a menu
  As a user
  I want my menu to contain dishes I like
  For example, by adding the dishes I like to my menu, and removing those I don't
  
  Background:
    Given the following menu exists:
      | name            |
      | Some Menu       |
  
  Scenario: Add a dish to a menu
    Given I am on the menu show screen
    When I click the "add dish" link
      And I type in the name of a dish
      And I click the "add dish" button
    Then I should see the dish in the menu
  
  Scenario: See visual feedback that the dish will be added to the menu
    Given I am on the menu show screen
    When I click the "add dish" link
      And I type in the name of a dish
    Then the "add dish" button should be enabled
      And it should have the "add" icon
  
  Scenario: See visual feedback that I need to enter a dish's name
    Given I am on the menu show screen
    When I click the "add dish" link
    Then I should see a prompt to "enter the name of the dish you want to add"
      And the "add dish" button should be disabled
  
