window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function HighlightActiveSectionHeading ($module) {
    this.$module = $module
    this._hasResized = true
    this._hasScrolled = true
    this._interval = 50
    this.anchorIDs = []
  }

  HighlightActiveSectionHeading.prototype.init = function () {
    window.addEventListener('resize', function () { this._hasResized = true }.bind(this))
    window.addEventListener('scroll', function () { this._hasScrolled = true }.bind(this))

    setInterval(this.checkResize.bind(this), this._interval)
    setInterval(this.checkScroll.bind(this), this._interval)

    this.anchors = this.$module.querySelectorAll('.js-page-contents a')
    this.getAnchors()

    this.checkResize()
    this.checkScroll()
  }

  HighlightActiveSectionHeading.prototype.checkResize = function () {
    if (this._hasResized) {
      this._hasResized = false
      this._hasScrolled = true
    }
  }

  HighlightActiveSectionHeading.prototype.checkScroll = function () {
    if (this._hasScrolled) {
      this._hasScrolled = false
      var windowDimensions = this.getWindowDimensions()
      if (windowDimensions.width <= 768) {
        this.removeActiveItem()
      } else {
        this.updateActiveNavItem()
      }
    }
  }

  HighlightActiveSectionHeading.prototype.getWindowDimensions = function () {
    return {
      height: window.innerHeight,
      width: window.innerWidth
    }
  }

  HighlightActiveSectionHeading.prototype.getAnchors = function () {
    for (var i = 0; i < this.anchors.length; i++) {
      var anchorID = this.anchors[i].getAttribute('href')
      // e.g. anchorIDs['#meeting-the-digital-service-standard', '#understand-your-users', '#research-continually']
      this.anchorIDs.push(anchorID)
    }
  }

  HighlightActiveSectionHeading.prototype.updateActiveNavItem = function () {
    var windowVerticalPosition = this.getWindowPositions()
    var footerPosition = this.getFooterPosition()

    for (var i = 0; i < this.anchors.length; i++) {
      var theID = this.anchorIDs[i]
      var theNextID = this.anchorIDs[i + 1]

      var $theID = document.getElementById(theID.substring(1)) // remove the # at the start
      var $theNextID = theNextID ? document.getElementById(theNextID.substring(1)) : null // remove the # at the start

      var headingPosition = this.getHeadingPosition($theID)
      if (!headingPosition) {
        return
      }

      headingPosition = headingPosition - 53 // fix the offset from top of page

      if (theNextID) {
        var nextHeadingPosition = this.getNextHeadingPosition($theNextID)
      }

      var distanceBetweenHeadings = this.getDistanceBetweenHeadings(headingPosition, nextHeadingPosition)
      var isPastHeading

      if (distanceBetweenHeadings) {
        isPastHeading = (windowVerticalPosition >= headingPosition && windowVerticalPosition < (headingPosition + distanceBetweenHeadings))
      } else {
        // when distanceBetweenHeadings is false (as there isn't a next heading)
        isPastHeading = (windowVerticalPosition >= headingPosition && windowVerticalPosition < footerPosition)
      }

      if (isPastHeading) {
        this.setActiveItem(theID)
      }
    }
  }

  HighlightActiveSectionHeading.prototype.getFooterPosition = function () {
    var footer = document.querySelector('.govuk-footer')
    if (footer) {
      return this.getElementPosition(footer)
    }
  }

  // these two functions call getElementPosition because the test needs to individually
  // override them - otherwise we could combine these four functions into one
  HighlightActiveSectionHeading.prototype.getHeadingPosition = function (element) {
    return this.getElementPosition(element)
  }

  HighlightActiveSectionHeading.prototype.getNextHeadingPosition = function (element) {
    return this.getHeadingPosition(element)
  }

  HighlightActiveSectionHeading.prototype.getElementPosition = function (element) {
    if (element) {
      var rect = element.getBoundingClientRect()
      var offset = {
        top: rect.top + window.scrollY,
        left: rect.left + window.scrollX
      }
      return offset.top
    }
  }

  HighlightActiveSectionHeading.prototype.getDistanceBetweenHeadings = function (headingPosition, nextHeadingPosition) {
    var distanceBetweenHeadings = (nextHeadingPosition - headingPosition)
    return distanceBetweenHeadings
  }

  HighlightActiveSectionHeading.prototype.setActiveItem = function (theID) {
    for (var i = 0; i < this.anchors.length; i++) {
      var href = this.anchors[i].getAttribute('href')
      if (href === theID) {
        this.anchors[i].classList.add('active')
      } else {
        this.anchors[i].classList.remove('active')
      }
    }
  }

  HighlightActiveSectionHeading.prototype.removeActiveItem = function () {
    for (var i = 0; i < this.anchors.length; i++) {
      this.anchors[i].classList.remove('active')
    }
  }

  HighlightActiveSectionHeading.prototype.getWindowPositions = function () {
    var doc = document.documentElement
    var top = (window.pageYOffset || doc.scrollTop) - (doc.clientTop || 0)
    return top
  }

  Modules.HighlightActiveSectionHeading = HighlightActiveSectionHeading
})(window.GOVUK.Modules)
