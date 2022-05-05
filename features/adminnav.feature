Feature: adminnav

  Scenario: Clicked Admin Console
    Given I am on the admin login page
    When I fill in "admin" with "admin"
    When I fill in "password" with "password"
    When I press "Submit" within "form"
    When I follow "Admin Console" within "nav"
    Then I should see "Admin Console"
    
  Scenario: Clicked Handle Orders
    Given I am on the admin login page
    When I fill in "admin" with "admin"
    When I fill in "password" with "password"
    When I press "Submit" within "form"
    When I follow "Handle Orders" within "nav"
    Then I should see "Handle SheffPieGuy Orders"
    
  Scenario: Clicked Offers
    Given I am on the admin login page
    When I fill in "admin" with "admin"
    When I fill in "password" with "password"
    When I press "Submit" within "form"
    When I follow "Offers" within "nav"
    Then I should see "SheffPieGuy Admin Offers"
    
  Scenario: Clicked Accounts
    Given I am on the admin login page
    When I fill in "admin" with "admin"
    When I fill in "password" with "password"
    When I press "Submit" within "form"
    When I follow "Accounts" within "nav"
    Then I should see "SheffPieGuy Accounts"
    
  Scenario: Clicked Pies
    Given I am on the admin login page
    When I fill in "admin" with "admin"
    When I fill in "password" with "password"
    When I press "Submit" within "form"
    When I follow "Pies" within "nav"
    Then I should see "Pie Menu Editing Mode"