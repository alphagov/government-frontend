#!/usr/bin/env groovy

library("govuk")

REPOSITORY = 'government-frontend'

node {
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-government-frontend")
  govuk.buildProject(
    beforeTest: { sh("yarn install") },
    publishingE2ETests: true,
    brakeman: true,
  )
}
