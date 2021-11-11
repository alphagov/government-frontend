var $ = window.jQuery

describe('A radio group tracker', function () {
  var GOVUK = window.GOVUK
  var tracker
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

    tracker = new GOVUK.Modules.TrackRadioGroup(element[0])
    tracker.init()
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

  it('tracks govuk-verify-with-hint event when clicking submit if user has visited verify', function () {
    var data = {
      status: 'OK',
      value: true
    }
    tracker.trackVerifyUser(element, data)
    element.find('input[value="govuk-verify"]').trigger('click')
    element.find('button').trigger('click')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'verify-hint', 'shown', { transport: 'beacon' }
    )
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify', { transport: 'beacon' }
    )
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify-with-hint', { transport: 'beacon' }
    )
  })

  it('does not track govuk-verify-with-hint event when clicking submit if user has not visited verify', function () {
    var data = {
      status: 'OK',
      value: false
    }
    tracker.trackVerifyUser(element, data)
    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalledWith(
      'verify-hint', 'shown', { transport: 'beacon' }
    )
    element.find('input[value="govuk-verify"]').trigger('click')
    element.find('button').trigger('click')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify', { transport: 'beacon' }
    )
    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify-with-hint', { transport: 'beacon' }
    )
  })

  it('does not track govuk-verify-with-hint event when clicking submit if verify value is not boolean', function () {
    var data = {
      status: 'OK',
      value: 'bar'
    }
    tracker.trackVerifyUser(element, data)
    element.find('input[value="govuk-verify"]').trigger('click')
    element.find('button').trigger('click')

    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalledWith(
      'verify-hint', 'shown', { transport: 'beacon' }
    )
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify', { transport: 'beacon' }
    )
    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify-with-hint', { transport: 'beacon' }
    )
  })

  it('does not track govuk-verify-with-hint event when clicking submit if verify response is null', function () {
    var data = null
    tracker.trackVerifyUser(element, data)
    element.find('input[value="govuk-verify"]').trigger('click')
    element.find('button').trigger('click')

    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalledWith(
      'verify-hint', 'shown', { transport: 'beacon' }
    )
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify', { transport: 'beacon' }
    )
    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify-with-hint', { transport: 'beacon' }
    )
  })

  it('does not track govuk-verify-with-hint event when clicking submit if verify response is not an object', function () {
    var data = 'string'
    tracker.trackVerifyUser(element, data)
    element.find('input[value="govuk-verify"]').trigger('click')
    element.find('button').trigger('click')

    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalledWith(
      'verify-hint', 'shown', { transport: 'beacon' }
    )
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify', { transport: 'beacon' }
    )
    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify-with-hint', { transport: 'beacon' }
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
      tracker.trackVerifyUser(element, { status: 'OK', value: true })

      spyOn(GOVUK.analytics, 'addLinkedTrackerDomain')

      element.attr('data-tracking-code', 'UA-xxxxxx')
      element.attr('data-tracking-domain', 'test.service.gov.uk')
      element.attr('data-tracking-name', 'testTracker')

      tracker = new GOVUK.Modules.TrackRadioGroup(element[0])
      tracker.init()
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
        'Radio button chosen', 'govuk-verify-with-hint', { trackerName: 'testTracker', transport: 'beacon' }
      )
    })
  })
})
