#!/usr/bin/env groovy

REPOSITORY = 'government-frontend'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  properties([
    buildDiscarder(
      logRotator(
        numToKeepStr: '50')
      ),
    [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
    [$class: 'ThrottleJobProperty',
      categories: [],
      limitOneJobWithMatchingParams: true,
      maxConcurrentPerNode: 1,
      maxConcurrentTotal: 0,
      paramsToUseForLimit: 'government-frontend',
      throttleEnabled: true,
      throttleOption: 'category'],
  ])

  try {
    stage("Checkout") {
      checkout scm
    }

    stage("Clean up workspace") {
      govuk.cleanupGit()
    }

    stage("git merge") {
      govuk.mergeMasterBranch()
    }

    stage("Configure Rails environment") {
      govuk.setEnvar("RAILS_ENV", "test")
    }

    stage("Set up content schema dependency") {
      govuk.contentSchemaDependency()
      govuk.setEnvar("GOVUK_CONTENT_SCHEMAS_PATH", "tmp/govuk-content-schemas")
    }

    stage("bundle install") {
      govuk.bundleApp()
    }

    stage("rubylinter") {
      govuk.rubyLinter()
    }

    stage("sasslinter") {
      govuk.sassLinter()
    }

    stage("Precompile assets") {
      govuk.precompileAssets()
    }

    stage("Run tests") {
      govuk.runRakeTask("default")
    }

    if (env.BRANCH_NAME == 'master') {
      stage("Push release tag") {
        govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
      }
    }

    govuk.deployIntegration(REPOSITORY, env.BRANCH_NAME, 'release', 'deploy')

  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    throw e
  }
}
