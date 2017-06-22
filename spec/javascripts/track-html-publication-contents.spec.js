describe('An HTML Publication contents click tracker', function() {
  "use strict";

  var tracker,
      element;

  beforeEach(function() {
    tracker = new GOVUK.Modules.TrackHtmlPublicationContents();
    spyOn(GOVUK.analytics, 'trackEvent');
    element = $('\
      <div \
        data-track-category="category"\
        data-track-action="action">\
        <a href="#the-link-id">Foo!</a>\
        <ul><li><a href="#another-link"><span>1. </span> Bar</a></li></ul>\
      </div>\
    ');
  });

  it('tracks click events using category and action on parent and link href location as label', function() {
    tracker.start(element);
    element.find('a').trigger('click');
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('category', 'action', {label: 'the-link-id', transport: 'beacon'});
  });

  it('tracks click events on any link', function() {
    tracker.start(element);
    element.find('a').eq(1).trigger('click');
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('category', 'action', {label: 'another-link', transport: 'beacon'});
  });

  it('handles click events on spans inside links', function() {
    tracker.start(element);
    element.find('a span').trigger('click');
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('category', 'action', {label: 'another-link', transport: 'beacon'});
  });
});
