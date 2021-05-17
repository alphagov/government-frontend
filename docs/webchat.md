# Webchat Component

This Webchat can represent four 'busy', 'unavailable', 'available', 'error'.

## Supporting backend API Proxy

See the [reference implementation](https://github.com/alphagov/reference-webchat-proxy) for the backend API that is used alongside this component.

## Usage

The Webchat should be accessed through a shared [shared partial](https://github.com/alphagov/government-frontend/blob/957e3fb325eb3ff78b277ceb7054417849009756/app/views/shared/_webchat.html.erb) in which you need to pass the locals `webchat_availability_url` and `webchat_open_url`.

`webchat_availability_url` will be polled at an interval to check for the webchat instances' avaliability.


`webchat_open_url` is the page that will be opened when a user clicks the webchat call-to-action showm in the 'avaliable' state.


Finally once you have your partial rendering on the page, you will need to make sure the [library](https://github.com/alphagov/government-frontend/blob/957e3fb325eb3ff78b277ceb7054417849009756/app/assets/javascripts/webchat/library.js) is included on your page and this in your initialisation code.

```
  $('.js-webchat').map(function () {
    return new GOVUK.Webchat({
      $el: $(this),
    })
  })

```
 a fuller example can be seen [here](https://github.com/alphagov/government-frontend/blob/957e3fb325eb3ff78b277ceb7054417849009756/app/assets/javascripts/webchat.js#L31-L41) that has an implementation of the normalisation as noted below

### Note regarding response Normalisation
As can be seen in the fuller example above, we currently have the option to do the normalisation in JavaScript, this is deprecated, and is shim code until all current users of Wbchat have their own proxies up and running.

Once this shim is removed we can move this component into Static as a GOV.UK Publishing Component

## How to add a new webchat provider

1. Open to `lib/webchat.yaml`
2. Append new entry:
```yaml
- base_path: /government/contact/my-amazing-service
  open_url: https://www.my-amazing-webchat.com/007/open-chat
  availability_url: https://www.my-amazing-webchat.com/007/check-availability
```

3. Deploy changes
4. Go to https://www.gov.uk/government/contact/my-amazing-service
5. Finished

## CORS considerations
To avoid CORS and CSP issues a new provider would need to be added to the Content Security Policy

## Required configuration

### Base path
This is the base path of a contact page, for example, `/government/organisations/hm-revenue-customs/contact/child-benefit`.
This path should always be a contact page, any other content page type will result in the webchat component not being loaded.

### Availability URL

This URL is used to check the availability of agents at regular intervals.

|  Function  |  Required |
|-----------|-----------|
| Request Method  | GET  |
| Response Format | JSON/JSONP (Default to JSONP) |
| Request Example | {"status":"success","response":"BUSY"}  |
| Valid statuses | ["BUSY", "UNAVAILABLE", "AVAILABLE","ONLINE", "OFFLINE", "ERROR"] |

### Open URL
This url is used to start a webchat session.
This url should not include session ids or require anything specific parameters to be generated.

## Optional Configuration options

### Browser window behaviour

By default the chat session would open in an a separate browser window. An additional value can be added to the yaml entry that will allow the web chat to remain in the current browser window.
```yaml
  open_url_redirect: true
```

### Payload format

The default response from the api as used by HMRC webchat provider is JSONP. To add a provider that responds using JSON the following entry needs to be added.
```yaml
  availability_payload_format: json
```
