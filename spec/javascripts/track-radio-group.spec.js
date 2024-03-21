var $ = window.jQuery

describe('A radio group tracker', function () {
  var GOVUK = window.GOVUK
  var element

  GOVUK.analytics = GOVUK.analytics || {}
  GOVUK.analytics.trackEvent = function () {}
  GOVUK.analytics.addLinkedTrackerDomain = function () {}

  beforeEach(function () {
    spyOn(GOVUK.analytics, 'trackEvent')

    element = $(
      '<form onsubmit="event.preventDefault()">' +
        '<input type="radio" name="sign-in-option" value="government-gateway">' +
        '<input type="radio" name="sign-in-option" value="govuk-verify">' +
        '<input type="radio" name="sign-in-option" value="create-an-account">' +
        '<button>Submit</button>' +
      '</form>'
    )

    $('body').append(element)

    /* eslint-disable no-new */
    new GOVUK.Modules.TrackRadioGroup(element[0])
  })

  afterEach(function () {
    element.remove()
  })

  it('tracks government-gateway checked radio when clicking submit', function () {
    element.find('input[value="government-gateway"]').trigger('click')
    element.find('button').trigger('click')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'government-gateway', { transport: 'beacon' }
    )
  })

  it('tracks govuk-verify checked radio when clicking submit', function () {
    element.find('input[value="govuk-verify"]').trigger('click')
    element.find('button').trigger('click')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify', { transport: 'beacon' }
    )
  })

  it('tracks no choice when clicking submit and checked nothing', function () {
    element.find('button').trigger('click')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'submitted-without-choosing', { transport: 'beacon' }
    )
  })

  describe('cross domain tracking enabled', function () {
    beforeEach(function () {
      spyOn(GOVUK.analytics, 'addLinkedTrackerDomain')

      element.attr('data-tracking-code', 'UA-xxxxxx')
      element.attr('data-tracking-domain', 'test.service.gov.uk')
      element.attr('data-tracking-name', 'testTracker')

      /* eslint-disable no-new */
      new GOVUK.Modules.TrackRadioGroup(element[0])
    })

    it('adds a linked tracker as the module is started', function () {
      expect(GOVUK.analytics.addLinkedTrackerDomain).toHaveBeenCalledWith(
        'UA-xxxxxx', 'testTracker', 'test.service.gov.uk'
      )
    })

    it('sends an event to the linked tracker when the form is submitted', function () {
      element.find('input[value="govuk-verify"]').trigger('click')
      element.find('button').trigger('click')

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'Radio button chosen', 'govuk-verify', { trackerName: 'testTracker', transport: 'beacon' }
      )
    })
  })
})
