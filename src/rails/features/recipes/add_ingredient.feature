@menu
Feature: Manage ingredients in a recipe
  As a user
  I want to know what I need to make each recipe
  And I want to know the nutritional content of each recipe
  For example, by adding ingredients to a recipe

  Background:
    Given the following recipe exists:
      | name              |
      | Some Recipe       |

  Scenario: Add an ingredient to a recipe
    Given I am on the recipe show screen
    When I click the "Add Ingredient" link
      And I enter:
        | input      | value           |
        | Name       | Some Ingredient |
      And I click the "Add Ingredient" button
    Then I should see the heading "Some Recipe"
      And I should see "Some Ingredient"