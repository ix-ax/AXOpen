# AxoMessengerView Usage Guide

## Overview

The `AxoMessengerView` component provides a rich, expandable alarm/message card UI for displaying messenger information without overwhelming operators. The component now includes a collapsible **Details** section that displays additional technical information only when needed.

## Features

### Always Visible Information
- **Severity** - Color-coded severity indicator (Info, Warning, Minor, Major, Critical)
- **Message Code** - Brief alarm code
- **State** - Current state (Active/Cleared, Acknowledged/Unacknowledged)
- **Title** - Message title
- **Equipment** - Associated equipment name
- **Raised** - Timestamp when alarm was raised
- **Acknowledged** - Acknowledgment status and timestamp
- **Duration** - How long the alarm has been active
- **Acknowledge Button** - Quick action to acknowledge the alarm

### Expandable Details Section (NEW)
The **Details** button in the footer reveals additional technical information:
- **Symbol** - Component symbol from PLC
- **Human Readable** - Human-readable component name
- **Identity (Alarm ID)** - Unique message identifier
- **Additional Custom Details** - Extensible via `AdditionalDetails` parameter

## Basic Usage

```razor
<AxoMessengerView Component="@myMessenger" />
```

## Advanced Usage with Additional Details

You can add custom details to the expandable section using the `AdditionalDetails` parameter:

```razor
<AxoMessengerView Component="@myMessenger">
    <AdditionalDetails>
        <div class="alarm-card__detail-item">
            <dt>Plant Area</dt>
            <dd>@DisplayOrDash(myMessenger.PlantArea)</dd>
        </div>
        <div class="alarm-card__detail-item">
            <dt>Operator Notes</dt>
            <dd>@DisplayOrDash(operatorNotes)</dd>
        </div>
        <div class="alarm-card__detail-item">
            <dt>Maintenance Priority</dt>
            <dd>@maintenancePriority</dd>
        </div>
    </AdditionalDetails>
</AxoMessengerView>

@code {
    private string operatorNotes = "Check valve V-103";
    private string maintenancePriority = "High";
    
    private static string DisplayOrDash(string? value) => 
        string.IsNullOrWhiteSpace(value) ? "—" : value;
}
```

## Custom Actions

Add custom action buttons using the `Actions` parameter:

```razor
<AxoMessengerView Component="@myMessenger">
    <Actions>
        <button class="btn-custom" @onclick="OpenDetailedLog">
            View Log
        </button>
        <button class="btn-custom" @onclick="SendToMaintenance">
            Send to Maintenance
        </button>
    </Actions>
</AxoMessengerView>
```

## Styling

The component uses CSS custom properties (CSS variables) for theming and automatically adapts to light/dark themes. You can override styles by targeting the CSS classes:

- `.alarm-card` - Main card container
- `.alarm-card__details` - Expandable details section
- `.alarm-card__details-toggle` - Details button
- `.alarm-card__expand-icon` - Arrow icon
- `.alarm-card__detail-item` - Individual detail item

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `Component` | `AxoMessenger` | The messenger component to display (inherited) |
| `Actions` | `RenderFragment?` | Custom action buttons |
| `AdditionalDetails` | `RenderFragment?` | Additional details to show in expandable section |
| `AcknowledgeLabel` | `string?` | Custom label for acknowledge button |
| `AcknowledgeRequested` | `EventCallback` | Callback when acknowledge is requested |
| `Class` | `string?` | Additional CSS classes |
| `Style` | `string?` | Inline styles |

## Example with All Features

```razor
<AxoMessengerView 
    Component="@alarm" 
    AcknowledgeLabel="ACK"
    Class="custom-alarm-class"
    Style="margin-bottom: 1rem;">
    
    <Actions>
        <button @onclick="() => NavigateToEquipment(alarm)">
            Go to Equipment
        </button>
    </Actions>
    
    <AdditionalDetails>
        <div class="alarm-card__detail-item">
            <dt>Line Number</dt>
            <dd>@alarm.LineNumber</dd>
        </div>
        <div class="alarm-card__detail-item">
            <dt>Last Maintenance</dt>
            <dd>@FormatDate(alarm.LastMaintenance)</dd>
        </div>
    </AdditionalDetails>
</AxoMessengerView>
```

## Design Philosophy

The expandable details approach ensures:
1. **Clean Initial View** - Operators see only critical information at a glance
2. **Progressive Disclosure** - Technical details available when needed
3. **Reduced Cognitive Load** - Information hierarchy prevents overwhelm
4. **Accessibility** - Proper ARIA attributes and keyboard navigation
5. **Extensibility** - Easy to add custom details without modifying component code

## Best Practices

1. **Keep Primary Info Minimal** - Only show what operators need for immediate response
2. **Use Details for Technical Info** - Symbol, IDs, and diagnostic data go in details
3. **Add Context Gradually** - Use `AdditionalDetails` to provide context without clutter
4. **Consistent Formatting** - Use the helper method `DisplayOrDash()` for null values
5. **Responsive Design** - The component automatically adapts to mobile screens
