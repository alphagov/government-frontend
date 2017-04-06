(function (global) {
  'use strict'
  var $ = global.jQuery
  var windowLocationPathname = global.location.pathname
  var windowOpen = global.open
  if (typeof global.GOVUK === 'undefined') { global.GOVUK = {} }
  var GOVUK = global.GOVUK



  var CODE_AGENTS_AVAILABLE = 0
  var CODE_AGENTS_UNAVAILABLE = 1
  var CODE_AGENTS_BUSY = 2
  var POLL_INTERVAL = 15 * 1000
  var AJAX_TIMEOUT = 5 * 1000

  function Webchat (options) {
    var $el = $(options.$el)

    var endPoints = options.endPoints
    if (!endPoints.proxyUrl || !endPoints.openUrl) throw 'no urls defined'
    var location = options.location || windowLocationPathname

    var $advisersUnavailable = $el.find('.js-webchat-advisers-unavailable')
    var $advisersBusy = $el.find('.js-webchat-advisers-busy')
    var $advisersAvailable = $el.find('.js-webchat-advisers-available')
    var $advisersError = $el.find('.js-webchat-advisers-error')
    var $openButton = $el.find('.js-webchat-open-button')
    var pollingEnabled = options.pollingEnabled

    pollAvailability()

    $openButton.on('click', handleOpenChat)

    function pollAvailability () {
      checkAvailability()

      setTimeout(function () {
        if (pollingEnabled) {
          pollAvailability()
        }
      }, POLL_INTERVAL)
    }

    function checkAvailability () {
      $.ajax({
        url: endPoints.proxyUrl,
        type: 'GET',
        timeout: AJAX_TIMEOUT,
        success: handleApiCallSuccess,
        error: handleApiCallError
      })
    }

    function handleApiCallSuccess (result) {
      var actions = {
        "BUSY":  handleAdvisersBusy,
        "UNAVAILABLE": handleAdvisersAvailable,
        "AVAILABLE": handleAdvisersAvailable,
        "UNKNOWN": handleApiCallError
      }

      var action = actions[result.response]
      if (!action) action = actions['UNKNOWN']
      action()
    }

    function handleApiCallError () {
      pollingEnabled = false
      handleAdvisersError()
    }

    function handleOpenChat (evt) {
      evt.preventDefault()
      var url = endPoints.openUrl
      windowOpen(url, 'newwin', 'width=200,height=100')

      GOVUK.analytics.trackEvent('webchat', 'accepted')
    }

    function handleAdvisersError () {
      $advisersError.removeClass('hidden')

      $advisersAvailable.addClass('hidden')
      $advisersBusy.addClass('hidden')
      $advisersUnavailable.addClass('hidden')

      GOVUK.analytics.trackEvent('webchat', 'error')
    }

    function handleAdvisersUnavailable () {
      $advisersUnavailable.removeClass('hidden')

      $advisersAvailable.addClass('hidden')
      $advisersBusy.addClass('hidden')
      $advisersError.addClass('hidden')

      GOVUK.analytics.trackEvent('webchat', 'unavailable')
    }

    function handleAdvisersBusy () {
      $advisersBusy.removeClass('hidden')

      $advisersUnavailable.addClass('hidden')
      $advisersAvailable.addClass('hidden')
      $advisersError.addClass('hidden')

      GOVUK.analytics.trackEvent('webchat', 'busy')
    }

    function handleAdvisersAvailable () {
      $advisersAvailable.removeClass('hidden')

      $advisersBusy.addClass('hidden')
      $advisersError.addClass('hidden')
      $advisersUnavailable.addClass('hidden')

      GOVUK.analytics.trackEvent('webchat', 'offered')
    }
  }

  GOVUK.Webchat = Webchat
})(window)
