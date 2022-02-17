(function (global) {
  var GOVUK = global.GOVUK || {}

  function Webchat (options) {
    var POLL_INTERVAL = 5 * 1000
    var AJAX_TIMEOUT = 5 * 1000
    var API_STATES = [
      'BUSY',
      'UNAVAILABLE',
      'AVAILABLE',
      'ERROR',
      'OFFLINE',
      'ONLINE'
    ]
    var el = options.$el[0]
    var openUrl = el.getAttribute('data-open-url')
    var availabilityUrl = el.getAttribute('data-availability-url')
    var redirectUrl = el.getAttribute('data-redirect')
    var webchatStateClass = 'js-webchat-advisers-'
    var intervalID = null
    var lastRecordedState = null

    function init () {
      if (!availabilityUrl || !openUrl) {
        throw Error.new('urls for webchat not defined')
      }

      if (redirectUrl === true) {
        var openButton = document.getElementsByClassName('.js-webchat-open-button')[0]
        openButton.addEventListener('click', handleOpenChat)
      }
      intervalID = setInterval(checkAvailability, POLL_INTERVAL)
      checkAvailability()
    }

    function handleOpenChat (evt) {
      evt.preventDefault()
      var redirect = this.getAttribute('data-redirect')
      redirect === 'true' ? window.location.href = openUrl : window.open(openUrl, 'newwin', 'width=366,height=516')
      trackEvent('opened')
    }

    function checkAvailability () {
      var request = new XMLHttpRequest()
      request.open('GET', availabilityUrl, true)
      request.setRequestHeader('Access-Control-Allow-Header', '*')
      request.timeout = AJAX_TIMEOUT
      request.send()

      request.onreadystatechange = function () {
        if (request.readyState === XMLHttpRequest.DONE) {
          if (request.status === 0 || (request.status > 200 && request.status < 400)) {
            apiSuccess(request.response.json)
          } else {
            apiError()
          }
        }
      }
    }

    function apiSuccess (result) {
      var validState, state

      if (Object.prototype.hasOwnProperty.call(result, 'inHOP')) {
        validState = API_STATES.indexOf(result.status.toUpperCase()) !== -1
        state = validState ? result.status : 'ERROR'
        if (result.inHOP === 'true') {
          if (result.availability === 'true') {
            if (result.status === 'online') {
              state = 'AVAILABLE'
            }
            if (result.status === 'busy') {
              state = 'AVAILABLE'
            }
            if (result.status === 'offline') {
              state = 'UNAVAILABLE'
            }
          } else {
            if (result.status === 'busy') {
              state = 'BUSY'
            } else {
              state = 'UNAVAILABLE'
            }
          }
        } else {
          state = 'UNAVAILABLE'
        }
      } else {
        validState = API_STATES.indexOf(result.response) !== -1
        state = validState ? result.response : 'ERROR'
      }
      advisorStateChange(state)
    }

    function apiError () {
      clearInterval(intervalID)
      advisorStateChange('ERROR')
    }

    function advisorStateChange (state) {
      state = state.toLowerCase()
      var currentState = el.querySelectorAll('[class^="' + webchatStateClass + state + '"]')[0]
      var allStates = el.querySelectorAll('[class^="' + webchatStateClass + '"]')

      for (var index = 0; index < allStates.length; index++) {
        allStates[index].classList.add('govuk-!-display-none')
      }
      currentState.classList.remove('govuk-!-display-none')
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
