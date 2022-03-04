(function (global) {
  var GOVUK = global.GOVUK || {}

  function Webchat (el) {
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
      var done = function () {
        console.log('request', request)
        console.log('request.response', request.response)
        if (request.readyState === 4 && request.status === 200) {
          console.log('done, apiSuccess')
          console.log('done, request.response', request.response)
          console.log('done, request.response json parse', JSON.parse(request.response))
          apiSuccess(JSON.parse(request.response))
        } else {
          console.log('done, apiError')
          apiError()
        }
      }

      var request = new XMLHttpRequest()
      request.open('GET', availabilityUrl, true)
      request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
      request.addEventListener('load', done.bind(this))
      request.timeout = AJAX_TIMEOUT

      request.send()
    }

    function apiSuccess (result) {
      var validState, state

      console.log('result', result)
      if (Object.prototype.hasOwnProperty.call(result, 'inHOP')) {
        console.log('Has inHOP property')
        validState = API_STATES.indexOf(result.status.toUpperCase()) !== -1
        console.log('validState in inHOP check', validState)
        state = validState ? result.status : 'ERROR'
        console.log('state in inHOP check', state)
        if (result.inHOP === 'true') {
          console.log('result.inHOP is true')
          if (result.availability === 'true') {
            console.log('result.availability is true')
            if (result.status === 'online') {
              console.log('result.status is online')
              state = 'AVAILABLE'
            }
            if (result.status === 'busy') {
              console.log('result.status is busy')
              state = 'AVAILABLE'
            }
            if (result.status === 'offline') {
              console.log('result.status is offline')
              state = 'UNAVAILABLE'
            }
          } else {
            console.log('result.availability is false')
            if (result.status === 'busy') {
              console.log('result.status is busy')
              state = 'BUSY'
            } else {
              console.log('else result.status is set to unavailable')
              state = 'UNAVAILABLE'
            }
          }
        } else {
          console.log('result.inHOP is false')
          state = 'UNAVAILABLE'
        }
      } else {
        console.log('No inHOP property')
        console.log('result.response', result.response)
        validState = API_STATES.indexOf(result.response) !== -1
        console.log('validState', validState)
        state = validState ? result.response : 'ERROR'
        console.log('state', state)
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
