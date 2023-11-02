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