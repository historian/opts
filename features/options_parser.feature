Feature: OptionParser
  In order to be configured
  As a developer
  I want to parse options


  Background:
    Given the simple application


  Scenario: Parse boolean flag
    Given a results table:
          | ARGV            | VERBOSE |
          | --verbose       | true    |
          | --verbose=on    | true    |
          | --verbose=yes   | true    |
          | --verbose=true  | true    |
          | --no-verbose    | false   |
          | --verbose=off   | false   |
          | --verbose=no    | false   |
          | --verbose=false | false   |
          | -v              | true    |
          | -v=on           | true    |
          | -v=yes          | true    |
          | -v=true         | true    |
          | -V              | false   |
          | -v=off          | false   |
          | -v=no           | false   |
          | -v=false        | false   |
     When executed with ARGV in the results table
     Then the environment must match VERBOSE in the results table


  Scenario: Parse numeric option
    Given a results table:
          | ARGV            | COUNT |
          | -c=4            | 4     |
          | --count=4       | 4     |
          | --count=2342    | 2342  |
          | --count=-2342   | -2342 |
          | --count=5.6     | 5.6   |
     When executed with ARGV in the results table
     Then the environment must match COUNT in the results table

