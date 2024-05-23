window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function HideOtherLinks (module) {
    this.module = module
    this.anchors = this.module.querySelectorAll('a')
    this.childNodes = this.module.childNodes
    this.hiddenElementContainer = this.createHiddenElementContainer()
    this.shownElements = []
    this.hiddenElements = []
    this.showLink = document.createElement('button')
  }

  HideOtherLinks.prototype.init = function () {
    if (this.anchors.length <= 2 && this.module.textContent.length <= 100) {
      return
    }

    this.sortChildNodes()

    if (!this.hiddenElements.length) {
      return
    }

    this.hideElements()
    this.createShowLink()

    this.module.setAttribute('aria-live', 'polite')
  }

  HideOtherLinks.prototype.sortChildNodes = function () {
    var linksCount = 0

    this.childNodes.forEach(function (node) {
      if (linksCount >= 1) {
        this.hiddenElements.push(node)
      } else {
        this.shownElements.push(node)
      }

      if (node.nodeName.toLowerCase() === 'a') {
        linksCount += 1
      }
    }, this)
  }

  HideOtherLinks.prototype.createShowLink = function () {
    var hiddenCount = this.hiddenElementContainer.children.length
    var linkText = '<span class="plus">+</span> ' + hiddenCount + ' other' + (hiddenCount > 1 ? 's' : '')

    this.showLink.classList.add('show-other-content', 'govuk-link')
    this.showLink.innerHTML = linkText
    this.showLink.setAttribute('aria-expanded', 'false')
    this.showLink.setAttribute('aria-controls', 'other-content')

    this.showLink.addEventListener('click', this.showHiddenLinks.bind(this))

    this.hiddenElementContainer.parentNode.insertBefore(this.showLink, this.hiddenElementContainer)
  }

  HideOtherLinks.prototype.hideElements = function () {
    this.module.append(this.hiddenElementContainer)

    this.hiddenElements.forEach(function (node) {
      this.hiddenElementContainer.appendChild(node)
    }, this)

    this.hiddenElementContainer.style.display = 'none'
  }

  HideOtherLinks.prototype.createHiddenElementContainer = function () {
    var showHide = document.createElement('span')
    showHide.classList.add('other-content')
    showHide.id = 'other-content'

    return showHide
  }

  HideOtherLinks.prototype.showHiddenLinks = function (event) {
    event.preventDefault()

    this.hiddenElementContainer.style.display = ''
    this.hiddenElementContainer.querySelectorAll('a')[0].focus()
    this.showLink.remove()
  }

  Modules.HideOtherLinks = HideOtherLinks
})(window.GOVUK.Modules)
