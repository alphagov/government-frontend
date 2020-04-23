(function() {
  'use strict'

  window.GOVUK = window.GOVUK || {}
  var GOVUK = window.GOVUK

  function SetGaClientIdOnLink (options) {
    if (!options.$link || !window.ga) { return }

    var link = options.$link

    window.ga(function(tracker) {
      var clientId = tracker.get('clientId')
      var href = link.attr('href')
      link.attr('href', href + "?_ga=" + clientId)
    })
  }

  GOVUK.SetGaClientIdOnLink = SetGaClientIdOnLink
})(window, window.GOVUK);
