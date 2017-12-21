#!/usr/bin/env groovy

REPOSITORY = 'government-frontend'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-government-frontend")
  govuk.buildProject(publishingE2ETests: true)
}
