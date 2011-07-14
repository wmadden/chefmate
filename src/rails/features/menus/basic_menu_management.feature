@menu
Feature: Managing menus
  As a user
  I want to be able to plan my meals ahead of time
  So that I can ensure I meet my dietary requirements
  And buy the ingredients I will require in one go

  Scenario: Navigate to menus screen
    Given I am on the root page
    When I click the "Menus" link
    Then I should be on the existing menus screen

  Scenario: Create a menu
    Given I am on the existing menus screen
    When I click the "New Menu" link
      And I enter:
        | input | value     |
        | Name  | Some Menu |
      And I click the "Create Menu" button
    Then I should see the message "Menu created"
      And I should see the heading "Some Menu"

  Scenario: View existing menus
    Given the following menus exist:
      | name            |
      | Some Menu       |
      | Some Other Menu |
    When I go to the existing menus screen
    Then I should see the names of all existing menus

  Scenario: View a menu
    Given the following menus exist:
      | name            |
      | Some Menu       |
      | Some Other Menu |
    And I am on the existing menus screen
    When I click the "Some Menu" link
    Then I should see the heading "Some Menu"

  Scenario: Change the properties of a menu
    Given the following menu exists:
      | name            |
      | Some Menu       |
    And I am on the menu show screen
    When I click the "Edit Menu" link
      And I enter:
        | input       | value              |
        | menu[name]  | Some New Menu Name |
      And I click the "Update Menu" button
    Then I should see the message "Menu updated"
      And I should see the heading "Some New Menu Name"
