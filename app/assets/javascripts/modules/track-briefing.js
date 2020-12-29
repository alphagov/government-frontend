window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function TrackBriefing () {}

  TrackBriefing.prototype.start = function($element) {
    var scope = $element[0]

    this.trackLinks(scope)
  }

  TrackBriefing.prototype.trackLinks = function(scope) {
    var links = scope.getElementsByTagName('a')

    for (var i = 0; i < links.length; i++) {
      var link = links[i]
      link.addEventListener('click', this.sendLinkClickEvent)
    }
  }

  TrackBriefing.prototype.sendLinkClickEvent = function(event) {
    GOVUK.analytics.trackEvent(
      'Briefings page',
      event.target.innerText,
      {
        transport: 'beacon',
        label: event.target.getAttribute('href')
      }
    )
  }

  Modules.TrackBriefing = TrackBriefing
})(window.GOVUK.Modules)
