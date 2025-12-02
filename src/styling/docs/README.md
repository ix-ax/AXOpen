# AXOpen Styling

This package provides the standard styling and UI components for AXOpen applications. It is built on top of [Tailwind CSS](https://tailwindcss.com/) and offers a consistent, modern look and feel for your Blazor applications.

## Installation

1.  **Add the NuGet package** to your Blazor project:

    ```xml
    <PackageReference Include="AXOpen.Operon.Blazor" Version="*" />
    ```

2.  **Reference the stylesheet** in your application's host file.

    *   For **Blazor WebAssembly**, add it to `wwwroot/index.html`.
    *   For **Blazor Server** or **Blazor Web App**, add it to `Components/App.razor` (or `Pages/_Host.cshtml` in older versions).

    Add the following line to the `<head>` section:

    ```html
    <link href="_content/AXOpen.Operon.Blazor/css/axopenstyling.css" rel="stylesheet" />
    ```

## Usage

Once the stylesheet is referenced, standard HTML elements will automatically receive the AXOpen styling. The package also provides a set of utility classes and component styles.

### Base Styling

Standard HTML elements like headings (`h1`-`h6`), paragraphs (`p`), links (`a`), and inputs are automatically styled to match the AXOpen design system.

### Components

The library includes styles for common UI components. You can apply these styles using standard CSS classes.

*   **Buttons**: `.btn`, `.btn-primary`, `.btn-outline-primary`, `.btn-sm`, `.btn-lg`, etc.
*   **Badges**: `.badge`, `.badge-primary`, `.badge-success`, etc.
*   **Cards**: `.card`, `.card-title`, `.card-body`, `.card-footer`.
*   **Alerts**: `.alert`, `.alert-primary`, `.alert-danger`, etc.
*   **Forms**: `.input-group`, `.checkbox-group`, `.radio-group`, `.select-group`.
*   **Navigation**: `.nav`, `.nav-item`, `.breadcrumb`.
*   **Modals**: `.modal`, `.modal-header`, `.modal-body`, `.modal-footer`.
*   **Tables**: `.table`, `.table-striped`, `.table-hover`.

### Theme Support

The styling supports both light and dark modes. The theme is determined by the `data-theme` attribute on a parent element (usually `<html>` or `<body>`).

```html
<!-- Dark Mode -->
<html data-theme="dark">
...
</html>
```

### Customization

The styling is based on CSS variables, which can be overridden in your application's CSS to customize colors, spacing, and other design tokens.

```css
:root {
    --color-primary: #0056b3; /* Override primary color */
    --radius-button: 0.5rem;  /* Override button radius */
}
```
