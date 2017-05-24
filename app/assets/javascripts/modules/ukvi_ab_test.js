// = require govuk/multivariate-test
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (GOVUK) {
  'use strict'

  GOVUK.Modules.UkviAbTest = function () {
    this.start = function ($el) {
      var testType = $el.data('test-type'),
        testLabel = $el.data('test-label'),
        newContent = $el.html(),
        testCallback = testType === 'overview' ? updateOverviewSection : UpdateKnowledgeOfEnglishSection

      new GOVUK.MultivariateTest({
        name: testLabel,
        cookieDuration: 30, // set cookie expiry to 30 days
        customDimensionIndex: [13, 14],
        cohorts: {
          original: { callback: function () {}, weight: 50},
          spouseProminent: {
            callback: testCallback,
            weight: 50
          }
        }
      })

      function updateOverviewSection () {
        $('#exceptions').prevAll().hide()
        $('#exceptions').before(newContent)
      }

      function UpdateKnowledgeOfEnglishSection () {
        $('#exemptions').prevAll().hide()
        $('#exemptions').before(newContent)
      }
    }
  }
})(window.GOVUK)
