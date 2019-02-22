#!/usr/bin/env groovy

library("govuk")

REPOSITORY = 'government-frontend'

node {
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-government-frontend")
  govuk.buildProject(publishingE2ETests: true, brakeman: true, precompileAssetsBeforeTests: true)
}
