### GOVUK webchat

GOV UK webchat has been made to make it easy to implement webchat across all GOV.UK pages.
Departments within government have multiple webchat integrations, and we cannot support them all.

To this end, we have created a unified API for the javascript implementation, and recommend that departments implement a proxy for their own availability api.


#### availability api implementation

we have [made a reference implementation](https://github.com/alphagov/reference-webchat-proxy) of a proxy for the egain api to illustrate how you would create one.


##### the api needs to respond with the following

---
###### webchat has a technical error
any response that does not conform to an available response type will render a technical error,
as will a non 200 type response.

```
  {
    status: "failure",
    response: "A_RANDOM_FAILURE_STATE"
  }

```
###### WebChat is available
```
  response code: 200
  {
    status: "success",
    response: "AVAILABLE"
  }
```
###### WebChat is unavailable
```
  response code: 200
  {
    status: "success",
    response: "UNAVAILABLE"
  }
```
###### WebChat is busy
```
  response code: 200
  {
    status: "success",
    response: "BUSY"
  }
```
---

#### usage

to use the webchat implementation we have a [shared partial](https://github.com/alphagov/government-frontend/blob/957e3fb325eb3ff78b277ceb7054417849009756/app/views/shared/_webchat.html.erb) in which you need to pass the locals `webchat_availability_url` and `webchat_open_url`.

the webchat_availability_url is your proxy as documented above
the webchat_open_url is what page to actually open for webchat, we recommend you push this through the proxy as well


once you have your partial rendering on the page, you will need to make sure the [library](https://github.com/alphagov/government-frontend/blob/957e3fb325eb3ff78b277ceb7054417849009756/app/assets/javascripts/webchat/library.js) is included on your page and this in your initialisation code.

```
  $('.js-webchat').map(function () {
    return new GOVUK.Webchat({
      $el: $(this),
    })
  })

```
 a fuller example can be seen [here](https://github.com/alphagov/government-frontend/blob/957e3fb325eb3ff78b277ceb7054417849009756/app/assets/javascripts/webchat.js#L31-L41) that has an implementation of the normalisation as noted below

##### note regarding response Normalisation
as can be seen in the fuller example above, we currently have the option to do the normalisation in javascript, this is deprecated, and is shim code until all current users of webchat have there own proxies up and running
