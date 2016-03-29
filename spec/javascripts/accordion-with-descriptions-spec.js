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

  // Setup
  // Add & remove classes to show the JS has worked
  // Add an 'Open all' button
  // Set the correct text and aria attributes (aria-expanded, aria-controls) for the button

  // Add a class .js-accordion-with-descriptions
  it("has a class of js-accordion-with-descriptions", function () {
    expect($element).toHaveClass("js-accordion-with-descriptions");
  });

  // Remove the class .js-hidden
  it("does not have a class of js-hidden", function () {
    expect($element).not.toHaveClass("js-hidden");
  });

  // Add a subsection controls div, with a class of .js-subsection controls
  it("has a child element with a class of subsection-controls", function () {
    expect($element).toContain('.js-subsection-controls');
  });

  // Insert a button inside .js-subsection-controls
  it("has a child element which is a button", function () {
    expect($element).toContain('.js-subsection-controls button');
  });

  // Set the aria-expanded attribute to false, as all subsections are initially closed
  it("has an open/close all button with an aria-expanded attribute and it is false", function () {
    var $button = $element.find('.js-subsection-controls button');

    expect($button).toHaveAttr("aria-expanded", "false");
  });

  // Set the text inside the button to "Open all"
  it("has an open/close all button with text inside which is equal to Open all", function () {
    var $openCloseAllButton = $element.find('.js-subsection-controls button');

    expect($openCloseAllButton).toHaveText("Open all");
  });

  // Ensure that the value for the aria-controls attribute matches the IDs of all of the subsections
  it("has a value for the aria-controls attribute which includes all of the subsection_content_IDs", function () {
    var $openCloseAllButton = $element.find('.js-subsection-controls button');

    expect($openCloseAllButton).toHaveAttr('aria-controls','subsection_content_0 subsection_content_1 ');
  });

  // Insert a button into each subsection title
  // Set the correct text and aria attributes (aria-expanded, aria-controls) for the button
  it("has a h2 with a class of .subsection-title with a child element which is a button", function () {
    var $subsectionButton = $element.find('.subsection-title button:first');

    expect($subsectionButton).toHaveClass('subsection-button');
    expect($subsectionButton).toHaveAttr('aria-expanded','false');
    expect($subsectionButton).toHaveAttr('aria-controls','subsection_content_0');
  });

  // Ensure the wrapper for the list of links is initially hidden
  it("has two subsection-content items which are initially hidden", function () {
    var $subsectionContent = $element.find('.subsection-content');

    expect($subsectionContent).toHaveLength(2);
    expect($subsectionContent).toHaveClass('js-hidden');
  });

  // Ensure that the subsection-icon div has been inserted
  it("has a header with a child element which has a class of .subsection-icon", function () {
    var $subsectionHeader = $element.find('.subsection-header');

    expect($subsectionHeader).toContain('.subsection-icon');
  });

  // When all sections are closed, make sure there are no .is-open classes
  // Check that the total number of sections correct (there are two sections in the fixture)

  // When the open/close all button is clicked...
  // Check that the total number of is-open classes matches the number of sections (so all are opened)

  it("has no is-open classes, then when the open-close button is clicked, it has two is-open classes, this is equal to the number of sections and that the button text is updated to Close all", function () {

    var $openCloseAllButton = $element.find('.js-subsection-controls button');
    var openSubsections = $element.find('.is-open').length;

    expect(openSubsections).toEqual(0);
    expect($openCloseAllButton).toContainText("Open all");

    $openCloseAllButton.click();

    var openSubsections = $element.find('.is-open').length;
    expect(openSubsections).toEqual(2);
    expect($openCloseAllButton).toContainText("Close all");

    var totalSubsections = $element.find('.subsection-content').length;
    expect(totalSubsections).toEqual(openSubsections);
  });

  // When a section is open

  // When a section is open (testing: toggleSection, openSection)
  it("does not have a class of js-hidden", function () {
    var $subsectionButton = $element.find('.subsection-title button:first');
    var $subsectionContent = $element.find('.subsection-content:first');
    $subsectionButton.click();
    expect($subsectionContent).not.toHaveClass("js-hidden");
  });

  // When a section is open (testing: toggleState, setExpandedState)
  it("has a an aria-expanded attribute and the value is true", function () {
    var $subsectionButton = $element.find('.subsection-title button:first');
    $subsectionButton.click();
    expect($subsectionButton).toHaveAttr('aria-expanded','true');
  });

  // When a section is opened and then closed

  // When a section is closed (testing: toggleSection, closeSection)
  it("has a class of js-hidden", function () {
    var $subsectionButton = $element.find('.subsection-title button:first');
    var $subsectionContent = $element.find('.subsection-content:first');
    $subsectionButton.click();
    expect($subsectionContent).not.toHaveClass("js-hidden");
    $subsectionButton.click();
    expect($subsectionContent).toHaveClass("js-hidden");
  });


  // When a section is closed (testing: toggleState, setExpandedState)
  it("has a an aria-expanded attribute and the value is false", function () {
    var $subsectionButton = $element.find('.subsection-title button:first');
    var $subsectionContent = $element.find('.subsection-content');
    $subsectionButton.click();
    expect($subsectionButton).toHaveAttr('aria-expanded','true');
    $subsectionButton.click();
    expect($subsectionButton).toHaveAttr('aria-expanded','false');
  });

});
