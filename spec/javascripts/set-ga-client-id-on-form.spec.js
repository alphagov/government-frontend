var $ = window.jQuery

describe('SetGaClientIdOnForm', function () {
  var GOVUK = window.GOVUK
  var mockTracker = { clientId: 'clientId' }
  mockTracker.get = function (arg) { return this[arg] }
  window.ga = function (callback) { callback(mockTracker) }
  var form

  beforeEach(function () {
    form = $(
      '<form class="js-service-sign-in-form" action="/endpoint"></form>'
    )
    new GOVUK.SetGaClientIdOnForm(form[0]) // eslint-disable-line no-new
  })

  it('sets the _ga client id as a query param on the form action', function () {
    expect(form.attr('action')).toBe('/endpoint?_ga=clientId')
  })
})
