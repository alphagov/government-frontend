describe('A sticky-element-container module', function () {
  'use strict'

  var GOVUK = window.GOVUK
  var $ = window.$
  var instance

  beforeEach(function () {
    instance = new GOVUK.Modules.StickyElementContainer()
  })

  describe('in a large parent element', function () {
    var $element = $(
      '<div data-module="sticky-element-container" style="height: 9001px; margin-bottom: 1000px">' +
        '<div data-sticky-element>' +
          '<span>Content</span>' +
        '</div>' +
      '</div>'
    )
    var $footer = $element.find('[data-sticky-element]')

    describe('on desktop', function () {
      beforeEach(function () {
        instance._getWindowDimensions = function () {
          return {
            height: 768,
            width: 1024
          }
        }
      })

      it('hides the element, when scrolled at the top', function () {
        instance.start($element)

        expect($footer.hasClass('govuk-sticky-element--hidden')).toBe(true)
      })

      it('shows the element, stuck to the window, when scrolled in the middle', function () {
        instance._getWindowPositions = function () {
          return {
            scrollTop: 5000
          }
        }
        instance.start($element)

        expect($footer.hasClass('govuk-sticky-element--hidden')).toBe(false)
        expect($footer.hasClass('govuk-sticky-element--stuck-to-window')).toBe(true)
      })

      it('shows the element, stuck to the parent, when scrolled at the bottom', function () {
        instance._getWindowPositions = function () {
          return {
            scrollTop: 9800
          }
        }
        instance.start($element)

        expect($footer.hasClass('govuk-sticky-element--hidden')).toBe(false)
        expect($footer.hasClass('govuk-sticky-element--stuck-to-window')).toBe(false)
      })
    })
  })
})
