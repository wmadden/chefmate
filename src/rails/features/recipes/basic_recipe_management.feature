Feature: Basic Recipe Management
  As a user
  In order to put new recipes on my menu
  I want to be able to create and change recipes for recipes

  Scenario: Navigate to the recipes screen
    Given I am on the root page
    When I click the "Recipes" link
    Then I should see the heading "Recipes"

  Scenario: View existing recipes
    Given the following recipes exist:
      | name            |
      | Some Recipe       |
      | Some Other Recipe |
    When I go to the existing recipes screen
    Then I should see the names of all existing recipes

  Scenario: Create a Recipe
    Given I am on the existing recipes screen
    When I click the "New Recipe" link
      And I enter:
        | input | value     |
        | Name  | Some Recipe |
      And I click the "Create Recipe" button
    Then I should see a success message
      And I should see the heading "Some Recipe"

  Scenario: View a Recipe
    Given the following recipe exists:
      | name      |
      | Some Recipe |
      And I am on the existing recipes screen
    When I click the "Some Recipe" link
    Then I should see the heading "Some Recipe"

  Scenario: Change the properties of a Recipe
    Given the following recipe exists:
      | name            |
      | Some Recipe       |
    And I am on the recipe show screen
    When I click the "Edit Recipe" link
      And I enter:
        | input       | value              |
        | Name        | Some New Recipe Name |
      And I click the "Update Recipe" button
    Then I should see a success message
      And I should see the heading "Some New Recipe Name"

