/* global describe beforeEach it spyOn expect */

var $ = window.jQuery

describe('A GOV.UK Verify hint box', function () {

  var GOVUK = window.GOVUK
  var element
  var hint

  beforeEach(function () {

    element = $('<div id="verify-hint" style="display:none"></div>')

    hint = new GOVUK.Modules.ShowGovUkVerifyHint()
    hint.start(element)
  })


  it('renders when a positive response is received', function () {
    var data = {
      found: 'true',
      displayName: 'Stub IDP',
      simpleId: 'stub-idp'
    }

    hint.render(element, data)
    heading = element.find('h2').text()
    idp_logo_path = element.find('img.verify-hint-logos-idp')[0].src
    button_path = element.find('a.govuk-button')[0].href
    expect(heading).toBe('Someone recently signed in with '+ data['displayName'] +' on this device')
    expect(idp_logo_path).toBe('https://gds-verify-frontend-assets.s3.amazonaws.com/4af94ca-c1e26b4/' + data['simpleId'] + '.png')
    expect(button_path).toBe('https://www.signin.service.gov.uk/initiate-journey/hmrc-personal-tax-account?journey_hint=idp_' + data['simpleId'])
    expect(element.css('display')).not.toBe('none');
  })

  it('does not render when a negative response is received', function () {
    var data = {
      found: 'false'
    }

    expect($(element)).toBeHidden()
    hint.render(element, data)
    expect(element.css('display')).toBe('none');
    expect($(element)).toBeEmpty()
  })

  it('does not render when a null response is received', function () {
    var data = null

    expect($(element)).toBeHidden()
    hint.render(element, data)
    expect(element.css('display')).toBe('none');
    expect($(element)).toBeEmpty()
  })
})
