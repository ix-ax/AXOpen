export function getWindowSize() {
    return {
        width: window.innerWidth,
        height: window.innerHeight
    };
};

export function getElementSize(id) {
    const element = document.getElementById(id);

    if (element) {

        if (element.width && element.height) {
            return {
                width: element.width,
                height: element.height
            };
        }
        else {
            var computedStyle = window.getComputedStyle(element);

            var width = parseFloat(computedStyle.width);
            var height = parseFloat(computedStyle.height);

            return {
                width: width,
                height: height
            };
        }
        
    } else {
        return null;
    }
};

export function dragElement(id, dotNetInstance, left, top, backgroundId, scale) {
    var elmnt = document.getElementById(id);

    if (elmnt != null) {
        var backgroundSize = getElementSize(backgroundId);

        elmnt.onmousedown = function (e) {
            dragMouseDown(e, elmnt, left, top, dotNetInstance, backgroundSize, scale);
        };

        updateTransform(elmnt, left, top, dotNetInstance);
    }
}

function dragMouseDown(e, elmnt, left, top, dotNetInstance, backgroundSize, scale) {
    e = e || window.event;
    e.preventDefault();

    var startX = e.clientX;
    var startY = e.clientY;

    document.onmouseup = closeDragElement;
    document.onmousemove = function (event) {
        elementDrag(event, elmnt, left, top, startX, startY, dotNetInstance, backgroundSize, scale);
    };
}

function elementDrag(e, elmnt, left, top, startX, startY, dotNetInstance, backgroundSize, scale) {
    e = e || window.event;
    e.preventDefault();

    if (backgroundSize != null && backgroundSize.width != 0 && backgroundSize.height != 0) {
        var offsetX = ((startX - e.clientX) / backgroundSize.width * 100) * (1 / scale);
        var offsetY = ((startY - e.clientY) / backgroundSize.height * 100) * (1 / scale);

        left = (left - offsetX);
        top = (top - offsetY);
    }

    elmnt.onmousedown = function (e) {
        dragMouseDown(e, elmnt, left, top, dotNetInstance, backgroundSize, scale);
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