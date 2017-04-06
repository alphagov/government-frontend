(function (global) {
  'use strict'
  var $ = global.jQuery
  var windowOpen = global.open
  if (typeof global.GOVUK === 'undefined') { global.GOVUK = {} }
  var GOVUK = global.GOVUK


  function Webchat (options) {
    var POLL_INTERVAL = 30 * 1000
    var AJAX_TIMEOUT  = 5 * 1000
    var API_STATES = [
      "BUSY",
      "UNAVAILABLE",
      "AVAILABLE",
      "ERROR"
    ]
    var $el                 = $(options.$el)
    var openUrl             = $el.attr('data-open-url')
    var availabilityUrl     = $el.attr('data-availability-url')
    var $openButton         = $el.find('.js-webchat-open-button')
    var webchatStateClass   = 'js-webchat-advisers-'
    var responseNormaliser  = options.responseNormalisation
    var intervalID          = null

    function init () {
      if (!availabilityUrl || !openUrl) throw 'urls for webchat not defined'
      $openButton.on('click', handleOpenChat)
      intervalID = setInterval(checkAvailability, POLL_INTERVAL)
      checkAvailability()
    }

    function handleOpenChat (evt) {
      evt.preventDefault()
      global.open(openUrl, 'newwin', 'width=200,height=100')
      GOVUK.analytics.trackEvent('webchat', 'opened')
    }

    function checkAvailability () {
      var ajaxConfig = {
        url: availabilityUrl,
        type: 'GET',
        timeout: AJAX_TIMEOUT,
        success: apiSuccess,
        error: apiError
      }
      $.ajax(ajaxConfig)
    }

    function apiSuccess (result) {
      if (responseNormaliser) result = responseNormaliser(result)

      var validState  = API_STATES.indexOf(result.response) != -1
      var state       = validState ? result.response : "ERROR"
      advisorStateChange(state)
    }

    function apiError () {
      clearInterval(intervalID)
      advisorStateChange('ERROR')
    }

    function advisorStateChange (state) {
      var currentState = $el.find("." + webchatStateClass + state.toLowerCase())
      $el.find('[class^="' + webchatStateClass + '"]').addClass('hidden')
      currentState.removeClass('hidden')
      GOVUK.analytics.trackEvent('webchat', state)
    }

    init()
  }

  global.GOVUK.Webchat = Webchat
})(window)
