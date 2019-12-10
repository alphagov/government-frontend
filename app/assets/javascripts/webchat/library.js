(function (global) {
  'use strict'
  var $ = global.jQuery
  var windowOpen = global.open
  if (typeof global.GOVUK === 'undefined') { global.GOVUK = {} }
  var GOVUK = global.GOVUK


  function Webchat (options) {
    var POLL_INTERVAL = 5 * 1000
    var AJAX_TIMEOUT  = 5 * 1000
    var API_STATES = [
      "BUSY",
      "UNAVAILABLE",
      "AVAILABLE",
      "ERROR"
    ]
    var $el                 = $(options.$el)
    var chatProvider        = $el.attr('data-chat-provider')
    var openUrl             = $el.attr('data-open-url')
    var availabilityUrl     = $el.attr('data-availability-url')
    var $openButton         = $el.find('.js-webchat-open-button')
    var webchatStateClass   = 'js-webchat-advisers-'
    var intervalID          = null
    var lastRecordedState   = null

    var k2c_staticDept           = "712" // 712 or 717

    function init () {
      if (!availabilityUrl || !openUrl) throw 'urls for webchat not defined'
      $openButton.on('click', handleOpenChat)
      intervalID = setInterval(checkAvailability, POLL_INTERVAL)
      checkAvailability()
    }

    function handleOpenChat (evt) {
      evt.preventDefault()

      switch(chatProvider) {
        case "k2c":
          global.open(k2cOpenUrl(), 'newwin', 'width=469,height=526')
          break;
        default:
          // defaults to HMRC
          global.open(openUrl, 'newwin', 'width=200,height=100')
      }
      trackEvent('opened')
    }

    function checkAvailability () {

      switch(chatProvider) {
        case "k2c":
          k2cAvailability()
          break;
        default:
          // defaults to HMRC
          hmrcAvailability()
      }
    }

    function k2cOpenUrl (){


              /* Setup provider vars */
              var k2c_baseLoad         = 0;
              var k2c_provider         = 'HMPO2'; // Provider Name HMPO2 or HMPO
              var k2c_url              = 'https://hmpowebchat.klick2contact.com/v03'; // Url to console.
              var k2c_launchServe      = 'https://hmpowebchat.klick2contact.com/v03'; // '', 'd' 's'

              //var k2c_staticDept           = "712" // 712 or 717
              var k2c_staticChnl           = "CH"
              var k2c_skin                 = "chat_a1"
              var k2c_staticIID            = "UK"
              var k2c_lang                 = "en"
              var k2c_remark               = "K2C"
              var k2c_StaticCustomString   = ""
              var k2c_staticFCL            = "0"
              var k2c_staticQueue          = "0"

              function k2c_getUserCid () {
                /* Setup Customer ID cookie */
                var k2c_cid = k2c_getCookie('k2c_'+k2c_provider+"_cids");
                if (typeof k2c_cid == "undefined") {
                    k2c_cid = k2c_provider+'_'+k2c_randomString(13);
                    k2c_setCookie('k2c_'+k2c_provider+"_cids",k2c_cid);
                }
                return k2c_cid;
              }

              function k2c_getCookie(c_name) {

                if (c_name=='k2c_history' && typeof(window.k2c_page)!='undefined') {
                  return window.k2c_page;
                }

                var i,x,y,ARRcookies=document.cookie.split(";");
                for (i=0;i<ARRcookies.length;i++) {
                  x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
                  y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
                  x=x.replace(/^\s+|\s+$/g,"");
                  if (x==c_name) {
                    return unescape(y);
                  }
                }
              }

              function k2c_setCookie(c_name,value,exdays) {
                if (exdays==null) {
                  var exdays = 1;
                }
                var exdate=new Date();
                exdate.setDate(exdate.getDate() + exdays);
                if (exdays!=0) {
                  var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString()+"; path=/");
                } else {
                  var c_value=escape(value) +"; path=/";
                }
                document.cookie=c_name + "=" + c_value;
              }

              function k2c_randomString(length) {
                var chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
                var chars = chars.split('');
                var result = '';
                for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
                return result;
              }

               var k2cOpenUrl = k2c_url+'/launcherV3.php?p='+k2c_provider+'&d='+k2c_staticDept+'&ch='+k2c_staticChnl+'&psk='+k2c_skin+'&iid='+k2c_staticIID+'&c='+k2c_getUserCid()+'&l='+k2c_lang+'&u='+encodeURIComponent(window.location.href)+'&r='+k2c_remark+k2c_StaticCustomString+'&fcl='+k2c_staticFCL+'&srbp='+k2c_staticQueue+'&s='+k2c_launchServe;

      return k2cOpenUrl
    }

    function k2cResponse(result){

      if(result.status == 0){
        advisorStateChange("ERROR")
      }else{
        var responseStr = result.responseText.replace('k2c_doServiceStatus(\'','')
        responseStr = responseStr.slice(0,responseStr.length - 3)

        var responseJSON = JSON.parse(responseStr)
        if(parseInt(getValues(responseJSON.DPT[k2c_staticDept], 'DPT_AGENTS')) > 0) {
          if(parseInt(getValues(responseJSON.DPT[k2c_staticDept], 'DPT_AGENTS_WITHLIMIT')) >= parseInt(getValues(responseJSON.DPT[k2c_staticDept], 'DPT_AGENTS'))){
            advisorStateChange("BUSY")
          }else{
            advisorStateChange("AVAILABLE")
          }
        }else{
          advisorStateChange("UNAVAILABLE")
        }
      }


    }

    function k2cAvailability(){
      var ajaxConfig = {
        url: availabilityUrl,
        type: 'GET',
        dataType: 'json',
        timeout: AJAX_TIMEOUT,
        success: k2cResponse,
        error: k2cResponse
      }
      $.ajax(ajaxConfig)
    }

    function hmrcAvailability(){
      var ajaxConfig = {
        url: availabilityUrl,
        type: 'GET',
        timeout: AJAX_TIMEOUT,
        success: apiSuccess,
        error: apiError
      }
      $.ajax(ajaxConfig)
    }

    function getValues(obj, key) {
      var objects = [];
      for (var i in obj) {
          if (!obj.hasOwnProperty(i)) continue;
          if (typeof obj[i] == 'object') {
              objects = objects.concat(getValues(obj[i], key));
          } else if (i == key) {
              objects.push(obj[i]);
          }
      }
      return objects;
        }

    function apiSuccess (result) {
      var validState  = API_STATES.indexOf(result.response) != -1
      var state       = validState ? result.response : "ERROR"
      advisorStateChange(state)
    }

    function apiError () {
      clearInterval(intervalID)
      advisorStateChange('ERROR')
    }

    function advisorStateChange (state) {
      state = state.toLowerCase()
      var currentState = $el.find("." + webchatStateClass + state)
      $el.find('[class^="' + webchatStateClass + '"]').addClass('hidden')
      currentState.removeClass('hidden')
      trackEvent(state)
    }

    function trackEvent (state) {
      state = state.toLowerCase()
      if (lastRecordedState === state) return

      GOVUK.analytics.trackEvent('webchat', state)
      lastRecordedState = state
    }

    init()
  }

  global.GOVUK.Webchat = Webchat
})(window)
