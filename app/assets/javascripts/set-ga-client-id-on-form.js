(function () {
  'use strict'

  window.GOVUK = window.GOVUK || {}
  var GOVUK = window.GOVUK

  function SetGaClientIdOnForm (form) {
    if (!form || !window.ga) { return }

    window.ga(function (tracker) {
      var clientId = tracker.get('clientId')
      var action = form.getAttribute('action')
      form.setAttribute('action', action + '?_ga=' + clientId)
    })
  }

  GOVUK.SetGaClientIdOnForm = SetGaClientIdOnForm
})(window, window.GOVUK)
