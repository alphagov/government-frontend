function Egain(options) {
  this.openUrl = options.openUrl
  this.API_STATES = [
    "BUSY",
    "UNAVAILABLE",
    "AVAILABLE",
    "ERROR"
  ]
}

Egain.prototype.apiResponseSuccess = function(result) {
  var validState  = this.API_STATES.indexOf(result.response) != -1
  return validState ? { status: result.response } : { status: "ERROR" }
}

Egain.prototype.apiResponseError = function(result) {
  return { status: "ERROR" };
}

Egain.prototype.handleOpenChat = function(global) {
  global.open(this.openUrl, 'newwin', 'width=200,height=100')
}
