# DRAFT
# Application Setup Guide for AXOpen and AX#

This guide outlines the necessary steps to set up a Blazor Server application to work with AXOpen and AX# (SIMATIC AX).

## Prerequisites

- .NET 8.0 or later
- SIMATIC AX workbench
- Visual Studio 2022 or VS Code
- MongoDB (for data persistence)

## Project Structure

A typical AXOpen application consists of:
- **PLC Project** (SIMATIC AX) - Contains controller logic
- **Twin Project** - C# twins generated from PLC code
- **Blazor Server Project** - Web UI application

## Required NuGet Packages

Add the following package references to your Blazor Server `.csproj`:

```xml
<ItemGroup>
    <PackageReference Include="AXOpen.Core.Blazor"/>
    <PackageReference Include="AXOpen.Data.Blazor" />
    <PackageReference Include="AXOpen.Data.MongoDb" />
    <PackageReference Include="AXOpen.Security.Blazor" />
    <PackageReference Include="AXOpen.Base.Dialogs" />
    <PackageReference Include="AXOpen.Logging.Serilog" />
</ItemGroup>
```

## Required CSS and JavaScript Assets

### 1. Update `_Host.cshtml` or `App.razor`

Add the following references in your `_Host.cshtml` (Blazor Server) or layout file:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <base href="~/" />

    <!-- Custom site CSS -->
    <link href="css/site.css" rel="stylesheet" />
    
    <!-- AXOpen Fluxion CSS Framework -->
    <link href="_content/AXOpen.Core.Blazor/fluxion/aditive.css" rel="stylesheet" />
    <link href="_content/AXOpen.Core.Blazor/fluxion/utilities.css" rel="stylesheet" />
    <link href="_content/AXOpen.Core.Blazor/fluxion/fluxion.css" rel="stylesheet" />
    
    <!-- Component-specific CSS -->
    <link href="YourApp.styles.css" rel="stylesheet" />
    
    <link rel="icon" type="image/png" href="favicon.png" />
    
    <component type="typeof(HeadOutlet)" render-mode="ServerPrerendered" />
</head>
<body>
    <component type="typeof(App)" render-mode="ServerPrerendered" />

    <div id="components-reconnect-modal"></div>

    <!-- Blazor Server script -->
    <script src="_framework/blazor.server.js"></script>
    
    <!-- Optional: Theme management -->
    <script src="~/js/theme.js"></script>
    <script>themeManager.init();</script>
</body>
</html>
```

### 2. Fluxion CSS Framework

AXOpen uses the **Fluxion** CSS framework for consistent styling across components. The framework is included in the `AXOpen.Core.Blazor` package and consists of three main files:

- **aditive.css** - Base styles and design tokens
- **utilities.css** - Utility classes for spacing, colors, etc.
- **fluxion.css** - Component-specific styles

These files are automatically included in the NuGet package and served via the `_content/AXOpen.Core.Blazor/` path.

### 3. Optional: Bootstrap (if using Bootstrap-based components)

If your application uses Bootstrap-based components:

```html
<!-- Bootstrap CSS -->
<link rel="stylesheet" href="~/css/bootstrap/bootstrap.min.css" />

<!-- Bootstrap JS (at end of body) -->
<script src="~/js/bootstrap.bundle.min.js"></script>
```

## Program.cs Configuration

Configure services in your `Program.cs`:

```csharp
using AXOpen.Base.Dialogs;
using AXOpen.Core;
using AXOpen.Data;
using AXOpen.Data.MongoDb;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;

var builder = WebApplication.CreateBuilder(args);

// Add Blazor Server services
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();

// Configure AXOpen Context
builder.Services.AddScoped<IAxoContext>(sp => Entry.Plc.Context);

// Configure MongoDB Repository
var mongoConnectionString = builder.Configuration.GetConnectionString("MongoDb");
builder.Services.AddSingleton<IRepository>(new MongoDbRepository(
    new MongoDbRepositorySettings<EntityDto>(mongoConnectionString, "DatabaseName", "CollectionName")
));

// Add Alert and Dialog services
builder.Services.AddScoped<IAlertDialogService, AlertDialogService>();

var app = builder.Build();

// Configure HTTP pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();
```

## Static Assets from NuGet Packages

When using AXOpen components, static assets (CSS, JS, images, icons) are automatically included in the NuGet packages. Reference them using the standard Blazor pattern:

```
_content/{PACKAGE_ID}/{PATH_AND_FILE_NAME}
```

**Examples:**

```html
<!-- CSS from AXOpen.Core.Blazor -->
<link href="_content/AXOpen.Core.Blazor/fluxion/fluxion.css" rel="stylesheet" />

<!-- Image from AXOpen.Data.Blazor -->
<img src="_content/AXOpen.Data.Blazor/images/icon.svg" />

<!-- Bootstrap icons from AXOpen package -->
<img src="_content/AXOpen.Data.Blazor/bootstrap-icons-1.8.2/download.svg" />
```

**Important:** Always use the `_content/` prefix. Direct references like `/images/icon.svg` will not work when consuming assets from packages.

For more information, see [Microsoft Documentation on Static Assets in RCLs](https://learn.microsoft.com/en-us/aspnet/core/blazor/components/class-libraries?view=aspnetcore-6.0&tabs=visual-studio#create-an-rcl-with-static-assets-in-the-wwwroot-folder).

## PLC Connection Setup

### 1. Define Entry Point

Create an `Entry.cs` file to manage the PLC connection:

```csharp
using AXOpen.Core;
using AXSharp.Connector;

namespace YourApp
{
    public static class Entry
    {
        private static YourPlcTwinController? _plc;

        public static YourPlcTwinController Plc
        {
            get
            {
                if (_plc == null)
                {
                    // Initialize connector (choose appropriate one)
                    var connector = new WebAPIConnector("http://localhost:5000");
                    // OR for direct S7 connection:
                    // var connector = new S7ConnectorAdapter();
                    
                    _plc = new YourPlcTwinController(connector, "PLC1");
                }
                return _plc;
            }
        }
    }
}
```

### 2. Start Cyclic Updates

In your main component or `App.razor`:

```razor
@code {
    protected override async Task OnInitializedAsync()
    {
        // Start cyclic communication with PLC
        Entry.Plc.Connector.BuildAndStart();
        
        await base.OnInitializedAsync();
    }
}
```

## Component Usage

### Basic Component Rendering

```razor
@page "/components"
@using AXOpen.Core.Blazor

<h3>Components</h3>

<!-- Render AXOpen component -->
<RenderableComponentBase Context="@Entry.Plc.Context.MyComponent" 
                         Presentation="Display" />
```

### Task Management

```razor
@using AXOpen.Core.Blazor

<AxoTaskView Component="@Entry.Plc.Context.MyTask" />
```

### Dialog and Alert Services

```razor
@inject IAlertDialogService AlertService

<button @onclick="ShowAlert">Show Alert</button>

@code {
    private async Task ShowAlert()
    {
        await AlertService.ShowAlertAsync("Information", "Operation completed successfully");
    }
}
```

## Localization

AXOpen supports multiple languages. Configure localization in `Program.cs`:

```csharp
using AXOpen.Core.Blazor.Culture;

builder.Services.AddLocalization(options => options.ResourcesPath = "Resources");
builder.Services.AddScoped<ICultureService, CultureService>();

// Configure supported cultures
var supportedCultures = new[] { "en-US", "de-DE", "sk-SK" };
builder.Services.Configure<RequestLocalizationOptions>(options =>
{
    options.SetDefaultCulture(supportedCultures[0])
           .AddSupportedCultures(supportedCultures)
           .AddSupportedUICultures(supportedCultures);
});
```

## Theme Management (Optional)

AXOpen supports dark/light theme switching. Include the theme manager script:

```html
<script src="~/js/theme.js"></script>
<script>themeManager.init();</script>
```

Create `wwwroot/js/theme.js`:

```javascript
const themeManager = {
    init() {
        const savedTheme = localStorage.getItem('theme') || 'light';
        this.setTheme(savedTheme);
    },
    
    setTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
    },
    
    toggle() {
        const current = document.documentElement.getAttribute('data-theme');
        const newTheme = current === 'dark' ? 'light' : 'dark';
        this.setTheme(newTheme);
    }
};
```

## Common Issues

### CSS Not Loading
- Verify package references in `.csproj`
- Ensure using `_content/{PackageName}/` prefix
- Check browser console for 404 errors
- Clear browser cache and rebuild solution

### PLC Connection Issues
- Verify connector configuration (IP, port)
- Check PLC is running and accessible
- Ensure firewall rules allow connection
- Review connector logs for error messages

### Components Not Rendering
- Verify cyclic updates are started: `Connector.BuildAndStart()`
- Check component context is properly initialized
- Ensure proper using statements in Razor files

## Additional Resources

- [AXOpen Documentation](https://github.com/ix-ax/AXOpen)
- [SIMATIC AX Documentation](https://console.simatic-ax.siemens.io)
- [Blazor Server Documentation](https://learn.microsoft.com/en-us/aspnet/core/blazor/)
- [Static Assets in Razor Class Libraries](https://learn.microsoft.com/en-us/aspnet/core/blazor/components/class-libraries)

## See Also

- [Assets in NuGet Package](Assets_in_nuget_package.md)
- [Themes](Themes.md)
- [Localization](Localization.md)
- [Configuration](Configuration.md)
- [ToolTips and PopOvers](ToolTipsAndPopOvers.md)
