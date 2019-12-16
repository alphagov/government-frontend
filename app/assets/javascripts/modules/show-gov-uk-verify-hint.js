window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (global, GOVUK) {
  'use strict'

  var $ = global.jQuery
  var VISIBLE_ON_URL = "/personal-tax-account/sign-in/prove-identity"

  GOVUK.Modules.ShowGovUkVerifyHint = function () {
    this.start = function (element) {
      if (window.location.href.indexOf(VISIBLE_ON_URL) > -1) {
        checkLastSuccessfulIdp(element)
      }
    }
    
    this.render = function (element, data) {
      renderHint(element, data)
    }

    function checkLastSuccessfulIdp (element) {
      $.ajax({
        url: 'https://www.signin.service.gov.uk/successful-idp',
        cache: false,
        dataType: 'jsonp',
        timeout: 3000
      }).then(function(data){
          renderHint(element, data);
      }, function(e){console.log("error", e)})
    }

    function renderHint (element, data) {
      if (data != null && data['found'] == 'true') {
        $(element).html(generateHtml(data)).show()
        $('button:contains("Continue")').addClass('govuk-button--secondary')
      }
    }

    function generateHtml(data) {
      return  '<div class="verify-hint-box">' +
                '<h2 class="govuk-heading-m">' +
                  'Someone recently signed in with '+ data['displayName'] +' on this device' +
                '</h2>' +
                '<div class="verify-hint-logos">' +
                  '<img ' +
                    'class="verify-hint-logos-idp"' +
                    'src="https://gds-verify-frontend-assets.s3.amazonaws.com/4af94ca-c1e26b4/'+ data['simpleId'] +'.png"' +
                    'alt="' + data['displayName'] + '"'+
                  '>' +
                  '<img '+
                    'class="verify-hint-logos-verify"' +
                    'src="https://gds-verify-frontend-assets.s3.amazonaws.com/4af94ca-c1e26b4/govuk-verify-small-black-text-454fe97ff5e3edfb6eebdc648930c0ff675616ae7956f1d87e67b30f479d7b8d.svg"' +
                    'alt="GOV.UK Verify logo"' +
                  '>' +
                '</div>' +
                '<a '+
                  'class="gem-c-button govuk-button"' +
                  'role="button"' +
                  'href="https://www.signin.service.gov.uk/initiate-journey/hmrc-personal-tax-account?journey_hint=idp_' + data['simpleId'] + '"' +
                  'onClick="GOVUK.analytics.trackEvent(\'verify-hint\', \'proceed\', { transport: \'beacon\'})"' +
                '>' +
                  'Continue with '+ data['displayName'] +'</a>' +
              '</div>' +
              '<p class="govuk-body">If this wasn\'t you, choose one option:</p>'
    }
  }
})(window, window.GOVUK);
