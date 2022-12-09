//= require ../vendor/clipboard.js

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function CopyButton (element) {
    this.element = element
  }

  CopyButton.prototype.init = function () {
    if (!this.element) return

    var $button = document.createElement('button')
    var $buttonTextContainer = document.createElement('span')
    var $buttonIcon = document.querySelector('.copy-button_svg')

    $button.className = 'copy-button js-copy-button'
    $button.setAttribute('aria-live', 'assertive')
    $buttonTextContainer.className = 'copy-button_text'
    $buttonTextContainer.textContent = 'Copy link'

    this.element.insertAdjacentElement('afterend', $button)
    $button.append($buttonIcon)
    $button.append($buttonTextContainer)

    $buttonIcon.removeAttribute('hidden')

    this.copyAction()
  }

  CopyButton.prototype.copyAction = function () {
    // Copy to clipboard
    try {
      /* eslint-disable */
      new ClipboardJS('.js-copy-button', {
      /* eslint-enable */
        text: function (trigger) {
          return window.location.href + '#' + trigger.previousElementSibling.id
        }
      }).on('success', function (e) {
        e.trigger.querySelector('.copy-button_text').textContent = 'Link copied'
        e.clearSelection()
        setTimeout(function () {
          e.trigger.querySelector('.copy-button_text').textContent = 'Copy link'
        }, 2000)
      })
    } catch (err) {
      if (err) {
        console.log(err.message)
      }
    }
  }

  Modules.CopyButton = CopyButton
})(window.GOVUK.Modules)
