Feature: User Authentication
  As a user
  I want to be able to log in to the application
  So that I can access my personal task management features

  Background:
    Given I am on the login page

  Scenario: Successful login with valid credentials
    When I enter valid credentials
    And I click the login button
    Then I should be redirected to the dashboard
    And I should see a welcome message

  Scenario: Failed login with invalid credentials
    When I enter invalid credentials
    And I click the login button
    Then I should see an error message
    And I should remain on the login page

  Scenario: Password reset request
    When I click the "Forgot Password" link
    Then I should be redirected to the password reset page
    And I should be able to enter my email address
