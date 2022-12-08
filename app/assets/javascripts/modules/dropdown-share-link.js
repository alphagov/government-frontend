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
    shareSection.innerHTML =
      '<a href="#" class="share-section__content">Copy the link to this section</a>' +
      '<input class="share-section__copySection govuk-visually-hidden"/>'

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

    // copy the URL to a hidden field
    if (location.href.split('#').length > 1) {
      address = location.href.split('#')[0]
    }

    url = address + '#' + this.$module.id
    this.copySection.value = url

    // Select the URL and make a copy of it
    this.copySection.select()
    document.execCommand('copy')
  }

  Modules.DropdownShareLink = DropdownShareLink
})(window.GOVUK.Modules)
