/* Class: AJAX
 * A simple wrapper class for a generic AJAX request. Modelled after jQuerys .ajax method.  
 */

/* Constructor:
 * Parameters:
 * - requestType: only GET and POST supported (defaults to GET)
 * - url: the base url for the HTTP request
 * - queryParams: a hash of key-value pairs for the request query/form data
 * - requestHeaders: a hash of headerName-heaader value pairs to be put as headers to the HTTP request
 * - onSuccessCallback: a callback function called when an HTTP 200 OK response comes back 
 * - onErrorCallback: a callback function called when an HTTP response with status != 200 comes back
 * - asynch: is the AJAX request asynchronous or not? (default to true)
 * - returnJSON: should the onSuccessCallback be called with a JSON object for the response (defaults to false)
 */
function AJAX(requestType, url, queryParams, requestHeaders, onSuccessCallback, onErrorCallback, asynch, returnJSON) {
    this.requestType = typeof requestType !== 'undefined' ? requestType : "GET";
    this.url = url;
    this.queryParams = queryParams;
    this.requestHeaders = requestHeaders;
    this.onSuccessCallback = onSuccessCallback;
    this.onErrorCallback = onErrorCallback;
    this.asynch = typeof asynch !== 'undefined' ? asynch : true;
    this.returnJSON = typeof returnJSON !== 'undefined' ? returnJSON : false;
}

AJAX.prototype.sendRequest = function () {

    /* Create and construct the AJAX request with the user provided data */
    var request = new XMLHttpRequest();
    
    for (var headerName in this.requestHeaders)
        request.setRequestHeader(headerName ,this.requestHeaders[headerName]);
    
    var obj = this;
    request.onreadystatechange = function () {
        if (this.readyState != 4)
            return;

        if ((this.status != 200) && obj.onErrorCallback) {
            obj.onErrorCallback(this.status, this.responseText);
            return;
        }
        if (obj.onSuccessCallback)
            if (obj.returnJSON)
                obj.onSuccessCallback(JSON.parse(this.responseText));
            else
                obj.onSuccessCallback(this.responseText);
    }

    /* Distinguish between GET and POST requests to send the query data
       in the URL or the body of the HTTP request. */
    if (obj.requestType == "GET"){
        var fullURL = obj.url + "?" + obj.URIEncodeQueryParams();
        request.open("GET", fullURL, obj.asynch);
        request.send();
    }
    if (obj.requestType == "POST"){
        request.open("POST", obj.url, obj.asynch);
        request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
        request.send(this.URIEncodeQueryParams());
    }

}




/******* Helper method section ******/

/* Takes all the query data provided by the user and URL encodes into a String of the \
   form id1=value1&id2=value2 ... */
AJAX.prototype.URIEncodeQueryParams = function ()
{
    var encodedParams = "";

    for (var k in this.queryParams)
    {
        encodedParams += encodeURIComponent(k) + "=" + encodeURIComponent(this.queryParams[k]) + "&";
    }

    return encodedParams.substring(0, encodedParams.length - 1);
}


/******* END Helper method section ******/

