/* eslint-disable */
//= require_tree ./webchat/providers
//= require ./webchat/library.js
/*eslint-enable */

var $ = window.$

$(document).ready(function () {
  var GOVUK = window.GOVUK
  if (GOVUK.Webchat) {
    $('.js-webchat').map(function () {
      return new GOVUK.Webchat({
        $el: $(this),
      })
    })
  }
})
