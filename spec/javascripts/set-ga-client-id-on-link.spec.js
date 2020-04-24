/* global describe beforeEach it expect */

var $ = window.jQuery

describe('SetGaClientIdOnLink', function () {

  var GOVUK = window.GOVUK
  var tracker = { clientId: 'clientId' }
  tracker.get = function(arg) { return this[arg] }
  window.ga = function(callback) { callback(tracker) }
	var link

	beforeEach(function () {
		link = $(
			'<a class="gem-c-button govuk-button" role="button" href="https://some-service.batman.co.uk">Start now</a>'
		)
		setter = new GOVUK.SetGaClientIdOnLink({
			$link: link
		})
	})

	it('sets the _ga client id as a query param on the link action', function () {
		expect(link.attr('href')).toBe('https://some-service.batman.co.uk?_ga=clientId')
	})
})
