#!/usr/bin/env groovy

REPOSITORY = 'government-frontend'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
  withCredentials([string(credentialsId: 'percy-token', variable: 'PERCY_TOKEN')]) {
    govuk.setEnvar('PERCY_PROJECT', 'Test-Front/government-frontend')
    govuk.buildProject()
  }
}
