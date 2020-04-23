//= require_tree ./modules
//= require govuk_publishing_components/all_components
//= require set-ga-client-id-on-form
//= require set-ga-client-id-on-link

jQuery(function ($) {
  var $form = $('.js-service-sign-in-form')
  if ($form.length) {
    new GOVUK.SetGaClientIdOnForm({ $form: $form })
  }

  if ($(location).attr('pathname') === '/ask') {
    var $link = $('[href="https://www.smartsurvey.co.uk/ss/govuk-coronavirus-ask/"]')
    new GOVUK.SetGaClientIdOnLink({ $link: $link })
  }
})
