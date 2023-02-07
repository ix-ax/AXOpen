const toastContainer = document.getElementsByClassName('toast-container')[0]

export function addToast(type, header, description) {
    const toastDiv = document.createElement('div');
    toastDiv.className = "toast show";
    toastDiv.setAttribute("role", "alert");
    toastDiv.setAttribute("aria-live", "assertive");
    toastDiv.setAttribute("aria-atomic", "true");
    switch (type) {
        case "info":
            toastDiv.innerHTML = [
                '<div class="toast-header">',
                    '<strong class="me-auto">', header, '</strong>',
                    '<small class="text-muted">just now</small>',
                    '<button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>',
                '</div>',
                '<div class="toast-body">', description, '</div>',
            ].join('');
    }

    toastContainer.append(toastDiv);

    //hide(id);
}