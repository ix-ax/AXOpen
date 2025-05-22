export function getImageDimensions(filePath) {
    return new Promise((resolve, reject) => {
        // Create a new image element
        const img = new Image();

        // Set the source of the image to the provided file path
        img.src = filePath;

        // When the image is loaded, resolve the promise with its dimensions
        img.onload = function () {
            resolve({
                width: img.width,
                height: img.height
            });
        };

        // If there's an error loading the image, reject the promise
        img.onerror = function () {
            reject('Error loading image');
        };
    });
}

export function getWindowSize() {
    return {
        width: window.innerWidth,
        height: window.innerHeight
    };
};

export function getElementSize(id) {
    const element = document.getElementById(id);
    if (element) {
        const parent = element.parentElement;

        if (parent.width && parent.height) {
            return ({
                width: parent.width,
                height: parent.height
            });
        } else {
            var computedStyle = window.getComputedStyle(parent);
            return ({
                width: parseFloat(computedStyle.width),
                height: parseFloat(computedStyle.height)
            });
        }
    } else {
        new Error("Element not found");
    }
};

export function registerViewportChangeCallback(dotnetHelper, methodName, id) {
    window.addEventListener('load', () => {
        dotnetHelper.invokeMethodAsync(methodName, getWindowSize(), getElementSize(id));
    });
    window.addEventListener('resize', () => {
        dotnetHelper.invokeMethodAsync(methodName, getWindowSize(), getElementSize(id));
    });
}