(function (global) {
  'use strict';
  var $ = global.jQuery;
  var windowLocationPathname = global.location.pathname;
  var windowOpen = global.open;
  if (typeof global.GOVUK === 'undefined') { global.GOVUK = {}; }
  var GOVUK = global.GOVUK;

  // Each page will have a different entryPointID, which is a queue id.
  // Don't enable this plugin on pages that don't exist in this map, and
  // uncomment the additional routes as we obtain them.
  // Whether the actual template is displayed is in `contact_presenter#show_webchat?`.
  var entryPointIDs = {};
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/child-benefit'] = 1027;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/income-tax-enquiries-for-individuals-pensioners-and-employees'] = 1030;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/vat-online-services-helpdesk'] = 1026;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/national-insurance-numbers'] = 1021;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/self-assessment-online-services-helpdesk'] = 1003;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/self-assessment'] = 1004;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/tax-credits-enquiries'] = 1016;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/vat-enquiries'] = 1028;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/customs-international-trade-and-excise-enquiries'] = 1034;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/trusts'] = 1036;
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/employer-enquiries'] = 1023
  entryPointIDs['/government/organisations/hm-revenue-customs/contact/construction-industry-scheme'] = 1048

  var API_URL = 'https://online.hmrc.gov.uk/webchatprod/egain/chat/entrypoint/checkEligibility/';
  var OPEN_CHAT_URL = function (entryPointID) {
    return 'https://online.hmrc.gov.uk/webchatprod/templates/chat/hmrc7/chat.html?entryPointId=' + entryPointID + '&templateName=hmrc7&languageCode=en&countryCode=US&ver=v11';
  };
  var CODE_AGENTS_AVAILABLE = 0;
  var CODE_AGENTS_UNAVAILABLE = 1;
  var CODE_AGENTS_BUSY = 2;
  var POLL_INTERVAL = 15 * 1000;
  var AJAX_TIMEOUT = 5 * 1000;

  function Webchat (options) {
    var $el = $(options.$el);
    var location = options.location || windowLocationPathname;

    var $advisersUnavailable = $el.find('.js-webchat-advisers-unavailable');
    var $advisersBusy = $el.find('.js-webchat-advisers-busy');
    var $advisersAvailable = $el.find('.js-webchat-advisers-available');
    var $advisersError = $el.find('.js-webchat-advisers-error');
    var $openButton = $el.find('.js-webchat-open-button');

    var entryPointID = entryPointIDs[location];
    var pollingEnabled = true;

    if (entryPointID) {
      pollAvailability();

      $openButton.on('click', handleOpenChat);
    }

    function pollAvailability () {
      checkAvailability();

      setTimeout(function () {
        if (pollingEnabled) {
          pollAvailability();
        }
      }, POLL_INTERVAL);
    }

    function checkAvailability () {
      $.ajax({
        url: API_URL + entryPointID,
        type: 'GET',
        timeout: AJAX_TIMEOUT,
        success: handleApiCallSuccess,
        error: handleApiCallError
      });
    }

    function handleApiCallSuccess (result) {
      var $xml = $(result);
      var response = parseInt($xml.find('checkEligibility').attr('responseType'), 10);

      switch (response) {
        case CODE_AGENTS_UNAVAILABLE: handleAdvisersUnavailable(); break;
        case CODE_AGENTS_BUSY:        handleAdvisersBusy(); break;
        case CODE_AGENTS_AVAILABLE:   handleAdvisersAvailable(); break;
        default:                      handleApiCallError(); break;
      }
    }

    function handleApiCallError () {
      pollingEnabled = false;
      handleAdvisersError();
    }

    function handleOpenChat (evt) {
      evt.preventDefault();
      var url = OPEN_CHAT_URL(entryPointID);
      windowOpen(url, 'newwin', 'width=200,height=100');

      GOVUK.analytics.trackEvent('webchat', 'accepted');
    }

    function handleAdvisersError () {
      $advisersError.removeClass('hidden');

      $advisersAvailable.addClass('hidden');
      $advisersBusy.addClass('hidden');
      $advisersUnavailable.addClass('hidden');

      GOVUK.analytics.trackEvent('webchat', 'error');
    }

    function handleAdvisersUnavailable () {
      $advisersUnavailable.removeClass('hidden');

      $advisersAvailable.addClass('hidden');
      $advisersBusy.addClass('hidden');
      $advisersError.addClass('hidden');

      GOVUK.analytics.trackEvent('webchat', 'unavailable');
    }

    function handleAdvisersBusy () {
      $advisersBusy.removeClass('hidden');

      $advisersUnavailable.addClass('hidden');
      $advisersAvailable.addClass('hidden');
      $advisersError.addClass('hidden');

      GOVUK.analytics.trackEvent('webchat', 'busy');
    }

    function handleAdvisersAvailable () {
      $advisersAvailable.removeClass('hidden');

      $advisersBusy.addClass('hidden');
      $advisersError.addClass('hidden');
      $advisersUnavailable.addClass('hidden');

      GOVUK.analytics.trackEvent('webchat', 'offered');
    }
  }

  GOVUK.Webchat = Webchat;
})(window);
