export function showModal(id) {
    const myModal = new bootstrap.Modal(document.getElementById(id))
    myModal.show()
};

export function getImageDimensions(filePath) {
    return new Promise((resolve, reject) => {
            // Create a new image element
            const img = new Image();

            // Set the source of the image to the provided file path
            img.src = filePath;

            // When the image is loaded, resolve the promise with its dimensions
            img.onload = function() {
                resolve({
                    width: img.width,
                    height: img.height
                });
            };

            // If there's an error loading the image, reject the promise
            img.onerror = function() {
                reject('Error loading image');
            };
        });
}