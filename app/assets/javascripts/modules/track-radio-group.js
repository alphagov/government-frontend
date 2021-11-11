window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {}

// This callback is triggered by the script attached to the DOM by the
// checkVerifyUser function. It has to be outside the module because the script
// can't access the running instance of TrackRadioGroup
window.GOVUK.TrackRadioGroupVerify = function (data) {
  window.GOVUK.triggerEvent(document, 'have-verify-data', { detail: data })
};

(function (Modules) {
  function TrackRadioGroup (element) {
    this.element = element
  }

  TrackRadioGroup.prototype.init = function () {
    document.addEventListener('have-verify-data', function (event) {
      this.reportVerifyUser(this.element, event.detail)
    }.bind(this))

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

  // The analytics data should include whether the user has previously signed in
  // to Verify this simulates the behaviour of JSONP, returning a true or false
  // value from Verify
  TrackRadioGroup.prototype.checkVerifyUser = function (element) {
    var url = 'https://www.signin.service.gov.uk/hint'
    var timestamp = Math.floor(Date.now() / 1000)
    var script = document.createElement('script')
    script.setAttribute('src', url + '?callback=window.GOVUK.TrackRadioGroupVerify&_=' + timestamp)
    document.body.appendChild(script)
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
