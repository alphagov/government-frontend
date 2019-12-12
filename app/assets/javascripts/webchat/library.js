(function (global) {
  'use strict'
  var $ = global.jQuery
  var windowOpen = global.open
  if (typeof global.GOVUK === 'undefined') { global.GOVUK = {} }
  var GOVUK = global.GOVUK


  function Webchat (options) {
    var POLL_INTERVAL = 5 * 1000
    var AJAX_TIMEOUT  = 5 * 1000
    var $el                 = $(options.$el)
    var chatProvider        = $el.attr('data-chat-provider')
    var openUrl             = $el.attr('data-open-url')
    var availabilityUrl     = $el.attr('data-availability-url')
    var $openButton         = $el.find('.js-webchat-open-button')
    var webchatStateClass   = 'js-webchat-advisers-'
    var intervalID          = null
    var lastRecordedState   = null
    var webchatProvider = null;

    if (chatProvider === "k2c") {
      webchatProvider = new Klick2Contact();
    } else {
      webchatProvider = new Egain({
        openUrl: openUrl
      });
    }

    function init () {
      if (!availabilityUrl || !openUrl) throw 'urls for webchat not defined'
      $openButton.on('click', handleOpenChat)
      intervalID = setInterval(checkAvailability, POLL_INTERVAL)
      checkAvailability()
    }

    function handleOpenChat (evt) {
      evt.preventDefault()
      webchatProvider.handleOpenChat(global)
      trackEvent('opened')
    }

    function checkAvailability () {
      var ajaxConfig = {
        url: availabilityUrl,
        type: 'GET',
        dataType: 'json',
        timeout: AJAX_TIMEOUT,
        success: apiSuccess,
        error: apiError
      }
      $.ajax(ajaxConfig)
    }

    function apiSuccess (result) {
      var state = webchatProvider.apiResponseSuccess(result)
      advisorStateChange(state.status)
    }

    function apiError (result) {
      clearInterval(intervalID)
      var state = webchatProvider.apiResponseError(result)
      advisorStateChange(state.status)
    }

    function advisorStateChange (state) {
      state = state.toLowerCase()
      var currentState = $el.find("." + webchatStateClass + state)
      $el.find('[class^="' + webchatStateClass + '"]').addClass('hidden')
      currentState.removeClass('hidden')
      trackEvent(state)
    }

    function trackEvent (state) {
      state = state.toLowerCase()
      if (lastRecordedState === state) return

      GOVUK.analytics.trackEvent('webchat', state)
      lastRecordedState = state
    }

    init()
  }

  global.GOVUK.Webchat = Webchat
})(window)
