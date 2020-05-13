/* global describe beforeEach it expect */

var $ = window.jQuery

describe('SetGaClientIdOnForm', function () {

  var GOVUK = window.GOVUK
  var tracker = { clientId: 'clientId' }
  tracker.get = function(arg) { return this[arg] }
  window.ga = function(callback) { callback(tracker) }
  var form

  beforeEach(function () {
    form = $(
      '<form class="js-service-sign-in-form" action="/endpoint"></form>'
    )
    setter = new GOVUK.SetGaClientIdOnForm({ $form: form })
  })

  it('sets the _ga client id as a query param on the form action', function () {
    expect(form.attr('action')).toBe('/endpoint?_ga=clientId')
  })
})
