describe('Egain', function () {

  var egain

  beforeEach(function () {
    egain = new Egain({
      openUrl: "https://blahchat.gov.uk"
    })
  })

  it('should create egain class correctly', function () {
    expect(egain.openUrl).toBe("https://blahchat.gov.uk")
    expect(egain.API_STATES).toEqual([
      "BUSY",
      "UNAVAILABLE",
      "AVAILABLE",
      "ERROR"
    ])
  })

  it('should return busy if agent is busy', function () {
    var result = {
      response: "BUSY"
    }

    expect(egain.apiResponseSuccess(result).status).toBe("BUSY")
  })

  it('should return error if invalid state is given', function () {
    var result = {
      response: "THIS_IS_INVALID"
    }

    expect(egain.apiResponseSuccess(result).status).toBe("ERROR")
  })

  it('should return error for when the API responds with an error', function () {
    expect(egain.apiResponseError({}).status).toBe("ERROR")
  })
});
