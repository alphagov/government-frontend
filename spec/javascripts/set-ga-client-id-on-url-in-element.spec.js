/* global describe beforeEach it expect */

var $ = window.jQuery

describe('SetGaClientIdOnUrlInElement', function () {
  var GOVUK = window.GOVUK
  var tracker = { clientId: 'clientId' }
  tracker.get = function(arg) { return this[arg] }
  window.ga = function(callback) { callback(tracker) }

  describe('for a Start Button link', function() {
    var linkedElement
    var attribute = 'href'

    beforeEach(function () {
      linkedElement = $(
        '<a class="gem-c-button govuk-button" role="button" href="https://some-service.batman.co.uk">Start now</a>'
      )

      setter = new GOVUK.SetGaClientIdOnUrlInElement({
        $linkedElement: linkedElement,
        attribute: attribute
      })
    })

    it('sets the _ga client id as a query param on the linked element action', function () {
      expect(linkedElement.attr(attribute)).toBe('https://some-service.batman.co.uk?_ga=clientId')
    })
  })

  describe('for a form action', function() {
    var form
    var attribute = 'action'

    beforeEach(function () {
      form = $(
        '<form class="js-service-sign-in-form" action="/endpoint"></form>'
      )

      setter = new GOVUK.SetGaClientIdOnUrlInElement({
        $linkedElement: form,
        attribute: attribute
      })
    })

    it('sets the _ga client id as a query param on the form action', function () {
      expect(form.attr('action')).toBe('/endpoint?_ga=clientId')
    })
  })
})
