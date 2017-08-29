Feature: Invitations list
  Scenario: List invitations in JSON
    When I send and accept JSON
    And I send a GET request to "/invitations"
    Then the response status should be "200"
    And the JSON response should have "$..email" with the text "MyString"
    And the JSON response should have "$..email" with a length of 1
