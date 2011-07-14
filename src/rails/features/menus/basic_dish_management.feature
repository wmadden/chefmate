Feature: Basic Dish Management
  As a user
  In order to put new dishes on my menu
  I want to be able to create and change new dishes

  Scenario: Navigate to the dishes screen
    Given I am on the root page
    When I click the "Dishes" link
    Then I should be on the existing dishes screen

  Scenario: Create a Dish
    Given I am on the existing dishes screen
    When I click the "New Dish" link
      And I enter:
        | input | value     |
        | name  | Some Dish |
      And I click the "Create Dish" button
    Then I should be on the existing dishes screen
      And I should see "Some Dish"

  Scenario: View a Dish
    Given the following dish exists:
      | name      |
      | Some Dish |
      And I am on the existing dishes screen
    When I click the "Some Dish" link
    Then I should see the heading "Some Dish"

  Scenario: Change the properties of a Dish
    Given the following dish exists:
      | name            |
      | Some Dish       |
    And I am on the dish show screen
    When I click the "Edit Dish" link
      And I enter:
        | input       | value              |
        | Name        | Some New Dish Name |
      And I click the "Update Menu" button
    Then I should see a success message
      And I should see the heading "Some New Dish Name"

