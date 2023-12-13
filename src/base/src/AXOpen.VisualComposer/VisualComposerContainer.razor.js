
let scale = 1;
const el = document.getElementById('zoomAndMoveContainer');
el.onwheel = zoom;


function zoom(event) {
    event.preventDefault();

    scale += event.deltaY * -0.0001;

    // Restrict scale
    scale = Math.min(Math.max(0.5, scale), 2);

    // Apply scale transform
    updateTransform();
}



el.onmousedown = startDrag;
el.onmouseup = stopDrag;
el.onmousemove = drag;

let isDragging = false;
let startX, startY, offsetX = 0, offsetY = 0;

function startDrag(event) {
    isDragging = true;
    startX = event.clientX - offsetX;
    startY = event.clientY - offsetY;
}

function stopDrag(event) {
    isDragging = false;
}

function drag(event) {
    if (isDragging) {
        event.preventDefault();
        offsetX = event.clientX - startX;
        offsetY = event.clientY - startY;
        updateTransform();
    }
}



function updateTransform() {
    el.style.transform = `scale(${scale}) translate(${offsetX}px, ${offsetY}px)`;
}