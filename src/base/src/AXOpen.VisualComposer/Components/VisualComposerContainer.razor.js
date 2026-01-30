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

export function downloadFile(fileName, contentType, content) {
    const blob = new Blob([content], { type: contentType });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = fileName;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}