/* globals lolex, setFixtures */

var $ = window.jQuery
var POLL_INTERVAL = '6' // Offset by one

describe('Webchat', function () {
  var GOVUK = window.GOVUK
  // Stub analytics.
  GOVUK.analytics = GOVUK.analytics || {}
  GOVUK.analytics.trackEvent = function () {}
  var CHILD_BENEFIT_API_URL = 'https://hmrc-uk.digital.nuance.com/tagserver/launch/agentAvailability?agentGroupID=10006859&siteID=10006719&businessUnitID=19001235'

  var INSERTION_HOOK = '<div class="js-webchat" data-availability-url="' + CHILD_BENEFIT_API_URL + '" data-open-url="' + CHILD_BENEFIT_API_URL + '" data-redirect="true">' +
    '<div class="js-webchat-advisers-error">Error</div>' +
    '<div class="js-webchat-advisers-unavailable govuk-!-display-none">Unavailable</div>' +
    '<div class="js-webchat-advisers-busy govuk-!-display-none">Busy</div>' +
    '<div class="js-webchat-advisers-available govuk-!-display-none">' +
      'Available, <div class="js-webchat-open-button">chat now</div>' +
    '</div>' +
  '</div>'
  var $webchat
  var $advisersUnavailable
  var $advisersBusy
  var $advisersAvailable
  var $advisersError

  var jsonNormalised = function (status, response) {
    return {
      status: status,
      response: response
    }
  }

  var jsonNormalisedAvailable = jsonNormalised('success', 'AVAILABLE')
  var jsonNormalisedUnavailable = jsonNormalised('success', 'UNAVAILABLE')
  var jsonNormalisedBusy = jsonNormalised('success', 'BUSY')
  var jsonNormalisedError = '404 not found'

  beforeEach(function () {
    setFixtures(INSERTION_HOOK)
    $webchat = $('.js-webchat')
    $advisersUnavailable = $webchat.find('.js-webchat-advisers-unavailable')
    $advisersBusy = $webchat.find('.js-webchat-advisers-busy')
    $advisersAvailable = $webchat.find('.js-webchat-advisers-available')
    $advisersError = $webchat.find('.js-webchat-advisers-error')
  })

  describe('on valid application locations', function () {
    function mount () {
      $webchat.map(function () {
        return new GOVUK.Webchat({
          $el: $(this),
          location: '/government/organisations/hm-revenue-customs/contact/child-benefit',
          pollingEnabled: true
        })
      })
    }

    it('should poll for availability', function () {
      spyOn(XMLHttpRequest.prototype, 'open').and.callThrough()
      spyOn(XMLHttpRequest.prototype, 'send').and.callThrough()
      mount()
      expect(
        XMLHttpRequest.prototype.open
      ).toHaveBeenCalledWith('GET', CHILD_BENEFIT_API_URL, true)
    })

    it('should inform user whether advisors are available', function () {
      spyOn(XMLHttpRequest.prototype, 'open').and.callThrough()
      spyOn(XMLHttpRequest.prototype, 'send').and.returnValue(jsonNormalisedAvailable)
      mount()
      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(false)

      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersError.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(true)
    })

    it('should inform user whether advisors are unavailable', function () {
      spyOn(XMLHttpRequest.prototype, 'open').and.callThrough()
      spyOn(XMLHttpRequest.prototype, 'send').and.returnValue(jsonNormalisedUnavailable)
      mount()
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(false)

      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersError.hasClass('govuk-!-display-none')).toBe(true)
    })

    it('should inform user whether advisors are busy', function () {
      spyOn(XMLHttpRequest.prototype, 'open').and.callThrough()
      spyOn(XMLHttpRequest.prototype, 'send').and.returnValue(jsonNormalisedBusy)
      mount()
      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(false)

      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersError.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(true)
    })

    it('should inform user whether there was an error', function () {
      spyOn(XMLHttpRequest.prototype, 'open').and.callThrough()
      spyOn(XMLHttpRequest.prototype, 'send').and.returnValue(jsonNormalisedError)
      mount()
      expect($advisersError.hasClass('govuk-!-display-none')).toBe(false)

      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(true)
    })

    it('should only track once per state change', function () {
      var analyticsExpects = ['available', 'error']
      var analyticsReceived = []
      var analyticsCalled = 0
      var clock = lolex.install()
      spyOn(XMLHttpRequest.prototype, 'open').and.callThrough()
      spyOn(XMLHttpRequest.prototype, 'send').and.returnValue(jsonNormalisedAvailable)

      spyOn(GOVUK.analytics, 'trackEvent').and.callFake(function (webchatKey, webchatValue) {
        analyticsReceived.push(webchatValue)
        analyticsCalled++
      })

      mount()
      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(false)

      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersError.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(true)

      clock.tick(POLL_INTERVAL)

      expect($advisersError.hasClass('govuk-!-display-none')).toBe(false)
      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(true)
      expect(analyticsCalled).toBe(2)
      expect(analyticsReceived).toEqual(analyticsExpects)
      clock.tick(POLL_INTERVAL)
      expect(analyticsCalled).toBe(2)
      expect(analyticsReceived).toEqual(analyticsExpects)
      clock.uninstall()
    })
  })
})
