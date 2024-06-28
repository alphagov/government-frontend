(function (global) {
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
    var openButton = document.querySelector('.js-webchat-open-button')
    var webchatStateClass = 'js-webchat-advisers-'
    var intervalID = null

    function init () {
      if (!availabilityUrl || !openUrl) {
        throw Error.new('urls for webchat not defined', window.location.href)
      }

      if (openButton) {
        openButton.addEventListener('click', handleOpenChat)
      }
      intervalID = setInterval(checkAvailability, POLL_INTERVAL)
      checkAvailability()
    }

    function handleOpenChat (evt) {
      evt.preventDefault()
      var redirect = this.getAttribute('data-redirect')
      redirect === 'true' ? window.location.href = openUrl : window.open(openUrl, 'newwin', 'width=366,height=516')
    }

    function checkAvailability () {
      var done = function () {
        if (request.readyState === 4 && request.status === 200) {
          apiSuccess(JSON.parse(request.response))
        } else {
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
      var currentState = el.querySelector('[class^="' + webchatStateClass + state + '"]')
      var allStates = el.querySelectorAll('[class^="' + webchatStateClass + '"]')

      for (var index = 0; index < allStates.length; index++) {
        allStates[index].classList.add('govuk-!-display-none')
      }
      currentState.classList.remove('govuk-!-display-none')
    }

    init()
  }

  global.GOVUK.Webchat = Webchat
})(window)
