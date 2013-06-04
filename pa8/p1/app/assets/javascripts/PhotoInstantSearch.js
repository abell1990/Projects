function PhotoInstantSearch(searchBarId, resultsDivId) {
    this.inputElement = document.getElementById(searchBarId);
    this.resultsContainer = document.getElementById(resultsDivId);
    this.oldSearchVal = "";

    var obj = this;

    this.callback = function (responseText){
        var responseArray = JSON.parse(responseText);

        obj.resultsContainer.innerHTML = "";

        if (responseArray.length == 0){
            return;
        }

        obj.resultsContainer.style.display = "block";

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

PhotoInstantSearch.prototype.keyUp = function (event)
{
    var searchVal = this.inputElement.value;

    if (this.oldSearchVal == searchVal){
        return;
    }

    this.oldSearchVal = searchVal;

    var request = new AJAXGetWrapper("/photos/search", {"search_str": this.inputElement.value}, this.callback);
    request.sendRequest();
}