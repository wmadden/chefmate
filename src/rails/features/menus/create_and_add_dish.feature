@menu
Feature: Create a new dish and add it to a menu
  As a user
  I want to be able to add dishes to my menu that aren't known by the system
  In order to plan out a menu that's more personalized than what would otherwise be possible
  For example, by entering the dish information so that it becomes known to the system when I add a dish to my menu
  
  Scenario: Get visual feedback that the dish will be created
    Given I'm looking at a menu
    When I click the "add dish" link
      And I type in the name of a dish that's not known to the system
    Then the "create and add dish" button should be enabled
      And it should have the "create" icon
  
  Scenario: The dish is added to the menu
    Given I'm looking at a menu
    When I click the "add dish" link
      And I type in the name of a dish that's not known to the system
      And I click the "create and add dish" button
    Then I should see the dish I want in the menu
  
  
  