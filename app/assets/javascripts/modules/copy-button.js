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
    $button.className = 'gem-c-button govuk-button govuk-button--secondary js-copy-button'
    $button.setAttribute('aria-live', 'assertive')
    $button.textContent = 'Copy link'

    this.element.insertAdjacentElement('afterend', $button)
    this.copyAction()
  }

  CopyButton.prototype.copyAction = function () {
    // Copy to clipboard
    try {
      new ClipboardJS('.js-copy-button', {
        text: function (trigger) {
          return window.location.href + "#" + trigger.previousElementSibling.id
        }
      }).on('success', function (e) {
        e.trigger.textContent = 'Link copied'
        e.clearSelection()
        setTimeout(function () {
          e.trigger.textContent = 'Copy link'
        }, 5000)
      })
    } catch (err) {
      if (err) {
        console.log(err.message)
      }
    }
  }

  Modules.CopyButton = CopyButton
})(window.GOVUK.Modules)
