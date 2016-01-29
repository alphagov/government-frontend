// ######################################################
// This is an example module provided by Wraith.
// Feel free to amend for your own requirements.
// ######################################################
module.exports = function (phantom, ready) {
  phantom.addCookie({
    'name': 'govuk_takenUserSatisfactionSurvey',
    'value': 'yes',
    'domain': 'localhost'
  });

  phantom.addCookie({
    'name': 'seen_cookie_message',
    'value': 'yes',
    'domain': 'localhost'
  });

  phantom.open(phantom.url, function () {
    setTimeout(ready, 1000);
  });
}
