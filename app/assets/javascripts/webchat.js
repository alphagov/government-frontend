//= require ./webchat/library.js

document.addEventListener('DOMContentLoaded', function () {
  var GOVUK = window.GOVUK
  if (GOVUK.Webchat) {
    var webchats = document.querySelectorAll('.js-webchat')
    for (var i = 0; i < webchats.length; i++) {
      /* eslint-disable no-new */
      new GOVUK.Webchat(webchats[i])
    }
  }
})
