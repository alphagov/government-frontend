describe('Test variant tracker', function () {
  'use strict'

  var tracker,
    element,
    FakeCookielessTracker,
    gaSpy

  beforeEach(function () {
    GOVUK.cookie('cookies_preferences_set', null)
    gaSpy = jasmine.createSpyObj('initGa', ['send'])

    FakeCookielessTracker = function (trackingId, fieldsObject) {}
    FakeCookielessTracker.prototype.trackEvent = function (category, action, options) {
      gaSpy.send(category, action, options)
    }

    GOVUK.Modules.CookielessTracker = FakeCookielessTracker

    tracker = new GOVUK.Modules.TrackVariant()
  })

  afterEach(function () {
    GOVUK.Modules.CookielessTracker = null
  })

  it('tracks A variant', function () {
    element = $('<meta name="Cookieless-Variant" content="A" data-module="track-variant">')

    tracker.start(element)

    expect(gaSpy.send).toHaveBeenCalledWith('cookieless', 'hit', {
      trackerName: 'CookielessTracker',
      label: 'A',
      javaEnabled: false,
      language: ''
    })
  })

  it('tracks B variant', function () {
    element = $('<meta name="Cookieless-Variant" content="B" data-module="track-variant">')

    tracker.start(element)

    expect(gaSpy.send).toHaveBeenCalledWith('cookieless', 'hit', {
      trackerName: 'CookielessTracker',
      label: 'B',
      javaEnabled: false,
      language: ''
    })
  })

  it('does not track variant if cookie is set', function () {
    GOVUK.cookie('cookies_preferences_set', true)
    element = $('<meta name="Cookieless-Variant" content="Z" data-module="track-variant">')

    tracker.start(element)

    expect(gaSpy.send).not.toHaveBeenCalled()
  })
})
