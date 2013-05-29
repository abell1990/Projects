/* Class: Searcher
 * TODO: comment
 */

// TODO: extend to multiple query/value pairs. may need to do .js.erb
function Searcher(searchBarId, searchURL, searchQueryName) {
    this.element = document.getElementById(searchBarId);
    this.baseSearchURL = searchURL;
    this.searchQueryName = searchQueryName;

    var obj = this;
    this.element.onkeypress = function(event) {
        obj.keyPress(event);
    }
}

// TODO: this should be keydown and keyup since backspaces dont get detected
Searcher.prototype.keyPress = function (event) {
    var searchVal = this.element.value + String.fromCharCode(event.charCode);
    var searchURL = this.baseSearchURL + "?" + encodeURIComponent(this.searchQueryName) + "=" + encodeURIComponent(searchVal);

    var request = new XMLHttpRequest();

    request.onreadystatechange = function () {
        if (this.readyState != 4) {
            return;
        }
        if (this.status != 200) {
            // Handle error ...
            return;
        }
        var text = this.responseText;
        console.log(text);
    }

    request.open("GET", searchURL, true);
    request.send();
}




/******* Helper method section ******/

/******* END Helper method section ******/

