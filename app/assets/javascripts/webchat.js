/* eslint-disable */
//= require ./webchat/library.js
/*eslint-enable */

var $ = window.$

EGAIN_NORMALISATION = {
  0: 'AVAILABLE',
  1: 'UNAVAILABLE',
  2: 'BUSY'
}

var webChatNormalise = function (res) {
  var $xml = $(res)
  var proxyResponse = parseInt($xml.find('checkEligibility').attr('responseType'), 10)
  var response = EGAIN_NORMALISATION[proxyResponse]
  if (!response) {
    return {
      status: 'failure',
      response: 'unknown'
    }
  }

  return {
    status: 'success',
    response: response
  }
}

$(document).ready(function () {
  var GOVUK = window.GOVUK
  if (GOVUK.Webchat) {
    $('.js-webchat').map(function () {
      return new GOVUK.Webchat({
        $el: $(this),
        responseNormaliser: webChatNormalise
      })
    })
  }
})
