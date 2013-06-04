/* Class: AJAXGetRequest
 * TODO: comment
 */

// TODO: extent to GET and POST requests???
function AJAXGetWrapper(url, queryParams, callback) {
    this.url = url;
    this.queryParams = queryParams;
    this.callback = callback;
}

AJAXGetWrapper.prototype.sendRequest = function () {

    var searchURL = this.constructFullURL();

    var request = new XMLHttpRequest();

    var obj = this;

    request.onreadystatechange = function () {
        if (this.readyState != 4) {
            return;
        }
        if (this.status != 200) {
            // TODO: Handle error ...
            return;
        }

        obj.callback(this.responseText);
    }

    request.open("GET", searchURL, true);
    request.send();
}




/******* Helper method section ******/

AJAXGetWrapper.prototype.constructFullURL = function ()
{
    var fullURL = this.url + "?";

    for (var k in this.queryParams)
    {
        fullURL += encodeURIComponent(k) + "=" + encodeURIComponent(this.queryParams[k]) + "&";
    }

    return fullURL.substring(0, fullURL.length - 1);
}


/******* END Helper method section ******/

