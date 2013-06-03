/* Class: Searcher
 * TODO: comment
 */

// TODO: extend to multiple query/value pairs. may need to do .js.erb
// TODO: extent to GET and POST requests???
function Searcher(searchBarId, callback, searchURL, searchQueryName) {
    this.element = document.getElementById(searchBarId);
    this.callback = callback;
    this.baseSearchURL = searchURL;
    this.searchQueryName = searchQueryName;
    this.oldSearchVal = "";

    var obj = this;
    this.element.onkeyup = function(event) {
        obj.keyUp(event);
    }
}

// TODO: this should be keydown and keyup since backspaces dont get detected
Searcher.prototype.keyUp = function (event) {
    var searchVal = this.element.value;

    if (searchVal == this.oldSearchVal){
        return;
    }

    this.oldSearchVal = searchVal;

    var searchURL = this.baseSearchURL + "?" + encodeURIComponent(this.searchQueryName) + "=" + encodeURIComponent(searchVal);

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
        var response = JSON.parse(this.responseText);

        obj.callback(response);
    }

    request.open("GET", searchURL, true);
    request.send();
}




/******* Helper method section ******/

/******* END Helper method section ******/

