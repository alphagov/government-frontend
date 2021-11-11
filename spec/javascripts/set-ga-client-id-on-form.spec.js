var $ = window.jQuery

describe('SetGaClientIdOnForm', function () {
  var GOVUK = window.GOVUK
  var mockTracker = { clientId: 'clientId' }
  mockTracker.get = function (arg) { return this[arg] }
  window.ga = function (callback) { callback(mockTracker) }
  var form

  beforeEach(function () {
    form = $('<form action="/endpoint"></form>')
    var setId = new GOVUK.Modules.SetGaClientIdOnForm(form[0])
    setId.init()
  })

  it('sets the _ga client id as a query param on the form action', function () {
    expect(form.attr('action')).toBe('/endpoint?_ga=clientId')
  })
})
