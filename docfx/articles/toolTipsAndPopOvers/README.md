# Utilizing ToolTips and PopOvers

To incorporate ToolTips and PopOvers into your Blazor Server application, you need to initialize these components. You can achieve this by adding a JavaScript file and invoking it within MainLayout.razor, as demonstrated below.

## Adding the JavaScript file

Start by creating a new JavaScript file named 'addToolTipsAndPopOvers.js' within the 'wwwroot/js' folder. In this file, insert the following method:

~~~ JS
export function addToolTipsAndPopOvers() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize popovers
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
}
~~~

## Adding the OnAfterRenderAsync method in MainLayout.razor

In your 'MainLayout.razor', include the 'OnAfterRenderAsync' method, which call the JavaScript function.

~~~ C
@code {
    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        var module = await JSRuntime.InvokeAsync<IJSObjectReference>("import", "/js/addToolTipsAndPopOvers.js");
        await module.InvokeVoidAsync("addToolTipsAndPopOvers");
    }
}
~~~
