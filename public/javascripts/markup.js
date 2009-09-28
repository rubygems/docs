var searchFieldId = '';
var resultFieldId = '';
var processURI    = '/markup/preview';
var emptyString   = '';
var liveReq = false;
var t = null;
var liveReqLast = "";

function addEvent(obj, evType, fn, useCapture) {
  if (obj.addEventListener) {
    obj.addEventListener(evType, fn, useCapture);
    return true;
  } else if (obj.attachEvent) {
    var r = obj.attachEvent("on"+evType, fn);
    return r;
  } else {
    alert("Handler could not be attached");
  }
}

function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      oldonload();
      func();
    }
  }
}

function removeEvent(obj, evType, fn, useCapture) {
  if (obj.removeEventListener) {
    obj.removeEventListener(evType, fn, useCapture);
    return true;
  } else if (obj.detachEvent) {
    var r = obj.detachEvent("on"+evType, fn);
    return r;
  } else {
    alert("Handler could not be removed");
  }
}

// on !IE we only have to initialize it once
if (window.XMLHttpRequest) {
  liveReq = new XMLHttpRequest();
}

function liveReqInit() {
  if (navigator.userAgent.indexOf("Safari") > 0) {
    document.getElementById(searchFieldId).addEventListener("keydown", liveReqStart, false);

  } else if (navigator.product == "Gecko") {
    document.getElementById(searchFieldId).addEventListener("keypress", liveReqStart, false);

  } else {
    document.getElementById(searchFieldId).attachEvent('onkeydown', liveReqStart);
  }

  if (resultFieldId == '') {
    // if a result field isn't on the page, this will sneak one in...
    resultFieldId = "liveRequestResults";
    displayArea = document.createElement('div');
    displayArea.id = "liveRequestResults";
    document.getElementsByTagName('body')[0].appendChild(displayArea);
  }

  if (emptyString == '') {
    // set the result field to hidden, or to default string
    document.getElementById(resultFieldId).style.display = "none";
  } else {
    document.getElementById(resultFieldId).innerHTML = emptyString;
  }
  liveReqDoReq();
}

function liveReqStart() {
  if (t) {
    window.clearTimeout(t);
  }
  t = window.setTimeout("liveReqDoReq()", 400);
}

function liveReqDoReq() {
  if (liveReqLast != document.getElementById(searchFieldId).value && document.getElementById(searchFieldId).value != "") {
    if (liveReq && liveReq.readyState < 4) {
      liveReq.abort();
    }
    if (window.XMLHttpRequest) {
      // branch for IE/Windows ActiveX version
    } else if (window.ActiveXObject) {
      liveReq = new ActiveXObject("Microsoft.XMLHTTP");
    }

    liveReq.onreadystatechange = liveReqProcessReqChange;
    liveReq.open("POST", processURI);
    liveReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
    liveReqLast = document.getElementById(searchFieldId).value;
    liveReq.send("text=" + encodeURI(document.getElementById(searchFieldId).value));
  } else if (document.getElementById(searchFieldId).value == "") {
    if (emptyString == '') {
      document.getElementById(resultFieldId).innerHTML = '';
      document.getElementById(resultFieldId).style.display = "none";
    } else {
      document.getElementById(resultFieldId).innerHTML = emptyString;
    }
  }
}

function liveReqProcessReqChange() {
  if (liveReq.readyState == 4) {
    document.getElementById(resultFieldId).innerHTML = liveReq.responseText;
    if (emptyString == '') {
      document.getElementById(resultFieldId).style.display = "block";
    }
  }
}

function initPreview(fieldid, previewid, def) {
  searchFieldId = fieldid;
  resultFieldId = previewid;
  emptyString = def;
  addLoadEvent(liveReqInit);
}

function quickRedReference() {
  window.open("/markup/popup",
              "redRef",
              "height=600,width=550,channelmode=0,dependent=0," +
              "directories=0,fullscreen=0,location=0,menubar=0," +
              "resizable=0,scrollbars=1,status=1,toolbar=0");
}

