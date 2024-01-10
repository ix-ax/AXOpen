export function getWindowSize() {
    return {
        width: window.innerWidth,
        height: window.innerHeight
    };
};

export function getImageSize(imageId) {
    const image = document.getElementById(imageId);

    if (image) {
        return {
            width: image.width,
            height: image.height
        };
    } else {
        return null;
    }
};


export function dragElement(id, dotNetInstance, left, top, imgId, scale) {
    var elmnt = document.getElementById(id);

    if (elmnt != null) {
        var imageSize = getImageSize(imgId);

        elmnt.onmousedown = function (e) {
            dragMouseDown(e, elmnt, left, top, dotNetInstance, imageSize, scale);
        };

        updateTransform(elmnt, left, top, dotNetInstance);
    }
}

function dragMouseDown(e, elmnt, left, top, dotNetInstance, imageSize, scale) {
    e = e || window.event;
    e.preventDefault();

    var startX = e.clientX;
    var startY = e.clientY;

    document.onmouseup = closeDragElement;
    document.onmousemove = function (event) {
        elementDrag(event, elmnt, left, top, startX, startY, dotNetInstance, imageSize, scale);
    };
}

function elementDrag(e, elmnt, left, top, startX, startY, dotNetInstance, imageSize, scale) {
    e = e || window.event;
    e.preventDefault();

    if (imageSize != null && imageSize.width != 0 && imageSize.height != 0) {
        var offsetX = ((startX - e.clientX) / imageSize.width * 100) * (1 / scale);
        var offsetY = ((startY - e.clientY) / imageSize.height * 100) * (1 / scale);

        left = (left - offsetX);
        top = (top - offsetY);
    }

    elmnt.onmousedown = function (e) {
        dragMouseDown(e, elmnt, left, top, dotNetInstance, imageSize, scale);
    };

    updateTransform(elmnt, left, top, dotNetInstance);
}

function closeDragElement() {
    document.onmouseup = null;
    document.onmousemove = null;
}

function updateTransform(elmnt, left, top, dotNetInstance) {
    elmnt.style.left = left + "%";
    elmnt.style.top = top + "%";

    dotNetInstance.invokeMethodAsync('SetDataAsync', left, top);
}