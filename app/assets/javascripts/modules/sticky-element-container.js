/*
  This module will cause a child in the target element to:
  - hide when the top of the target element is visible;
  - stick to the bottom of the window while the parent element is in view;
  - stick to the bottom of the target when the user scrolls past the bottom.

  Use 'data-module="sticky-element-container"' to instantiate, and add
  `[data-sticky-element]` to the child you want to position.
*/
(function (Modules) {
  'use strict'

  Modules.StickyElementContainer = function () {
    var self = this

    self.getWindowDimensions = function () {
      return {
        height: window.innerHeight,
        width: window.innerWidth
      }
    }

    self.getWindowPositions = function () {
      return {
        scrollTop: window.scrollY
      }
    }

    self.start = function ($el) {
      var wrapper = $el[0]
      var stickyElement = wrapper.querySelector('[data-sticky-element]')

      var hasResized = true
      var hasScrolled = true
      var interval = 50
      var windowVerticalPosition = 1
      var startPosition, stopPosition

      initialise()

      function initialise () {
        window.onresize = onResize
        window.onscroll = onScroll
        setInterval(checkResize, interval)
        setInterval(checkScroll, interval)
        checkResize()
        checkScroll()
        stickyElement.classList.add('sticky-element--enabled')
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
          var elementHeight = wrapper.offsetHeight || parseFloat(wrapper.style.height.replace('px', ''))
          startPosition = wrapper.offsetTop
          stopPosition = wrapper.offsetTop + elementHeight - windowDimensions.height
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
        stickyElement.classList.add('sticky-element--stuck-to-window')
      }

      function stickToParent () {
        stickyElement.classList.remove('sticky-element--stuck-to-window')
      }

      function show () {
        stickyElement.classList.remove('sticky-element--hidden')
      }

      function hide () {
        stickyElement.classList.add('sticky-element--hidden')
      }
    }
  }
})(window.GOVUK.Modules)
