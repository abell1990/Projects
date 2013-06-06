/* PhotoInstantSearch 
 * 
 * This class defines an object that can listen 
 * on an text input field and whenever the user types
 * something in it will make an AJAX call to the /photos/search
 * controller to get all the photos that match the input. 
 * After it gets the results for all the photos that match 
 * it updates the DOM of the users/index.page to display 
 * an updated grid of thumbnails of all the photos that match.
 */

/* Constructor:
 * Parameters:
 * - searchBarId: the id for the text input element to listen on
 * - resultsDivId: the id for the div on which to put the resulting thumnails on
 */
function PhotoInstantSearch(searchBarId, resultsDivId) {
    this.inputElement = document.getElementById(searchBarId);
    this.resultsContainer = document.getElementById(resultsDivId);
    this.oldSearchVal = "";

    var obj = this;

    /* this callback is called with an an array of 
      (user id, photo id, photo URL) for all the matching
      photos for a given query. It then updates the DOM 
      to show a grid of 'hot' thumnails for those photos */
    this.callback = function (responseArray){
        obj.resultsContainer.innerHTML = "";

        if (responseArray.length == 0){
            return;
        }

        obj.resultsContainer.style.display = "block";

        /* update the DOM for every matching photo with a thumbnail */
        for (var i = 0; i < responseArray.length; i++){
            var res = responseArray[i];
            var elem = document.createElement("DIV");

            elem.innerHTML = "<a href=\"/photos/index/" + res[0] +  "?photo_search=" + res[1] + "\">" +
                                "<span class=\"mugshotSmall\" style=\"background-image: url('" + res[2] + "');\"></span>" +
                             "</a>";
            obj.resultsContainer.appendChild(elem);
        }
    }

    this.inputElement.onkeyup = function(event){
        obj.keyUp(event);
    }

}

/* Listen on the text input field every time a key is released */
PhotoInstantSearch.prototype.keyUp = function (event)
{
    var searchVal = this.inputElement.value;

    /* has the input changed, if not dont do anything */ 
    if (this.oldSearchVal == searchVal){
        return;
    }

    /* else form an AJAX request for the input and send it to the photos/search controller action */
    this.oldSearchVal = searchVal;

    var qparams = {"search_str": this.inputElement.value};
    var request = new AJAX("GET", "/photos/search", qparams, null, this.callback, null, true, true);
    request.sendRequest();
}