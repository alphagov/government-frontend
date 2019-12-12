function Klick2Contact(options) {
  this.k2c_baseLoad             = 0;
  this.k2c_provider             = 'HMPO2'; // Provider Name HMPO2 or HMPO
  this.k2c_url                  = 'https://hmpowebchat.klick2contact.com/v03'; // Url to console.
  this.k2c_launchServe          = 'https://hmpowebchat.klick2contact.com/v03'; // '', 'd' 's'
  this.k2c_staticDept           = "712" // 712 or 717
  this.k2c_staticChnl           = "CH"
  this.k2c_skin                 = "chat_a1"
  this.k2c_staticIID            = "UK"
  this.k2c_lang                 = "en"
  this.k2c_remark               = "K2C"
  this.k2c_StaticCustomString   = ""
  this.k2c_staticFCL            = "0"
  this.k2c_staticQueue          = "0"
}

Klick2Contact.prototype.apiResponseSuccess = function(result) {
  return this.apiResponse(result);
}

Klick2Contact.prototype.apiResponseError = function(result) {
  return this.apiResponse(result);
}

Klick2Contact.prototype.handleOpenChat = function(global) {
  global.open(this.openUrl(), 'newwin', 'width=200,height=100')
}

// k2c specific

Klick2Contact.prototype.openUrl = function()
{
  function encodeQueryData(data) {
     var ret = [];
     for (var d in data)
       ret.push(encodeURIComponent(d) + '=' + encodeURIComponent(data[d]));
     return ret.join('&');
  }

  function k2c_getUserCid() {
    /* Setup Customer ID cookie */
    var k2c_cid = k2c_getCookie('k2c_'+this.k2c_provider+"_cids");
    if (typeof k2c_cid == "undefined") {
        k2c_cid = this.k2c_provider+'_'+k2c_randomString(13);
        k2c_setCookie('k2c_'+this.k2c_provider+"_cids",k2c_cid);
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

  var data = {
    'p': this.k2c_provider,
    'd': this.k2c_staticDept,
    'ch': this.k2c_staticChnl,
    'psk': this.k2c_skin,
    'iid': this.k2c_staticIID,
    'c': k2c_getUserCid(),
    'l': this.k2c_lang,
    'u': encodeURIComponent(window.location.href),
    'r': this.k2c_remark + this.k2c_StaticCustomString,
    'fcl': this.k2c_staticFCL,
    'srbp': this.k2c_staticQueue,
    's': this.k2c_launchServe
  }

  var k2cOpenUrl = this.k2c_url + '/launcherV3.php?' + encodeQueryData(data)

  return k2cOpenUrl
}

Klick2Contact.prototype.apiResponse = function(result)
{
  var getValues = function(obj, key) {
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

  if (!result || !result.responseText || result.status == 0) {
    return { status: "ERROR" }
  } else {
    var responseStr = result.responseText.replace('k2c_doServiceStatus(\'','')
    responseStr = responseStr.slice(0,responseStr.length - 3)

    var responseJSON = JSON.parse(responseStr)
    if(responseJSON.DPT && parseInt(getValues(responseJSON.DPT[this.k2c_staticDept], 'DPT_AGENTS')) > 0) {
      if(parseInt(getValues(responseJSON.DPT[this.k2c_staticDept], 'DPT_AGENTS_WITHLIMIT')) >= parseInt(getValues(responseJSON.DPT[this.k2c_staticDept], 'DPT_AGENTS'))){
        return { status: "BUSY" }
      } else {
        return { status: "AVAILABLE" }
      }
    } else {
      return { status: "UNAVAILABLE" }
    }
  }
}
