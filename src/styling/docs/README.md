# AXOpen Styling

This package provides the standard styling and UI components for AXOpen applications. It is built on top of [Tailwind CSS v4](https://tailwindcss.com/) and offers a consistent, modern look and feel for your Blazor applications.

## Installation

1.  **Add the NuGet package** to your Blazor project:

    ```xml
    <PackageReference Include="AXOpen.Operon.Blazor" Version="*" />
    ```

2.  **Reference the stylesheet** in your application's host file.

    *   For **Blazor WebAssembly**, add it to `wwwroot/index.html`.
    *   For **Blazor Server** or **Blazor Web App**, add it to `Components/App.razor` (or `Pages/_Host.cshtml` in older versions).

    Add the following lines to the `<head>` section:

    ```html  
    <link href="_content/Inxton.Operon/css/momentum.css" rel="stylesheet" />  (core styles)
    <link href="_content/AXSharp.Presentation.Blazor.Controls/css/momentum.css" rel="stylesheet" /> (if using AXSharp controls)
    <link href="_content/AXOpen.Operon.Blazor/css/momentum.css" rel="stylesheet" />               
    ```

## Usage

Once the stylesheet is referenced, standard HTML elements will automatically receive the AXOpen styling. The package also provides Tailwind CSS utility classes for custom styling.

### Theme Support

The styling supports both light and dark modes. The theme is determined by the `data-theme` attribute on a parent element (usually `<html>` or `<body>`).

```html
<!-- Dark Mode -->
<html data-theme="dark">
...
</html>
```

### CSS Variables

The styling is based on CSS variables, which can be overridden in your application's CSS to customize colors, spacing, and other design tokens.

#### Color Variables

| Variable | Light Mode | Dark Mode | Description |
|----------|------------|-----------|-------------|
| `--color-background` | `#f8fafc` | `#020617` | Main background color |
| `--color-background-light` | `#f1f5f9` | `#0f172a` | Light background variant |
| `--color-background-dark` | `#e2e8f0` | `#1e293b` | Dark background variant |
| `--color-text` | `#0f172a` | `#e2e8f0` | Primary text color |
| `--color-text-light` | `#475569` | `#94a3b8` | Secondary text color |
| `--color-border` | `#64748b` | `#94a3b8` | Border color |
| `--color-primary` | `#0a319e` | `#818cf8` | Primary accent color |
| `--color-success` | `#00703C` | `#00703C` | Success state color |
| `--color-warning` | `#EC9811` | `#EC9811` | Warning state color |
| `--color-danger` | `#f43f5e` | `#f43f5e` | Danger/error state color |
| `--color-info` | `#2B8CC4` | `#2B8CC4` | Info state color |
| `--color-link` | `#0369a1` | `#82cfff` | Link color |
| `--color-link-hover` | `#0c4a6e` | `#e0f2fe` | Link hover color |

#### Radius Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `--radius-small` | `1rem` | Base small radius |
| `--radius-button` | `calc(infinity * 1px)` | Button border radius (fully rounded) |
| `--radius-input` | `var(--radius-small)` | Input field radius |
| `--radius-card` | `var(--radius-small)` | Card border radius |
| `--radius-modal` | `var(--radius-small)` | Modal border radius |
| `--radius-nav` | `var(--radius-small)` | Navigation element radius |

### Customization Example

```css
:root {
    --color-primary: #0056b3; /* Override primary color */
    --radius-button: 0.5rem;  /* Override button radius */
    --radius-small: 0.75rem;  /* Override base radius */
}
```

## Development

### Building the CSS

The styling uses Tailwind CSS v4. To build or watch for changes:

```bash
# Navigate to the src directory
cd src/styling/src

# Install dependencies
npm install

# Build the CSS (minified)
npm run build:css

# Watch for changes during development
npm run watch:css
```

The source Tailwind configuration is in `wwwroot/css/tailwind.css` and the compiled output is `wwwroot/css/momentum.css`.
