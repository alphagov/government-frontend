window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function TrackRadioGroup (element) {
    this.element = element
  }

  TrackRadioGroup.prototype.init = function () {
    this.track(this.element)

    if (this.crossDomainTrackingEnabled(this.element)) {
      this.addCrossDomainTracking(this.element)
    }
  }

  TrackRadioGroup.prototype.track = function (element) {
    this.element.addEventListener('submit', function (event) {
      var options = { transport: 'beacon' }
      var submittedForm = event.target
      var checkedOption = submittedForm.querySelector('input:checked')
      var eventValue = this.eventTrackingValue(checkedOption)

      GOVUK.analytics.trackEvent('Radio button chosen', eventValue, options)

      if (this.crossDomainTrackingEnabled(submittedForm)) {
        this.trackCrossDomainEvent(submittedForm, eventValue, options)
      }
    }.bind(this))
  }

  TrackRadioGroup.prototype.eventTrackingValue = function (element) {
    var value = null

    if (typeof element === 'undefined' || element === null) {
      value = 'submitted-without-choosing'
    } else {
      value = element.value
    }
    return value
  }

  TrackRadioGroup.prototype.addCrossDomainTracking = function (element) {
    var code = element.getAttribute('data-tracking-code')
    var domain = element.getAttribute('data-tracking-domain')
    var name = element.getAttribute('data-tracking-name')

    GOVUK.analytics.addLinkedTrackerDomain(code, name, domain)
  }

  TrackRadioGroup.prototype.trackCrossDomainEvent = function (element, eventValue, options) {
    var name = element.getAttribute('data-tracking-name')
    if (name) {
      options.trackerName = name
    }

    GOVUK.analytics.trackEvent('Radio button chosen', eventValue, options)
  }

  TrackRadioGroup.prototype.crossDomainTrackingEnabled = function (element) {
    return (
      element.getAttribute('data-tracking-code') &&
      element.getAttribute('data-tracking-domain') &&
      element.getAttribute('data-tracking-name')
    )
  }

  Modules.TrackRadioGroup = TrackRadioGroup
})(window.GOVUK.Modules)
