Feature: Puppet manifest integrity
  In order to ensure basic correctness
  I want all catalogs to parse and not have style guide errors
  
  Scenario: Manifest validation
    Given any manifest
    Then it should validate
    And it should have no lint errors