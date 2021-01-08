window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function TrackLinks () { }

  TrackLinks.prototype.start = function ($element) {
    $element = $element[0]
    var category = $element.getAttribute('data-track-links-category')
    var links = $element.querySelectorAll('a')

    for (var i = 0; i < links.length; i++) {
      links[i].addEventListener('click', function (event) {
        this.sendLinkClickEvent(event, category)
      }.bind(this))
    }
  }

  TrackLinks.prototype.sendLinkClickEvent = function (event, category) {
    window.GOVUK.analytics.trackEvent(
      category,
      event.target.innerText,
      {
        transport: 'beacon',
        label: event.target.getAttribute('href')
      }
    )
  }

  Modules.TrackLinks = TrackLinks
})(window.GOVUK.Modules)
