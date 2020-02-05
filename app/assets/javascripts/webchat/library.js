(function (global) {
  'use strict'
  var $ = global.jQuery
  var windowOpen = global.open
  if (typeof global.GOVUK === 'undefined') { global.GOVUK = {} }
  var GOVUK = global.GOVUK


  function Webchat (options) {
    var POLL_INTERVAL = 5 * 1000
    var AJAX_TIMEOUT  = 5 * 1000
    var API_STATES = [
      "BUSY",
      "UNAVAILABLE",
      "AVAILABLE",
      "ERROR",
      "OFFLINE",
      "ONLINE"
    ]
    var $el                 = $(options.$el)
    var openUrl             = $el.attr('data-open-url')
    var availabilityUrl     = $el.attr('data-availability-url')
    var $openButton         = $el.find('.js-webchat-open-button')
    var webchatStateClass   = 'js-webchat-advisers-'
    var intervalID          = null
    var lastRecordedState   = null

    function init () {
      if (!availabilityUrl || !openUrl) throw 'urls for webchat not defined'
      $openButton.on('click', handleOpenChat)
      intervalID = setInterval(checkAvailability, POLL_INTERVAL)
      checkAvailability()
    }

    function handleOpenChat (evt) {
      evt.preventDefault()
      this.dataset.redirect == "true" ? window.location.href = openUrl : global.open(openUrl, 'newwin', 'width=366,height=516')
      trackEvent('opened')
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

      if(result.hasOwnProperty('inHOP')){
        var validState  = API_STATES.indexOf(result.status.toUpperCase()) != -1
        var state       = validState ? result.status : "ERROR"
        if (result.inHOP == "true"){
          if(result.availability == "true"){
                  if(result.status == "online"){
                    state="AVAILABLE"
                  }
                  if (result.status == "busy"){
                      state="AVAILABLE"
                  }
                  if (result.status == "offline"){
                      state="UNAVAILABLE"
                  }
            }else{
              if (result.status == "busy"){
                  state="BUSY"
              }else{
                state="UNAVAILABLE"
              }
            }
          }else{
            state = "UNAVAILABLE"
          }
        }else{
          var validState  = API_STATES.indexOf(result.response) != -1
          var state       = validState ? result.response : "ERROR"
        }
      advisorStateChange(state)
    }

    function apiError () {
      clearInterval(intervalID)
      advisorStateChange('ERROR')
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
