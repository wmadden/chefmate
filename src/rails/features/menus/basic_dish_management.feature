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
    Given the following recipe exists:
      | name        |
      | Some Recipe |
      And I am on the menu show screen
    When I click the "Add Dish" link
      And I choose the Recipe "Some Recipe"
      And I click the "Add Dish" button
    Then I should see the heading "Some Menu"
      And I should see "Some Recipe"

  Scenario: Remove a dish from a menu
    Given the following recipe exists:
      | name        |
      | Some Recipe |
      And the menu contains the following recipes:
        | name        |
        | Some Recipe |
      And I am on the menu show screen
    When I click the "Remove Dish" link
    Then I should not see "Some Recipe" in the dishes table

  @wip
  Scenario: See visual feedback that the recipe will be added to the menu
    Given I am on the menu show screen
    When I click the "add recipe" link
      And I type in the name of a recipe
    Then the "add recipe" button should be enabled
      And it should have the "add" icon

  @wip
  Scenario: See visual feedback that I need to enter a recipe's name
    Given I am on the menu show screen
    When I click the "add recipe" link
    Then I should see a prompt to "enter the name of the recipe you want to add"
      And the "add recipe" button should be disabled

