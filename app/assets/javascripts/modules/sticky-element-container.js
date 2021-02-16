/*
  This module will cause a child in the target element to:
  - hide when the top of the target element is visible;
  - stick to the bottom of the window while the parent element is in view;
  - stick to the bottom of the target when the user scrolls past the bottom.

  Use 'data-module="sticky-element-container"' to instantiate, and add
  `[data-sticky-element]` to the child you want to position.
*/
(function (Modules, root) {
  'use strict'

  var $ = root.$
  var $window = $(root)

  Modules.StickyElementContainer = function () {
    var self = this

    self._getWindowDimensions = function _getWindowDimensions () {
      return {
        height: $window.height(),
        width: $window.width()
      }
    }

    self._getWindowPositions = function _getWindowPositions () {
      return {
        scrollTop: $window.scrollTop()
      }
    }

    self.start = function start ($el) {
      var $element = $el.find('[data-sticky-element]')
      var _hasResized = true
      var _hasScrolled = true
      var _interval = 50
      var _windowVerticalPosition = 1
      var _startPosition, _stopPosition

      initialise()

      function initialise () {
        $window.resize(onResize)
        $window.scroll(onScroll)
        setInterval(checkResize, _interval)
        setInterval(checkScroll, _interval)
        checkResize()
        checkScroll()
        $element.addClass('govuk-sticky-element--enabled')
      }

      function onResize () {
        _hasResized = true
      }

      function onScroll () {
        _hasScrolled = true
      }

      function checkResize () {
        if (_hasResized) {
          _hasResized = false
          _hasScrolled = true

          var windowDimensions = self._getWindowDimensions()
          _startPosition = $el.offset().top
          _stopPosition = $el.offset().top + $el.height() - windowDimensions.height
        }
      }

      function checkScroll () {
        if (_hasScrolled) {
          _hasScrolled = false

          _windowVerticalPosition = self._getWindowPositions().scrollTop

          updateVisibility()
          updatePosition()
        }
      }

      function updateVisibility () {
        var isPastStart = _startPosition < _windowVerticalPosition
        if (isPastStart) {
          show()
        } else {
          hide()
        }
      }

      function updatePosition () {
        var isPastEnd = _stopPosition < _windowVerticalPosition
        if (isPastEnd) {
          stickToParent()
        } else {
          stickToWindow()
        }
      }

      function stickToWindow () {
        $element.addClass('govuk-sticky-element--stuck-to-window')
      }

      function stickToParent () {
        $element.removeClass('govuk-sticky-element--stuck-to-window')
      }

      function show () {
        $element.removeClass('govuk-sticky-element--hidden')
      }

      function hide () {
        $element.addClass('govuk-sticky-element--hidden')
      }
    }
  }
})(window.GOVUK.Modules, window)
