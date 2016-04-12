Feature: sample program
  A simple tool that lists departures for a station.  We generate this tool
  by downloading the example program from the nre-darwin-py package and then
  making some modifications:
  -show board messages as well as departures
  -allow us to inject our own wsdl url

  Background:
    Given the right wsdl url is being used
    And the suds wsdl cache is cleared

  Scenario: Happy Path
    Given the right api key is set
    And the station input "KGX"
    When the command line tool is run
    Then the program should succeed
    And the output should contain expected departure
    And the output should contain board message
    And the output shouldn't contain bad key error

  Scenario: wrong api key
    Given the wrong api key is set
    And the station input "KGX"
    When the command line tool is run
    Then the program shouldn't succeed
    And the output shouldn't contain expected departure
    And the output shouldn't contain board message
    And the output should contain bad key error

  Scenario: wrong station code
    Given the right api key is set
    And the station input "ABC"
    When the command line tool is run
    Then the program shouldn't succeed
    And the output shouldn't contain expected departure
    And the output shouldn't contain board message
    And the output shouldn't contain bad key error
