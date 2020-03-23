//= require_tree ./modules
//= require govuk_publishing_components/all_components
//= require set-ga-client-id-on-form
//= require coronavirus-extremely-vulnerable

jQuery(function ($) {
  var $form = $('.js-service-sign-in-form')

  if ($form.length) {
    new GOVUK.SetGaClientIdOnForm({ $form: $form })
  }
})
