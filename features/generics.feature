Feature: generics

  Scenario: Tried to visit a non-existent page
    Given I am on a non-existent page
    Then I should see "404"