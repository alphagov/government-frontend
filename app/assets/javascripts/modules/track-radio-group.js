window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (global, GOVUK) {
  'use strict'

  var $ = global.jQuery

  GOVUK.Modules.TrackRadioGroup = function () {
    this.start = function (element) {
      element.on('submit', function (event) {
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
  }
})(window, window.GOVUK)
