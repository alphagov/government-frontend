(function () {
  'use strict'

  window.GOVUK = window.GOVUK || {}
  var GOVUK = window.GOVUK

  function SetGaClientIdOnForm (options) {
    if (!options.$form || !window.ga) { return }

    var form = options.$form

    window.ga(function(tracker) {
      var clientId = tracker.get('clientId')
      var action = form.attr('action')
      form.attr('action', action + "?_ga=" + clientId)
    });
  }

  GOVUK.SetGaClientIdOnForm = SetGaClientIdOnForm
})(window, window.GOVUK);
