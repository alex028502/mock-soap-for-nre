Feature: mock soap service
  A mock soap service to provide a tiny subset of the functionality of the LDB
  SOAP web service.

  Background:
    * prepare correct request

  Scenario: Happy Path
    * use correct header
    * send
    Then we should get a "200"
    And the output should contain expected departure
    And the output should contain board message
    And the output shouldn't contain bad key error

  Scenario: wrong api key
    * change api key
    * use correct header
    * send
    Then we should get a "401"
    And the output shouldn't contain expected departure
    And the output shouldn't contain board message
    And the output should contain bad key error

  Scenario: wrong station code
    * change station code
    * use correct header
    * send
    Then we should get a "500"
    Then the output shouldn't contain expected departure
    And the output shouldn't contain board message
    And the output shouldn't contain bad key error

  Scenario: bad media type
    * use wrong header
    * send
    Then we should get a "415"
    Then the output shouldn't contain expected departure
    And the output shouldn't contain board message
    And the output shouldn't contain bad key error
    And the output should contain bad media type error
