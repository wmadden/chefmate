@menu
Feature: Add a dish to a menu
  As a user
  I want my menu to contain dishes I like
  For example, by adding the dishes I like to my menu
  
  Scenario: See visual feedback that the dish will be added to the menu
    Given I am looking at a menu
    When I click the "add dish" link
      And I type in the name of a dish
    Then the "add dish" button should be enabled
      And it should have the "add" icon
  
  Scenario: See visual feedback that I need to enter a dish's name
    Given I am looking at a menu
    When I click the "add dish" link
    Then I should see a prompt to "enter the name of the dish you want"
      And the "add dish" button should be disabled
  
  Scenario: Add a dish to a menu
    Given I am looking at a menu
    When I click the "add dish" link
      And I type in the name of a dish
      And I click the "add dish" button
    Then I should see the dish in the menu
