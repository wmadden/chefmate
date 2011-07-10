@menu
Feature: Managing menus
  As a user
  I want to be able to plan my meals ahead of time
  So that I can ensure I meet my dietary requirements
  And buy the ingredients I will require in one go
  
  Scenario: Create a menu
    Given I am looking at the existing menus screen
    When I click the "new menu" link
      And I enter a name for the new menu
    Then I should see a new, empty menu
      And it should have the name I entered
  
  Scenario: Remove a dish from a menu
    Given I am looking at a menu
    When I click the "remove" button on a dish
    Then I should no longer see the dish
  
  Scenario: View a dish from a menu
    Given I am looking at a menu
    When I click on a dish's name
    Then I should be taken to look at the dish

  Scenario: Delete a menu
    Given I am looking at some existing menus
    When I click the "remove" button on a menu
    Then I should no longer see the menu
  
  Scenario: Change the properties of a menu
    Given I am looking at a menu
    When I click the "edit" link
      And I enter a new name for the menu
      And I click the "save changes" button
    Then I should be taken to look at the menu
      And it should have the new name I entered
  