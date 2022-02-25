window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function GtmTracking ($module) {
    this.$module = $module
  }

  GtmTracking.prototype.init = function () {
    this.$module.handleClick = this.handleClick.bind(this)

    this.$module.addEventListener(
      'click',
      this.$module.handleClick()
    )
  }

  GtmTracking.prototype.handleClick = function (eventDetails) {
    return function (event) {
      var element = event.target
      window.dataLayer = window.dataLayer || []
      window.dataLayer.push({
        event: 'analytics',
        event_name: element.dataset.gtmevent,
        click_text: element.dataset.gtmtext,
        click_url: element.dataset.gtmurl,
        link_category: element.dataset.gtmlabel
      })
    }
  }

  Modules.GtmTracking = GtmTracking
})(window.GOVUK.Modules)
