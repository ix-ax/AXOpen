
const elementContainer = document.getElementById('zoomAndMoveContainer');
const elementItem = document.getElementById('zoomAndMoveItem');

elementContainer.addEventListener('wheel', zoom);
elementContainer.addEventListener('mousedown', startDrag);
elementContainer.addEventListener('mouseup', stopDrag);
elementContainer.addEventListener('mousemove', drag);
elementContainer.addEventListener('mouseleave', stopDrag);

let isDragging = false;
let startX, startY, offsetX = 0, offsetY = 0;
let scale;
let dotNetComponentInstance;

function zoom(event) {
    if (event.ctrlKey) {
        event.preventDefault();
        scale += event.deltaY * -0.0001;
        scale = Math.min(Math.max(0.5, scale), 2);
        updateTransform();
    }
}

function startDrag(event) {
    if (event.ctrlKey) {
        isDragging = true;
        startX = event.clientX - offsetX;
        startY = event.clientY - offsetY;
    }
}

function stopDrag() {
    isDragging = false;
}

function drag(event) {
    if (event.ctrlKey && isDragging) {
        event.preventDefault();
        offsetX = event.clientX - startX;
        offsetY = event.clientY - startY;
        updateTransform();
    }
}

function updateTransform() {
    elementItem.style.transform = `scale(${scale}) translate(${offsetX}px, ${offsetY}px)`;

    dotNetComponentInstance.invokeMethodAsync('SetDataAsync', scale, offsetX, offsetY);
}

export function setData(dotNetInstance, s, x, y) {
    dotNetComponentInstance = dotNetInstance;
    scale = s;
    offsetX = x;
    offsetY = y;
    updateTransform();
}