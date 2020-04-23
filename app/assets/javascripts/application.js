//= require_tree ./modules
//= require govuk_publishing_components/all_components
//= require set-ga-client-id-on-form

jQuery(function ($) {
  var $form = $('.js-service-sign-in-form')

  if ($form.length) {
    new GOVUK.SetGaClientIdOnForm({ $form: $form })
  }

  if ($(location).attr('pathname') === '/ask') {
    var $link = $('[href="https://www.smartsurvey.co.uk/ss/govuk-coronavirus-ask/"]')
    if ($link) {
      var href = $link.attr('href')
      $link.attr('href', GOVUK.userSurveys.addParamsToURL(href))
    }
  }
})
