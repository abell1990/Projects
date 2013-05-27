function Tagger(parentDivId, feedbackDivId, xFieldId, yFieldId, widthFieldId, heightFieldId) {
    this.element = document.getElementById(feedbackDivId);
    this.parentElement = document.getElementById(parentDivId);
    this.xField = document.getElementById(xFieldId);
    this.yField = document.getElementById(yFieldId);
    this.widthField = document.getElementById(widthFieldId);
    this.heightField = document.getElementById(heightFieldId);
    this.isMouseDown = false;

    var obj = this;
    this.parentElement.onmousedown = function(event) {
        obj.mouseDown(event);
    }
}

Tagger.prototype.mouseDown = function(event) {
    var obj = this;

    this.oldMoveHandler = document.body.onmousemove;
    document.body.onmousemove = function(event) {
        obj.mouseMove(event);
    }
    this.oldUpHandler = document.body.onmouseup;
    document.body.onmouseup = function(event) {
        obj.mouseUp(event);
    }

    this.origX = event.pageX;
    this.origY = event.pageY;
    this.parentLeftX = Tagger.absoluteXOffset(this.parentElement);
    this.parentRightX = Tagger.absoluteXOffset(this.parentElement) + this.parentElement.clientWidth;
    this.parentTopY = Tagger.absoluteYOffset(this.parentElement);
    this.parentBottomY = Tagger.absoluteYOffset(this.parentElement) + this.parentElement.clientHeight;

    this.element.style.width = "0px";
    this.element.style.height = "0px"
    this.element.style.left = (event.pageX - Tagger.absoluteXOffset(this.parentElement))+ "px";
    this.element.style.top = (event.pageY - Tagger.absoluteYOffset(this.parentElement))+ "px";

    this.updateHiddenFields();

    this.isMouseDown = true;
}

Tagger.prototype.mouseMove = function(event) {
    if (!this.isMouseDown) {
        return;
    }

    var newWidth = event.pageX - this.origX;
    var maxWidth = this.parentRightX - this.origX;
    var minWidth = this.parentLeftX - this.origX;
    newWidth = Math.max(newWidth, minWidth);
    newWidth = Math.min(newWidth, maxWidth);

    if (newWidth >= 0){
        this.element.style.left = (this.origX - Tagger.absoluteXOffset(this.parentElement))+ "px";
        this.element.style.width = newWidth + "px";
    }
    else{
        this.element.style.left = (this.origX + newWidth - Tagger.absoluteXOffset(this.parentElement)) + "px";
        this.element.style.width = (-newWidth) + "px";
    }

    var newHeight = event.pageY - this.origY;
    var maxHeight = this.parentBottomY - this.origY;
    var minHeight = this.parentTopY - this.origY;
    newHeight = Math.max(newHeight, minHeight);
    newHeight = Math.min(newHeight, maxHeight);
    if (newHeight >= 0){
        this.element.style.top = (this.origY - Tagger.absoluteYOffset(this.parentElement))+ "px";
        this.element.style.height = newHeight + "px";
    }
    else{
        this.element.style.top = (this.origY + newHeight - Tagger.absoluteYOffset(this.parentElement)) + "px";
        this.element.style.height = (-newHeight) + "px";
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
    this.widthField.value = this.element.offsetWidth;
    this.heightField.value = this.element.offsetHeight;
}






// TODO: name things better
// TODO: fix release mouse outside browser widnow bug
// TODO: make this nonstatic functions

Tagger.absoluteXOffset = function(element) {
    var top = 0, left = 0;
    do {
        top += element.offsetTop  || 0;
        left += element.offsetLeft || 0;
        element = element.offsetParent;
    } while(element);

    return left;
}
Tagger.absoluteYOffset = function(element) {
    var top = 0, left = 0;
    do {
        top += element.offsetTop  || 0;
        left += element.offsetLeft || 0;
        element = element.offsetParent;
    } while(element);

    return top;
}
