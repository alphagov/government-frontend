//= require_tree ./modules
//= require govuk_publishing_components/all_components
//= require set-ga-client-id-on-url-in-element

jQuery(function ($) {
  var $form = $('.js-service-sign-in-form')
  if ($form.length) {
    new GOVUK.SetGaClientIdOnUrlInElement({
      $linkedElement: $form,
      attribute: 'action'
    })
  }

  if ($(location).attr('pathname') === '/ask') {
    var $link = $('[href="https://www.smartsurvey.co.uk/ss/govuk-coronavirus-ask/"]')
    new GOVUK.SetGaClientIdOnUrlInElement({
      $linkedElement: $link,
      attribute: 'href'
    })
  }
})
