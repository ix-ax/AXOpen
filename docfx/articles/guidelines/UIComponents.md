# DRAFT
# UI Component Guidelines

This document provides comprehensive guidelines for creating and using UI components in AXOpen, including sizing conventions, naming standards, and integration with the RenderableContentControl system.

---

## Overview

AXOpen UI components are designed to be:
- **Consistent**: Follow established patterns for sizing, styling, and behavior
- **Reusable**: Work across different contexts with minimal customization
- **Accessible**: Support keyboard navigation, screen readers, and ARIA attributes
- **Responsive**: Adapt gracefully to different screen sizes and orientations

---

## Component Sizing Convention

### Size Variants

The UI components should follow a standardized sizing convention using suffix modifiers. This enables developers to choose the appropriate component size for their specific use case.

| Size Suffix | Description | Typical Use Case | Example Component Name |
|-------------|-------------|------------------|------------------------|
| `XS` | Extra Small | Compact dashboards, dense layouts, inline indicators | `AxoTaskXSView` |
| `SM` | Small | Sidebar controls, compact toolbars, mobile interfaces | `AxoTaskSMView` |
| *(none)* | Standard | Default size for general-purpose use | `AxoTaskView` |
| `LG` | Large | Featured controls, primary actions, touch interfaces | `AxoTaskLGView` |
| `XL` | Extra Large | Kiosk interfaces, operator panels, high-visibility displays | `AxoTaskXLView` |

### Sizing Guidelines

**General Principles:**
- The **standard** size (no suffix) should be the most commonly used variant
- All sizes must provide **identical functionality** - only visual presentation changes
- Maintain **consistent proportions** across size variants (icons, spacing, fonts scale together)
- Ensure **touch-friendly** sizes for `LG` and `XL` variants (minimum 44×44px touch targets)

**Size Relationships:**
```
XS ≈ 60-70% of Standard
SM ≈ 80-85% of Standard
Standard = 100% (baseline)
LG ≈ 130-140% of Standard (reduced from 150% for efficiency)
XL ≈ 180-200% of Standard
```

**Example Scaling (Button Height):**
```
XS:       24px
SM:       32px
Standard: 40px
LG:       52px
XL:       72px
```

---

## Component Naming Convention

### File Structure

Each component size variant should have its own set of files:

```
AxoTask/
├── AxoTaskXSView.razor         # Extra small variant markup
├── AxoTaskXSView.razor.cs      # Extra small variant code-behind
├── AxoTaskXSView.razor.css     # Extra small variant styles
├── AxoTaskSMView.razor         # Small variant markup
├── AxoTaskSMView.razor.cs      # Small variant code-behind
├── AxoTaskSMView.razor.css     # Small variant styles
├── AxoTaskView.razor           # Standard variant markup
├── AxoTaskView.razor.cs        # Standard variant code-behind
├── AxoTaskView.razor.css       # Standard variant styles
├── AxoTaskLGView.razor         # Large variant markup
├── AxoTaskLGView.razor.cs      # Large variant code-behind
├── AxoTaskLGView.razor.css     # Large variant styles
└── AxoTaskXLView.razor         # Extra large variant markup
    AxoTaskXLView.razor.cs      # Extra large variant code-behind
    AxoTaskXLView.razor.css     # Extra large variant styles
```

### Naming Rules

1. **Component Base Name**: Use PascalCase, e.g., `AxoTask`, `AxoSequencer`, `AxoDrive`
2. **Size Suffix**: Append directly before `View`, e.g., `XS`, `SM`, `LG`, `XL`
3. **View Suffix**: Always end with `View` to indicate it's a visual component
4. **Standard Size**: Omit size suffix for the default variant

**Examples:**
- ✅ `AxoTaskView.razor` (standard)
- ✅ `AxoTaskLGView.razor` (large)
- ✅ `AxoSequencerXSView.razor` (extra small)
- ❌ `AxoTaskLargeView.razor` (use `LG` not `Large`)
- ❌ `AxoTaskViewLG.razor` (suffix before `View`, not after)

---

## Component Parameters

### Required Parameters

All component variants should support these standard parameters:

```csharp
[Parameter] public string? Class { get; set; }           // Additional CSS classes
[Parameter] public string? Style { get; set; }           // Inline styles
[Parameter] public bool Disable { get; set; }            // Disable interaction
[Parameter] public string? Label { get; set; }           // Override default label
```

### Size-Specific Parameters

Consider adding parameters to control density or detail level:

```csharp
[Parameter] public bool ShowIcon { get; set; } = true;   // Hide in XS/SM variants
[Parameter] public bool ShowText { get; set; } = true;   // Icon-only mode
[Parameter] public bool Compact { get; set; }            // Reduce padding/spacing
```

---

## CSS Styling Guidelines

### CSS Class Naming

Use BEM (Block Element Modifier) methodology with component-specific prefixes:

```css
/* Block */
.flux-task-lg { }

/* Elements */
.flux-task-lg__button { }
.flux-task-lg__icon { }
.flux-task-lg__label { }
.flux-task-lg__state { }

/* Modifiers */
.flux-task-lg--busy { }
.flux-task-lg--error { }
.flux-task-lg--disabled { }
```

### Scoped Styles

Always use scoped CSS files (`.razor.css`) to avoid style conflicts:

```css
/* AxoTaskLGView.razor.css */
.flux-task-lg__button {
    padding: 0.67rem 1rem;
    font-size: 0.875rem;
    /* ... */
}
```

### Responsive Design

Include breakpoints for mobile/tablet layouts:

```css
@media (max-width: 768px) {
    .flux-task-lg__button {
        min-width: 160px;
        padding: 0.58rem 0.83rem;
    }
}
```

### Theme Support

Support both light and dark themes:

```css
/* Default (dark theme) */
.flux-task-lg__button {
    background: var(--bg-secondary);
    color: var(--text-primary);
}

/* Light theme specific */
:root[data-theme="light"] .flux-task-lg__button {
    background: rgba(255, 255, 255, 0.95);
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}
```

---

## RenderableContentControl Integration

### Presentation Types

AXOpen extends AX# with component-specific presentation types:

| Presentation | Description | Use Case |
|--------------|-------------|----------|
| `Command` | Full interaction enabled | Operator controls, manual mode |
| `Status` | Read-only view | Monitoring displays, dashboards |
| `Command-Control` | Enhanced command view | Service mode, advanced controls |
| `Status-Display` | Enhanced status view | Detailed diagnostics |

### Component Registration

Register your component for automatic rendering:

```csharp
[RenderableContent]
public partial class AxoTaskView : RenderableComplexComponentBase<AxoTask>
{
    // Implementation
}
```

### Size Selection in RenderableContentControl

When using automatic rendering, you can specify the size variant:

```xml
<!-- Standard size (default) -->
<RenderableContentControl Context="@Entry.Plc.Task" Presentation="Command"/>

<!-- Specify size variant -->
<RenderableContentControl Context="@Entry.Plc.Task" 
                         Presentation="CommandLG"/>

<!-- Multiple components with different sizes -->
<RenderableContentControl Context="@Entry.Plc.Tasks" 
                         Presentation="StatusSM"/>
```

### Custom View Selection

For manual component usage, directly reference the size variant:

```xml
<!-- Use standard size -->
<AxoTaskView Component="@Entry.Plc.Task" />

<!-- Use large size -->
<AxoTaskLGView Component="@Entry.Plc.Task" />

<!-- Use extra small size -->
<AxoTaskXSView Component="@Entry.Plc.Task" />
```

---

## Component State Management

### State Indication

Components should visually indicate their state through:

1. **Color** - Using semantic color system
2. **Icons** - State-appropriate glyphs/animations
3. **Animation** - Subtle transitions for state changes
4. **Accessibility** - ARIA attributes and live regions

### State Color Conventions

```css
/* Ready/Idle State */
.state-ready {
    border-color: var(--border-primary);
    color: var(--text-muted);
}

/* Active/Busy State */
.state-busy {
    background: rgba(59, 130, 246, 0.12);
    border-color: rgba(59, 130, 246, 0.4);
    color: var(--color-info);
}

/* Success/Done State */
.state-done {
    border-color: rgba(34, 197, 94, 0.3);
    color: var(--color-success);
}

/* Error State */
.state-error {
    background: rgba(239, 68, 68, 0.05);
    border-color: rgba(239, 68, 68, 0.5);
    color: var(--color-danger);
}

/* Warning State */
.state-warning {
    background: rgba(251, 191, 36, 0.12);
    border-color: rgba(251, 191, 36, 0.4);
    color: var(--color-warning);
}
```

---

## Accessibility Requirements

<!-- ### ARIA Attributes

All interactive components must include:

```xml
<button type="button"
        class="flux-task-lg__button"
        aria-label="@Description"
        aria-busy="@(State is Busy or Kicking)"
        aria-disabled="@IsDisabled"
        data-state="@State.ToString().ToLowerInvariant()">
    <!-- Content -->
</button>
``` -->

### Keyboard Navigation

- Support `Tab` navigation
- Support `Enter` and `Space` for activation
- Support `Escape` for cancellation (where applicable)
- Provide visible focus indicators

<!-- ### Screen Reader Support

```xml
<!-- Visually hidden but accessible text -->
<span class="visually-hidden">Current state: @State</span>

<!-- Live regions for state changes -->
<div aria-live="polite" aria-atomic="true">
    @if (StateChanged) {
        <span>@StateMessage</span>
    }
</div>
``` -->

---

## Animation Guidelines

### Animation Sizing

All animations (spinners, checkmarks, etc.) should scale with component size:

```css
/* Standard size - reference from AxoTaskView */
.task-button__glyph {
    width: 1.35rem;
    height: 1.35rem;
}

/* Large size - maintain same proportions */
.flux-task-lg__glyph {
    width: 1.35rem;  /* Keep animations consistent */
    height: 1.35rem;
}
```

**Important**: Animation elements should maintain consistent size across variants to avoid visual inconsistency. Only the container and text scale.

### Animation Performance

- Use `transform` and `opacity` for animations (GPU accelerated)
- Avoid animating `width`, `height`, `margin`, or `padding`
- Use `will-change` sparingly and only when necessary
- Provide `prefers-reduced-motion` support

```css
@keyframes task-spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}

.glyph-busy span {
    animation: task-spin 0.9s linear infinite;
}

/* Respect user motion preferences */
@media (prefers-reduced-motion: reduce) {
    .glyph-busy span {
        animation: none;
    }
}
```

---

## Best Practices

### DO:
✅ Create all size variants for public components  
✅ Maintain identical functionality across sizes  
✅ Use CSS variables for themeable properties  
✅ Test in both light and dark themes  
✅ Support keyboard and touch interaction  
✅ Include loading and error states  
✅ Document component parameters  
✅ Provide usage examples  

### DON'T:
❌ Mix size suffixes with variant names (`AxoTaskSmallVariantView`)  
❌ Create size-specific functionality differences  
❌ Hardcode colors - use CSS variables  
❌ Forget accessibility attributes  
❌ Omit responsive breakpoints  
❌ Use inline styles in markup  
❌ Create components without code-behind separation  

---

## Example: Creating a New Component

### 1. Define the Standard Size Component

**AxoWidgetView.razor:**
```xml
@namespace AXOpen.Core
@inherits RenderableComplexComponentBase<AxoWidget>

<div class="flux-widget @Class" style="@Style">
    <button type="button"
            class="flux-widget__button @StateCss"
            @onclick="OnClick"
            aria-label="@Description"
            aria-busy="@IsBusy">
        <span class="flux-widget__icon">@Icon</span>
        <span class="flux-widget__label">@Label</span>
    </button>
</div>
```

**AxoWidgetView.razor.cs:**
```csharp
public partial class AxoWidgetView
{
    [Parameter] public string? Class { get; set; }
    [Parameter] public string? Style { get; set; }
    [Parameter] public string? Label { get; set; }
    
    private string StateCss => $"state-{State.ToString().ToLowerInvariant()}";
    private bool IsBusy => State == eWidgetState.Busy;
    
    private void OnClick() => Component.Execute();
}
```

**AxoWidgetView.razor.css:**
```css
.flux-widget__button {
    padding: 0.75rem 1.25rem;
    font-size: 0.875rem;
    border-radius: 0.5rem;
    /* ... */
}
```

### 2. Create Size Variants

**AxoWidgetLGView.razor.css:**
```css
.flux-widget-lg__button {
    padding: 0.67rem 1rem;      /* 89% of standard */
    font-size: 0.875rem;         /* Adjust proportionally */
    /* ... mirror standard structure */
}
```

### 3. Register for Auto-Rendering

```csharp
[RenderableContent("Widget-Command")]
public partial class AxoWidgetView { }

[RenderableContent("Widget-Command-LG")]
public partial class AxoWidgetLGView { }
```

---

## Testing Checklist

Before releasing a component:

- [ ] All size variants render correctly
- [ ] Dark and light themes display properly
- [ ] Responsive breakpoints work on mobile/tablet
- [ ] Keyboard navigation functions
- [ ] Screen readers announce state changes
- [ ] Component integrates with RenderableContentControl
- [ ] Performance is acceptable (no jank, smooth animations)
- [ ] Documentation includes usage examples
- [ ] Code follows established patterns
- [ ] CSS uses scoped stylesheets

---

## Additional Resources

- [AX# Rendering Documentation](https://inxton.github.io/axsharp/articles/blazor/RENDERABLECONTENT.html)
- [Component Attribute Guidelines](./AXOCOMPONENT.md)
- [Layout Organization](../rendering/intro.md)
- [Blazor Component Best Practices](https://learn.microsoft.com/en-us/aspnet/core/blazor/components/)

---

## Questions?

For questions or suggestions about UI component guidelines, please:
- Review existing components for reference patterns
- Consult the AXOpen development team
- Submit improvement proposals via GitHub issues
