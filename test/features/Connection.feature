# title.feature
Feature: Connection
  As User I would like be able
  open one browser as server
  and others as client
  Background: Signaling server
    Given Running WebRTC signaling server

  Scenario: Blunk Title Check DELME!!
    Given I go to the website "/#!/server/"
    Then I expect the title is same as package description

  Scenario: Server Starts
    Given Server room "2 3#|3# #|#2@ #|5#"
    When I connect as "Player1"
    Then Server should "Player1" connected

  # Scenario: Server See connected players
  #   Given I start default server
  #   When I connect as "Player1"
  #   Then I see "Player1" connected in "Server" list