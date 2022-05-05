Feature: navbar

  Scenario: Clicked Home
    Given I am on the home page
    When I follow "Home" within "nav"
    Then I should see "Tasty Pies in and around Sheffield"
  
  
  Scenario: Clicked Menu
    Given I am on the home page
    When I follow "Menu" within "nav"
    Then I should see "Our Menu"

  Scenario: Clicked Offers
    Given I am on the home page
    When I follow "Offers" within "nav"
    Then I should see "Offers at SheffPieGuy"
    
  Scenario: Clicked Contact
    Given I am on the home page
    When I follow "Contact" within "nav"
    Then I should see "Need to grab us??"
    
  Scenario: Clicked About
    Given I am on the home page
    When I follow "About Us" within "nav"
    Then I should see "Once upon a time...⏳"