describe('An accordion with descriptions module', function () {
  "use strict";

  var $element;

  beforeEach(function() {
    $element = $('<div class="subsections js-hidden" data-module="accordion-with-descriptions">\
        <div class="subsection-wrapper">\
          <div class="subsection">\
            <div class="subsection-header">\
              <h2 class="subsection-title">Subsection title in here</h2>\
              <p class="subsection-description">Subsection description in here</p>\
            </div>\
            <div class="subsection-content" id="subsection_content_0">\
              <ul class="subsection-list">\
                <li>\
                  <a href="">Subsection list item in here</a>\
                </li>\
              </ul>\
            </div>\
          </div>\
          <div class="subsection">\
            <div class="subsection-header">\
              <h2 class="subsection-title">Subsection title in here</h2>\
              <p class="subsection-description">Subsection description in here</p>\
            </div>\
            <div class="subsection-content" id="subsection_content_1">\
              <ul class="subsection-list">\
                <li>\
                  <a href="">Subsection list item in here</a>\
                </li>\
              </ul>\
            </div>\
          </div>\
        </div>\
      </div>');

    var accordion = new GOVUK.Modules.AccordionWithDescriptions();
    accordion.start($element);
  });

  afterEach(function() {
    $(document).off();
  });

  it("has a class of js-accordion-with-descriptions", function () {
    expect($element).toHaveClass("js-accordion-with-descriptions");
  });

  it("does not have a class of js-hidden", function () {
    expect($element).not.toHaveClass("js-hidden");
  });

  it("has a child element with a class of subsection-controls", function () {
    expect($element).toContain('.js-subsection-controls');
  });

  it("has a child element which is a button", function () {
    expect($element).toContain('.js-subsection-controls button');
  });

  it("has an open/close all button with an aria-expanded attribute and it is false", function () {
    var $button = $element.find('.js-subsection-controls button');

    expect($button).toHaveAttr("aria-expanded", "false");
  });

  it("has an open/close all button with text inside which is equal to Open all and a value for the aria-controls attribute which includes all of the subsection_content_IDs", function () {
    var $openCloseAllButton = $element.find('.js-subsection-controls button');

    expect($openCloseAllButton).toHaveText("Open all");
    expect($openCloseAllButton).toHaveAttr('aria-controls','subsection_content_0 subsection_content_1 ');
  });

  it("has a h2 with a class of .subsection-title with a child element which is a button", function () {
    var $subsectionButton = $element.find('.subsection-title button:first');

    expect($subsectionButton).toHaveClass('subsection-button');
    expect($subsectionButton).toHaveAttr('aria-expanded','false');
    expect($subsectionButton).toHaveAttr('aria-controls','subsection_content_0');
  });

  it("has two subsection-content items which are initially hidden", function () {
    var $subsectionContent = $element.find('.subsection-content');

    expect($subsectionContent).toHaveLength(2);
    expect($subsectionContent).toHaveClass('js-hidden');
  });

  it("has a header with a child element which has a class of .subsection-icon", function () {
    var $subsectionHeader = $element.find('.subsection-header');

    expect($subsectionHeader).toContain('.subsection-icon');
  });

  it("has no is-open classes and two sections when all sections are closed", function () {
    var openSubsections = $element.find('.is-open').length;
    expect(openSubsections).toEqual(0);
    var totalSubsections = $element.find('.subsection-content').length;
    expect(totalSubsections).toEqual(2);
  });

  // When the open/close all button is clicked...

  it("has no is-open classes, then when the open-close button is clicked, it has two is-open classes, this is equal to the number of sections", function () {

    var $openCloseAllButton = $element.find('.js-subsection-controls button');
    var openSubsections = $element.find('.is-open').length;

    expect(openSubsections).toEqual(0);

    $openCloseAllButton.click();

    var openSubsections = $element.find('.is-open').length;
    expect(openSubsections).toEqual(2);

    var totalSubsections = $element.find('.subsection-content').length;
    expect(totalSubsections).toEqual(openSubsections);
  });


  // Test that the button text is updated to Close all
  it("has text inside which is equal to Close all", function () {
    var $openCloseAllButton = $element.find('.js-subsection-controls button');

    expect($openCloseAllButton).toContainText("Open all");
    $openCloseAllButton.click();
    expect($openCloseAllButton).toContainText("Close all");
  });

  // When a section is open

  // When a section is open (testing: toggleSection, openSection)
  it("does not have a class of js-hidden", function () {
  });

  // When a section is open (testing: toggleState, setExpandedState)
  it("has a an aria-expanded attribute and the value is true", function () {
  });

  // When a section is closed

  // When a section is closed (testing: toggleSection, closeSection)
  it("has a class of js-hidden", function () {
  });


  // When a section is closed (testing: toggleState, setExpandedState)
  it("has a an aria-expanded attribute and the value is false", function () {
  });

  // When the open/close all button is clicked ??
  // Test all of the above ??

});
