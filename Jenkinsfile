#!/usr/bin/env groovy

REPOSITORY = 'government-frontend'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
  govuk.buildProject(publishingE2ETests: true)
}
