describe('Accordion with descriptions', function () {
  "use strict";

  // Test that the .js-accordion-with-descriptions class has been added
  it("has a class of js-accordion-with-descriptions", function () {
  });

  // Test that the .js-hidden class has been removed
  it("does not have a class of js-hidden", function () {
  });

  // Test that the markup has been inserted for subsection controls
  it("has created a wrapper with a class of subsection-controls", function () {
  });

  // Test that inside subsection controls is a button (the open/close all button)
  it("has a child element which is a button", function () {
  });

  // Test that the open/close all button has the aria-expanded attribute and it is set to false
  it("has an aria-expanded attribute and it is false", function () {
  });

  // Test that the open/close all button text is "Open all"
  it("has text inside which is equal to Open all", function () {
  });

  // Test that each section has a title with a class of .subsection-title
  it("has a title with a class of .subsection-title", function () {
  });

  // Test that inside .subsection-title is a button
  it("has a child element which is a button", function () {
  });

  // Test that the button inside each title has an aria-expanded attribute and it is set to false
  it("has an aria-expanded attribute and it is false", function () {
  });

  // Test that each button has an aria-controls attribute which matches the ID of a subsection_content_ID
  it("has aria-controls attribute which matches the ID of a subsection_content_ID", function () {
  });

  // Test that the total number of .subsection-content items is known
  it("has a number of subsection-content items and the total is stored", function () {
  });

  // Test that the open/close all button has a value for the aria-controls attribute which matches *all* subsection_content_IDs
  it("has a value for the aria-controls attribute which includes all of the subsection_content_IDs", function () {
  });

  // Test that all of the .subsection-content items are initially hidden
  it("has a class of js-hidden for all .subsection-content items", function () {
  });

  // Test that the subsection icon has been inserted into each subsection header
  it("has a child element which has a class of .subsection-icon", function () {
  });

  // When all sections are open (testing: setOpenCloseAllText)

  // Test that the total number of sections is equal to the total number of .is-open classes
  it("has a total number of is-open classes and that this is the same as the number of sections", function () {
  });

  // Test that the button text is updated to Close all
  it("has text inside which is equal to Close all", function () {
  });

  // When a section is open

  // When a section is open (testing: toggleSection, openSection)
  it("does not have a class of js-hidden", function () {
  });

  // When a section is open (testing: toggleIcon)
  it("has a class of is-open", function () {
  });

  // When a section is open (testing: toggleState, setExpandedState)
  it("has a an aria-expanded attribute and the value is true", function () {
  });

  // When a section is closed

  // When a section is closed (testing: toggleSection, closeSection)
  it("has a class of js-hidden", function () {
  });

  // When a section is closed (testing: toggleIcon)
  it("does not have a class of is-open", function () {
  });

  // When a section is closed (testing: toggleState, setExpandedState)
  it("has a an aria-expanded attribute and the value is false", function () {
  });

  // When the open/close all button is clicked ??
  // Test all of the above ??

});
