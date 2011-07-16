@menu
Feature: Manage items on a menu
  As a user
  I want to know what I need to make each dish
  And I want to know the nutritional content of each dish
  For example, by adding ingredients to a dish

  Background:
    Given the following dish exists:
      | name            |
      | Some Dish       |

  Scenario: Add an ingredient to a dish
    Given I am on the dish show screen
    When I click the "Add Ingredient" link
      And I enter:
        | input      | value           |
        | Ingredient | Some Ingredient |
      And I click the "Add Ingredient" button
    Then I should see the heading "Some Dish"
      And I should see "Some Ingredient"