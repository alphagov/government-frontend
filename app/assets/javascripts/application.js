//= require govuk_publishing_components/lib
//= require govuk_publishing_components/components/button
//= require govuk_publishing_components/components/details
//= require govuk_publishing_components/components/error-summary
//= require govuk_publishing_components/components/feedback
//= require govuk_publishing_components/components/govspeak
//= require govuk_publishing_components/components/print-link
//= require govuk_publishing_components/components/radio
//= require govuk_publishing_components/components/step-by-step-nav

//= require_tree ./modules
//= require set-ga-client-id-on-form

jQuery(function ($) {
  var $form = $('.js-service-sign-in-form')

  if ($form.length) {
    new GOVUK.SetGaClientIdOnForm({ $form: $form }) // eslint-disable-line no-new
  }
})
