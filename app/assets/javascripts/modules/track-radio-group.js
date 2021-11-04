window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function TrackRadioGroup (element) {
    this.element = element.querySelector('form') || element
  }

  TrackRadioGroup.prototype.init = function () {
    this.track(this.element)

    if (this.crossDomainTrackingEnabled(this.element)) {
      this.addCrossDomainTracking(this.element)
    }

    this.checkVerifyUser(this.element)
  }

  TrackRadioGroup.prototype.track = function (element, withHint) {
    this.element.addEventListener('submit', function (event) {
      var options = { transport: 'beacon' }
      var submittedForm = event.target
      var checkedOption = submittedForm.querySelector('input:checked')
      var eventValue = this.eventTrackingValue(checkedOption, withHint)

      GOVUK.analytics.trackEvent('Radio button chosen', eventValue, options)

      if (this.crossDomainTrackingEnabled(submittedForm)) {
        this.trackCrossDomainEvent(submittedForm, eventValue, options)
      }
    }.bind(this))
  }

  TrackRadioGroup.prototype.checkVerifyUser = function (element) {
    var that = this

    $.ajax({
      url: 'https://www.signin.service.gov.uk/hint',
      cache: false,
      dataType: 'jsonp',
      timeout: 3000
    }).then(function (data) {
      that.reportVerifyUser(element, data)
    }, function (e) { console.log('error', e) })
  }

  TrackRadioGroup.prototype.trackVerifyUser = function (element, data) {
    this.reportVerifyUser(element, data)
  }

  TrackRadioGroup.prototype.reportVerifyUser = function (element, data) {
    if (data != null && data.value === true) {
      GOVUK.analytics.trackEvent('verify-hint', 'shown', { transport: 'beacon' })
      this.track(element, data.value)
    }
  }

  TrackRadioGroup.prototype.eventTrackingValue = function (element, withHint) {
    var value = null

    if (typeof element === 'undefined' || element === null) {
      value = 'submitted-without-choosing'
    } else {
      value = element.value
    }

    if (withHint) {
      value += '-with-hint'
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
    var eventOptions = { trackerName: name }

    for (var prop in options) {
      eventOptions[prop] = options[prop]
    }

    GOVUK.analytics.trackEvent('Radio button chosen', eventValue, eventOptions)
  }

  TrackRadioGroup.prototype.crossDomainTrackingEnabled = function (element) {
    return (
      typeof element.getAttribute('data-tracking-code') !== 'undefined' &&
      typeof element.getAttribute('data-tracking-domain') !== 'undefined' &&
      typeof element.getAttribute('data-tracking-name') !== 'undefined'
    )
  }

  Modules.TrackRadioGroup = TrackRadioGroup
})(window.GOVUK.Modules)
