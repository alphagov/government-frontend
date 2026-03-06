/* globals setFixtures */

var $ = window.jQuery

xdescribe('Webchat', function () {
  var GOVUK = window.GOVUK

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
      status: 200,
      response: '{"status":"' + status + '","response":"' + response + '"}'
    }
  }

  var jsonNormalisedAvailable = jsonNormalised('success', 'AVAILABLE')
  var jsonNormalisedUnavailable = jsonNormalised('success', 'UNAVAILABLE')
  var jsonNormalisedBusy = jsonNormalised('success', 'BUSY')
  var jsonNormalisedError = [404, {}, '404 not found']

  beforeEach(function () {
    jasmine.Ajax.install()
    setFixtures(INSERTION_HOOK)
    $webchat = $('.js-webchat')
    $advisersUnavailable = $webchat.find('.js-webchat-advisers-unavailable')
    $advisersBusy = $webchat.find('.js-webchat-advisers-busy')
    $advisersAvailable = $webchat.find('.js-webchat-advisers-available')
    $advisersError = $webchat.find('.js-webchat-advisers-error')
  })

  afterEach(function () {
    jasmine.Ajax.uninstall()
  })

  describe('on valid application locations', function () {
    function mount () {
      var webchats = document.querySelectorAll('.js-webchat')
      for (var i = 0; i < webchats.length; i++) {
        /* eslint-disable no-new */
        new GOVUK.Webchat(webchats[i])
      }
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
      mount()
      jasmine.Ajax.requests.mostRecent().respondWith(jsonNormalisedAvailable)
      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(false)

      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersError.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(true)
    })

    it('should inform user whether advisors are unavailable', function () {
      mount()
      jasmine.Ajax.requests.mostRecent().respondWith(jsonNormalisedUnavailable)
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(false)

      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersError.hasClass('govuk-!-display-none')).toBe(true)
    })

    it('should inform user whether advisors are busy', function () {
      mount()
      jasmine.Ajax.requests.mostRecent().respondWith(jsonNormalisedBusy)
      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(false)

      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersError.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(true)
    })

    it('should inform user whether there was an error', function () {
      mount()
      jasmine.Ajax.requests.mostRecent().respondWith(jsonNormalisedError)

      expect($advisersError.hasClass('govuk-!-display-none')).toBe(false)

      expect($advisersAvailable.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersBusy.hasClass('govuk-!-display-none')).toBe(true)
      expect($advisersUnavailable.hasClass('govuk-!-display-none')).toBe(true)
    })
  })
})
