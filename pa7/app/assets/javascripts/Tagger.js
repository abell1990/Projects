/* Class: Tagger
 * This class provides tagging functionality. The client will
 * create a Tagger object and pass in the following ids for HTML elements
 * in his page:
 * - id for a div element that delimits the region where tagging occurs, 
 *   which we call the canvasElement. A rectangle will be drawn over this area
 *   as the user clicks and drags the tag region
 * - if for a div element that will delimit the selected/tagged region. As
 *   the user clicks and drags over the canvasElement this div will dynamically
 *   resize and reposition itself to cover the region selected by the user. Notice
 *   this area will be clipped/forced to stay inside the canvasElement region.
 * - the last 4 ids are for input fields in some form in the client's page. 
 *   these fields will be populated and dyamically updated by the tagger object 
 *   on the fly with the feedbackDiv's current origin's x and y coordinates as 
 *   well as its width and height.
 */

function Tagger(canvasDivId, feedbackDivId, xFieldId, yFieldId, widthFieldId, heightFieldId) {
    this.element = document.getElementById(feedbackDivId);
    this.canvasElement = document.getElementById(canvasDivId);
    this.xField = document.getElementById(xFieldId);
    this.yField = document.getElementById(yFieldId);
    this.widthField = document.getElementById(widthFieldId);
    this.heightField = document.getElementById(heightFieldId);
    this.elementBorderWidth = parseInt(getComputedStyle(this.element).borderWidth);
    this.isMouseDown = false;

    var obj = this;
    this.canvasElement.onmousedown = function(event) {
        obj.mouseDown(event);
    }
}

Tagger.prototype.mouseDown = function(event) {
    event.preventDefault();

    var obj = this;

    this.oldMoveHandler = document.body.onmousemove;
    document.body.onmousemove = function(event) {
        obj.mouseMove(event);
    }
    this.oldUpHandler = document.body.onmouseup;
    document.body.onmouseup = function(event) {
        obj.mouseUp(event);
    }

    /* remember anchor point */
    this.anchorXAbsolute = event.pageX;
    this.anchorYAbsolute = event.pageY;

    /* remember canvas element's limit for clipping the feedback div */
    this.parentLeftXAbsolute = Tagger.absoluteXOffset(this.canvasElement);
    this.parentRightXAbsolute = Tagger.absoluteXOffset(this.canvasElement) + this.canvasElement.clientWidth;
    this.parentTopYAbsolute = Tagger.absoluteYOffset(this.canvasElement);
    this.parentBottomYAbsolute = Tagger.absoluteYOffset(this.canvasElement) + this.canvasElement.clientHeight;

    this.element.style.width = "0px";
    this.element.style.height = "0px";
    this.element.style.left = this.xCoordRelativeToCanvas(this.anchorXAbsolute) + "px";
    this.element.style.top = this.yCoordRelativeToCanvas(this.anchorYAbsolute) + "px";

    this.updateHiddenFields();

    this.isMouseDown = true;
}

Tagger.prototype.mouseMove = function(event) {
    if (!this.isMouseDown) {
        return;
    }

    var newWidth = event.pageX - this.anchorXAbsolute;

    /* clip feedback div if mouse moves outside the canvas element */
    var maxWidth = this.parentRightXAbsolute - this.anchorXAbsolute - 2 * this.elementBorderWidth; /* adjust for border on both sides */
    var minWidth = this.parentLeftXAbsolute - this.anchorXAbsolute;
    newWidth = Math.max(newWidth, minWidth);
    newWidth = Math.min(newWidth, maxWidth);

    if (newWidth >= 0){
        this.element.style.left = this.xCoordRelativeToCanvas(this.anchorXAbsolute) + "px";
        this.element.style.width = newWidth + "px";
    }
    else{ /* if mouse moved to the left of anchor we have to move the anchor x coord to the x coord of the event */
        this.element.style.left = this.xCoordRelativeToCanvas(this.anchorXAbsolute - Math.abs(newWidth)) + "px";
        this.element.style.width = Math.abs(newWidth) + "px";
    }

    /* repeat for the y coord... */

    var newHeight = event.pageY - this.anchorYAbsolute;

    /* clip feedback div if mouse moves outside the canvas element */
    var maxHeight = this.parentBottomYAbsolute - this.anchorYAbsolute - 2 * this.elementBorderWidth;  /* adjust for border on both sides */
    var minHeight = this.parentTopYAbsolute - this.anchorYAbsolute;
    newHeight = Math.max(newHeight, minHeight);
    newHeight = Math.min(newHeight, maxHeight);

    if (newHeight >= 0){
        this.element.style.top = this.yCoordRelativeToCanvas(this.anchorYAbsolute) + "px";
        this.element.style.height = newHeight + "px";
    }
    else{ /* if mouse moved to the above anchor we have to move the anchor y coord to the y coord of the event */
        this.element.style.top = this.yCoordRelativeToCanvas(this.anchorYAbsolute - Math.abs(newHeight)) + "px";
        this.element.style.height = Math.abs(newHeight) + "px";
    }

    this.updateHiddenFields();
}

Tagger.prototype.mouseUp = function(event) {
    this.isMouseDown = false;
    document.body.onmousemove = this.oldMoveHandler;
    document.body.onmouseup = this.oldUpHandler;
}

Tagger.prototype.updateHiddenFields = function ()
{
    this.xField.value = this.element.offsetLeft;
    this.yField.value = this.element.offsetTop;
    this.widthField.value = this.element.clientWidth;
    this.heightField.value = this.element.clientHeight;
}





/******* Helper method section ******/

Tagger.prototype.xCoordRelativeToCanvas = function (xCoord)
{
    var result = xCoord - Tagger.absoluteXOffset(this.canvasElement);

    /* Clip coordinate to be inside canvas */
    result = Math.min(this.canvasElement.clientWidth, result);
    result = Math.max(0, result);

    return result;
}

Tagger.prototype.yCoordRelativeToCanvas = function (yCoord)
{
    var result = yCoord - Tagger.absoluteYOffset(this.canvasElement);

    /* Clip coordinate to be inside canvas */
    result = Math.min(this.canvasElement.clientHeight, result);
    result = Math.max(0, result);

    return result;
}


Tagger.absoluteXOffset = function(element) {
    var left = 0;

    do {
        left += element.offsetLeft || 0;
        element = element.offsetParent;
    } while(element);

    return left;
}
Tagger.absoluteYOffset = function(element) {
    var top = 0;

    do {
        top += element.offsetTop  || 0;
        element = element.offsetParent;
    } while(element);

    return top;
}

/******* END Helper method section ******/

