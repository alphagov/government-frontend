window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (global, GOVUK) {
  'use strict'

  var $ = global.jQuery

  GOVUK.Modules.TrackRadioGroup = function () {
    this.start = function (element) {
      track(element)

      checkVerifyUser(element)
    }

    function track (element, withHint) {
      element.on('submit', function (event) {

        var options = { transport: 'beacon' }

        var $submittedForm = $(event.target)

        var $checkedOption = $submittedForm.find('input:checked')

        var checkedValue = $checkedOption.val();

        if (typeof checkedValue === 'undefined') {
          checkedValue = 'submitted-without-choosing'
        }

        GOVUK.analytics.trackEvent('Radio button chosen', checkedValue + (withHint ? '-with-hint' : ''), options)

        if (typeof $submittedForm.attr('data-tracking-code') !== 'undefined') {
          addCrossDomainTracking($submittedForm, $checkedOption, options)
        }
      })
    }

    function checkVerifyUser (element) {
      $.ajax({
        url: 'https://www.signin.service.gov.uk/hint',
        cache: false,
        dataType: 'jsonp',
        timeout: 3000
      }).then(function(data){
          reportVerifyUser(element, data);
      }, function(e){console.log("error", e)})
    }

    this.trackVerifyUser = function (element, data) {
      reportVerifyUser(element, data);
    }

    function reportVerifyUser(element, data) {
      if (data != null && data.value === true) {
        GOVUK.analytics.trackEvent('verify-hint', 'shown', { transport: 'beacon'});
        track(element, data.value);
      }
    }

    function addCrossDomainTracking(element, $checkedOption, options) {
      var code = element.attr('data-tracking-code')
      var name = element.attr('data-tracking-name')
      var url = $checkedOption.attr('data-tracking-url')
      var hostname = $('<a>').prop('href', url).prop('hostname')
      var eventOptions = $.extend({ 'trackerName': name }, options)

      GOVUK.analytics.addLinkedTrackerDomain(code, name, hostname)
      GOVUK.analytics.trackEvent('Radio button chosen', $checkedOption.val(), eventOptions)
    }
  }
})(window, window.GOVUK);
