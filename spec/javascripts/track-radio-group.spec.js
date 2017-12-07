/* global describe beforeEach it spyOn expect */

var $ = window.jQuery

describe('A radio group tracker', function () {
  'use strict'

  var GOVUK = window.GOVUK
  var tracker
  var element

  GOVUK.analytics = GOVUK.analytics || {}
  GOVUK.analytics.trackEvent = function () {}

  beforeEach(function () {
    spyOn(GOVUK.analytics, 'trackEvent')

    element = $(
      '<div>' +
        '<form onsubmit="event.preventDefault()">' +
          '<input type="radio" name="sign-in-option" value="government-gateway">' +
          '<input type="radio" name="sign-in-option" value="govuk-verify">' +
          '<input type="radio" name="sign-in-option" value="lost-account-details">' +
          '<button>Submit</button>' +
        '</form>' +
      '</div>'
    )

    tracker = new GOVUK.Modules.TrackRadioGroup()
    tracker.start(element)
  })

  it('tracks government-gateway checked radio when clicking submit', function () {
    element.find('input[value="government-gateway"]').trigger('click')
    element.find('form').trigger('submit')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'government-gateway', { transport: 'beacon' }
    )
  })

  it('tracks govuk-verify checked radio when clicking submit', function () {
    element.find('input[value="govuk-verify"]').trigger('click')
    element.find('form').trigger('submit')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'govuk-verify', { transport: 'beacon' }
    )
  })

  it('tracks no choice when clicking submit and checked nothing', function () {
    element.find('form').trigger('submit')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'Radio button chosen', 'submitted-without-choosing', { transport: 'beacon' }
    )
  })
})
