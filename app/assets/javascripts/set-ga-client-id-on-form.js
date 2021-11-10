window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function SetGaClientIdOnForm ($module) {
    this.$module = $module
  }

  SetGaClientIdOnForm.prototype.init = function () {
    var form = this.$module
    window.ga(function (tracker) {
      var clientId = tracker.get('clientId')
      var action = form.getAttribute('action')
      form.setAttribute('action', action + '?_ga=' + clientId)
    })
  }

  Modules.SetGaClientIdOnForm = SetGaClientIdOnForm
})(window.GOVUK.Modules)
