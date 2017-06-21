window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function(Modules) {
  "use strict";

  Modules.TrackHtmlPublicationContents = function () {
    this.start = function (element) {
      var category = element.data('track-category');
      var action = element.data('track-action');
      var trackable = 'a[href^="#"]';

      element.on('click', trackable, trackClick);

      function trackClick(evt) {
        var $el = $(evt.target),
            options = {
              transport: 'beacon'
            };

        if (! $el.is(trackable)) {
          $el = $el.parents(trackable);
        }

        options.label = $el.attr('href').substring(1);

        if (GOVUK.analytics && GOVUK.analytics.trackEvent) {
          GOVUK.analytics.trackEvent(category, action, options);
        }
      }
    };
  };
})(window.GOVUK.Modules);
