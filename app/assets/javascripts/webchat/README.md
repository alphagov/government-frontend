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
