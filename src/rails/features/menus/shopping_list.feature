Feature: Shopping List
  As a User
  I want to buy all the ingredients I need for the recipes on my menu
  For example by getting my shopping list from my menu

  Scenario: View shopping list
    Given the following recipes exist:
      | name                 |
      | Tacos                |
      | Spaghetti Bolognaise |
      And the recipe "Tacos" has the following ingredients:
        | name     |
        | Meat     |
        | Avocados |
      And the recipe "Spaghetti Bolognaise" has the following ingredients:
        | name      |
        | Spaghetti |
        | Tomatoes  |
      And the following menu exists:
        | name      |
        | Some Menu |
      And the menu contains the following recipes:
        | name                 |
        | Tacos                |
        | Spaghetti Bolognaise |
      And I am on the menu show screen
    When I click the "Shopping List" link
    Then I should see the following ingredients:
      | name      |
      | Meat      |
      | Avocados  |
      | Spaghetti |
      | Tomatoes  |
