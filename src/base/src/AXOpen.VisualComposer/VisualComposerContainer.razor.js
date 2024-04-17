export function showModal(id) {
    console.log("showModal");
    const myModal = new bootstrap.Modal(document.getElementById(id))
    myModal.show()
    console.log("showModal end");
};