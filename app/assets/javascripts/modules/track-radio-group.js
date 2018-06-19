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
      })
    }

    function checkVerifyUser (element) {
      $.ajax({
        url: 'https://www.signin.service.gov.uk/hint', 
        cache: false,
        dataType: 'jsonp',
        timeout: 3000
      }).then(function(data){
          GOVUK.Modules.TrackRadioGroup.trackVerifyUser(element, data);
      }, function(e){console.log("error", e)})
    }

    this.trackVerifyUser = function (element, data) {
        if (data != null && data.value === true) {
            GOVUK.analytics.trackEvent('verify-hint', 'shown', { transport: 'beacon'});
            track(element, data.value);
      }
    }
  }
})(window, window.GOVUK);
