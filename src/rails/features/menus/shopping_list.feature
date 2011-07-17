Feature: Shopping List
  As a User
  I want to buy all the ingredients I need for the dishes on my menu
  For example by getting my shopping list from my menu

  Scenario: View shopping list
    Given the following dishes exist:
      | name                 |
      | Tacos                |
      | Spaghetti Bolognaise |
      And the dish "Tacos" has the following ingredients:
        | name     |
        | Meat     |
        | Avocados |
      And the dish "Spaghetti Bolognaise" has the following ingredients:
        | name      |
        | Spaghetti |
        | Tomatoes  |
      And the following menu exists:
        | name      |
        | Some Menu |
      And the menu contains the following dishes:
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
