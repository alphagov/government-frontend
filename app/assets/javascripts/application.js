//= require_tree ./modules
//= require webchat.js

$(document).ready(function () {
  var GOVUK = window.GOVUK;
  if (GOVUK.Webchat) {
    $('.js-webchat').map(function () {
      return new GOVUK.Webchat({ $el: $(this) });
    });
  }
});
