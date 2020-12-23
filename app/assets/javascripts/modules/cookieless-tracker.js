window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  var CookielessTracker = function (trackingId, fieldsObject) {
    var trackerName = fieldsObject.name + '.'

    function configureProfile () {
      // https://developers.google.com/analytics/devguides/collection/analyticsjs/command-queue-reference#create
      sendToGa('create', trackingId, fieldsObject)
    }

    function anonymizeIp () {
      // https://developers.google.com/analytics/devguides/collection/analyticsjs/advanced#anonymizeip
      sendToGa(trackerName + 'set', 'anonymizeIp', true)
    }

    function disableAdFeatures () {
      // https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference#allowAdFeatures
      sendToGa(trackerName + 'set', 'allowAdFeatures', false)
    }

    function stripTitlePII () {
      sendToGa(trackerName + 'set', 'title', '')
    }

    function stripLocationPII () {
      sendToGa(trackerName + 'set', 'location', '')
    }

    function load () {
      /* eslint-disable */
      (function (i, s, o, g, r, a, m) { i['GoogleAnalyticsObject'] = r; i[r] = i[r] || function () {
        (i[r].q = i[r].q || []).push(arguments) }, i[r].l = 1 * new Date(); a = s.createElement(o),
        m = s.getElementsByTagName(o)[0]; a.async = 1; a.src = g; m.parentNode.insertBefore(a, m)
      })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga')
      /* eslint-enable */
    }

    // Support legacy cookieDomain param
    if (typeof fieldsObject === 'string') {
      fieldsObject = { cookieDomain: fieldsObject }
    }

    load()
    configureProfile()
    anonymizeIp()
    disableAdFeatures()
    stripTitlePII()
    stripLocationPII()
  }

  CookielessTracker.load = function () {
    /* eslint-disable */
    (function (i, s, o, g, r, a, m) { i['GoogleAnalyticsObject'] = r; i[r] = i[r] || function () {
      (i[r].q = i[r].q || []).push(arguments) }, i[r].l = 1 * new Date(); a = s.createElement(o),
      m = s.getElementsByTagName(o)[0]; a.async = 1; a.src = g; m.parentNode.insertBefore(a, m)
    })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga')
    /* eslint-enable */
  }

  // https://developers.google.com/analytics/devguides/collection/analyticsjs/events
  CookielessTracker.prototype.trackEvent = function (category, action, options) {
    options = options || {}
    var value
    var trackerName = ''
    var evt = {
      hitType: 'event',
      eventCategory: category,
      eventAction: action
    }

    // Label is optional
    if (typeof options.label === 'string') {
      evt.eventLabel = options.label
      delete options.label
    }

    // Value is optional, but when used must be an
    // integer, otherwise the event will be invalid
    // and not logged
    if (options.value || options.value === 0) {
      value = parseInt(options.value, 10)
      if (typeof value === 'number' && !isNaN(value)) {
        options.eventValue = value
      }
      delete options.value
    }

    // trackerName is optional
    if (typeof options.trackerName === 'string') {
      trackerName = options.trackerName + '.'
      delete options.trackerName
    }

    // Prevents an event from affecting bounce rate
    // https://developers.google.com/analytics/devguides/collection/analyticsjs/events#implementation
    if (options.nonInteraction) {
      options.nonInteraction = 1
    }

    if (typeof options === 'object') {
      $.extend(evt, options)
    }

    sendToGa(trackerName + 'send', evt)
  }

  function sendToGa () {
    if (typeof window.ga === 'function') {
      window.ga.apply(window, arguments)
    }
  }

  Modules.CookielessTracker = CookielessTracker
})(window.GOVUK.Modules)
