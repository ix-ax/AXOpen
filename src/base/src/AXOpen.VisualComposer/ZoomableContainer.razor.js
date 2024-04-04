
const elementContainer = document.getElementById('zoomAndMoveContainer');
const elementItem = document.getElementById('zoomAndMoveItem');

console.log('ZoomableContainer.razor.js loaded');
enableZooming()

let isDragging = false;
let startX, startY, left = 0, top = 0;
let scale;
let dotNetComponentInstance;

export function disableZooming() {
    console.log('disableZooming');
    elementContainer.removeEventListener('wheel', zoom);
    elementContainer.removeEventListener('mousedown', startDrag);
    elementContainer.removeEventListener('mouseup', stopDrag);
    elementContainer.removeEventListener('mousemove', drag);
    elementContainer.removeEventListener('mouseleave', stopDrag);
}

export function enableZooming() {
    console.log('enableZooming');
    elementContainer.addEventListener('wheel', zoom);
    elementContainer.addEventListener('mousedown', startDrag);
    elementContainer.addEventListener('mouseup', stopDrag);
    elementContainer.addEventListener('mousemove', drag);
    elementContainer.addEventListener('mouseleave', stopDrag);
}

function zoom(event) {
    if (event.ctrlKey) {
        console.log('zoom');
        event.preventDefault();
        scale += event.deltaY * -0.0001;
        scale = Math.min(Math.max(0.5, scale), 2);
        updateTransform();
    }
}

function startDrag(event) {
    if (event.ctrlKey) {
        isDragging = true;
        startX = event.clientX - left;
        startY = event.clientY - top;
    }
}

function stopDrag() {
    isDragging = false;
}

function drag(event) {
    if (event.ctrlKey && isDragging) {
        event.preventDefault();

        left = event.clientX - startX;
        top = event.clientY - startY;

        updateTransform();
    }
}

function updateTransform() {
    console.log('updateTransform', scale, left, top);
    elementItem.style.transform = `scale(${scale}) translate(${left}px, ${top}px)`;

    dotNetComponentInstance.invokeMethodAsync('SetDataAsync', scale, left, top);
}

export function setData(dotNetInstance, s, x, y) {
    console.log('setData', s, x, y);
    dotNetComponentInstance = dotNetInstance;
    scale = s;
    left = x;
    top = y;
    updateTransform();
}