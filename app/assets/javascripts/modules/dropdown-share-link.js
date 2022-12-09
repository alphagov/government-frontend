window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function DropdownShareLink ($module) {
    this.$module = $module
  }

  DropdownShareLink.prototype.init = function () {
    var shareSection = document.createElement('div')

    // Add necessary markup to DOM
    shareSection.className = 'share-section share-section--hidden'
    shareSection.innerHTML = '<div class="share-section__content"><a href="#">Copy the link to this section</a></div>'

    this.$module.after(shareSection)
    this.share = this.$module.nextElementSibling
    this.copySection = this.share.querySelector('.share-section__copySection')

    // Add event listener for show/hide function
    this.$module.addEventListener('click', function () {
      this.showHideCopyLink()
    }.bind(this))

    // Add event listener for the copy function
    this.share.querySelector('a').addEventListener('click', function (e) {
      e.preventDefault()
      this.copyLink()
    }.bind(this))
  }

  DropdownShareLink.prototype.showHideCopyLink = function () {
    if (this.share.classList.contains('share-section--hidden')) {
      this.share.classList.remove('share-section--hidden')
    } else {
      this.share.classList.add('share-section--hidden')
    }
  }

  DropdownShareLink.prototype.copyLink = function () {
    var address = location.href
    var url

    // get the URL to be copied
    if (location.href.split('#').length > 1) {
      address = location.href.split('#')[0]
    }

    url = address + '#' + this.$module.id

    // Copy the URL to the clipboard
    navigator.clipboard.writeText(url).then(
      () => {
        // clipboard successfully set
        this.$module.nextElementSibling.innerHTML = '<p>Link copied</p>'
      },
      (err) => {
        // clipboard write failed
        console.log('clipboard not set: ', err)
      }
    )
  }

  Modules.DropdownShareLink = DropdownShareLink
})(window.GOVUK.Modules)
