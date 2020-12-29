/* global describe beforeEach it spyOn expect */

var $ = window.jQuery

describe('Track Briefing', function () {

  var GOVUK = window.GOVUK
  var tracker
  var element

  GOVUK.analytics = GOVUK.analytics || {}
  GOVUK.analytics.trackEvent = function () {}

  describe('Single link', function () {
    beforeEach(function () {
      spyOn(GOVUK.analytics, 'trackEvent')
  
      element = document.createElement('div')
      element.innerHTML = '<a href="/blah/blahhhh">Blahh</a>'
  
      tracker = new GOVUK.Modules.TrackBriefing()
      tracker.start($(element))
    })

    afterEach(function () {
      GOVUK.analytics.trackEvent.calls.reset()
    })
  
    it('send ga event when link is clicked', function () {
      element.querySelector('a').dispatchEvent(new Event('click'))
  
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'Briefings page', 'Blahh', { transport: 'beacon', label: "/blah/blahhhh" }
      )
    })
  })

  describe('Multiple links', function () {
    beforeEach(function () {
      spyOn(GOVUK.analytics, 'trackEvent')
  
      element = document.createElement('div')
      element.innerHTML = '<a href="/blah/blahhhh">Blahh</a>'
      element.innerHTML += '<a href="/blah/blahhhh2">Blahh2</a>'
      element.innerHTML += '<a href="https://www.external-link.com">External link blahhh</a>'
  
      tracker = new GOVUK.Modules.TrackBriefing()
      tracker.start($(element))
    })

    afterEach(function () {
      GOVUK.analytics.trackEvent.calls.reset()
    })
  
    it('send ga event when link is clicked', function () {
      element
        .querySelectorAll('a')
        .forEach(function(link) {
          link.dispatchEvent(new Event('click'))
        })
  
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'Briefings page', 'Blahh', { transport: 'beacon', label: "/blah/blahhhh" }
      )
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'Briefings page', 'Blahh2', { transport: 'beacon', label: "/blah/blahhhh2" }
      )
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'Briefings page', 'External link blahhh', { transport: 'beacon', label: "https://www.external-link.com" }
      )
    })
  })
})
