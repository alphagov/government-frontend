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

  Modules.StickyElementContainer = function () {
    var self = this

    self.getWindowDimensions = function () {
      return {
        height: root.innerHeight,
        width: root.innerWidth
      }
    }

    self.getWindowPositions = function () {
      return {
        scrollTop: root.scrollY
      }
    }

    self.start = function ($el) {
      var el = $el[0]
      var element = el.querySelector('[data-sticky-element]')

      var hasResized = true
      var hasScrolled = true
      var interval = 50
      var windowVerticalPosition = 1
      var startPosition, stopPosition

      initialise()

      function initialise () {
        root.onresize = onResize
        root.onscroll = onScroll
        setInterval(checkResize, interval)
        setInterval(checkScroll, interval)
        checkResize()
        checkScroll()
        element.classList.add('sticky-element--enabled')
      }

      function onResize () {
        hasResized = true
      }

      function onScroll () {
        hasScrolled = true
      }

      function checkResize () {
        if (hasResized) {
          hasResized = false
          hasScrolled = true

          var windowDimensions = self.getWindowDimensions()
          startPosition = el.offsetTop
          stopPosition = el.offsetTop + el.offsetHeight - windowDimensions.height
        }
      }

      function checkScroll () {
        if (hasScrolled) {
          hasScrolled = false

          windowVerticalPosition = self.getWindowPositions().scrollTop

          updateVisibility()
          updatePosition()
        }
      }

      function updateVisibility () {
        var isPastStart = startPosition < windowVerticalPosition
        if (isPastStart) {
          show()
        } else {
          hide()
        }
      }

      function updatePosition () {
        var isPastEnd = stopPosition < windowVerticalPosition
        if (isPastEnd) {
          stickToParent()
        } else {
          stickToWindow()
        }
      }

      function stickToWindow () {
        element.classList.add('sticky-element--stuck-to-window')
      }

      function stickToParent () {
        element.classList.remove('sticky-element--stuck-to-window')
      }

      function show () {
        element.classList.remove('sticky-element--hidden')
      }

      function hide () {
        element.classList.add('sticky-element--hidden')
      }
    }
  }
})(window.GOVUK.Modules, window)
