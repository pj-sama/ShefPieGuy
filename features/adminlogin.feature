Feature: adminlogin

  Scenario: Correct password entered
    Given I am on the admin login page
    When I fill in "admin" with "admin"
    When I fill in "password" with "password"
    When I press "Submit" within "form"
    Then I should see "Admin Console"
   

  Scenario: Wrong password entered
    Given I am on the admin login page
    When I fill in "admin" with "admin"
    When I fill in "password" with "wrongpassword"
    When I press "Submit" within "form"
    Then I should see "Login failed please try again."