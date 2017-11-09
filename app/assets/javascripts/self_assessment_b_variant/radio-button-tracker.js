;(function (global, document) {
  'use strict'

  var $ = global.jQuery
  var GOVUK = global.GOVUK || {}

  GOVUK.analyticsPlugins = GOVUK.analyticsPlugins || {}
  GOVUK.analyticsPlugins.radioButtonTracker = function ($element) {
    var radioButtonFormSelector = '.js-radio-button-track-form'

    $element.on('submit', radioButtonFormSelector, function (event) {
      var options = { transport: 'beacon' }

      var $submittedForm = $(event.target)

      var $checkedOption = $submittedForm.find('input:checked')

      var checkedValue = $checkedOption.val()

      if (typeof checkedValue === 'undefined') {
        checkedValue = 'submitted-without-choosing'
      }

      GOVUK.analytics.trackEvent('Radio button chosen', checkedValue, options)
    })
  }

  if (typeof global.ga !== 'undefined') {
    ga(function () {
      GOVUK.analyticsPlugins.radioButtonTracker($(document))
    })
  }

  global.GOVUK = GOVUK
})(window, document)
