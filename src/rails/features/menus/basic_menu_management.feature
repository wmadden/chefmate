@menu
Feature: Managing menus
  As a user
  I want to be able to plan my meals ahead of time
  So that I can ensure I meet my dietary requirements
  And buy the ingredients I will require in one go
  
  Scenario: Create a menu
    Given I am on the existing menus screen
    When I click the "New Menu" link
      And I enter:
        | input | value     |
        | Name  | Some Menu |
      And I click the "Create Menu" button
    Then I should see the message "Menu created"
      And I should see "Some Menu"
    
  @wip
  Scenario: Remove a dish from a menu
    Given I am looking at a menu
    When I click the "remove" button on a dish
    Then I should no longer see the dish
  
  @wip
  Scenario: View a dish from a menu
    Given I am looking at a menu
    When I click on a dish's name
    Then I should be taken to look at the dish

  @wip
  Scenario: Delete a menu
    Given I am looking at some existing menus
    When I click the "remove" button on a menu
    Then I should no longer see the menu
  
  @wip
  Scenario: Change the properties of a menu
    Given I am looking at a menu
    When I click the "edit" link
      And I enter a new name for the menu
      And I click the "save changes" button
    Then I should be taken to look at the menu
      And it should have the new name I entered
  