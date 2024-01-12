// axopen_core_blazor
// Copyright (c)2024 Peter Kurhajec and Contributors All Rights Reserved.
// Contributors: https://github.com/PTKu/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/PTKu/ix/blob/master/LICENSE
// Third party licenses: https://github.com/PTKu/ix/blob/master/notices.md

using System.Collections;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Messaging.Static.Blazor;

/// <summary>
/// Represents an observer for AxoMessageProvider that serves a Blazor component.
/// </summary>
public class AxoMessageObserver
{
    private AxoMessageObserver(IEnumerable<ITwinObject> observedObjects, RenderableComponentBase component)
    {
        Provider = AxoMessageProvider.Create(observedObjects);
        Component = component;
    }

    private AxoMessageObserver(AxoMessageProvider provider, RenderableComponentBase component)
    {
        Provider = provider;
        Component = component;
    }
    
    private RenderableComponentBase Component { get; }
    
    /// <summary>
    /// Get message provider for this adapter.
    /// </summary>
    public AxoMessageProvider? Provider { get; }
    
    /// <summary>
    /// Creates new <see cref="AxoMessageObserver"/> for a blazor component.
    /// </summary>
    /// <param name="observedObjects">Observed objects</param>
    /// <param name="component">Blazor component instance that will be served by this adapter.</param>
    /// <returns></returns>
    public static AxoMessageObserver Create(IEnumerable<ITwinObject> observedObjects, RenderableComponentBase component)
    {
        return new AxoMessageObserver(observedObjects, component);
    }
    
    /// <summary>
    /// Creates an instance of the AxoMessageObserver class.
    /// </summary>
    /// <param name="provider">The AxoMessageProvider object to observe.</param>
    /// <param name="component">The RenderableComponentBase object that the observer will render.</param>
    /// <returns>An instance of the AxoMessageObserver class.</returns>
    public static AxoMessageObserver Create(AxoMessageProvider provider, RenderableComponentBase component)
    {
        return new AxoMessageObserver(provider, component);
    }

    public string HighestSeverityColor
    {
        get
        {
            try
            {
                return SeverityToColor(Provider?.Messengers?
                    .Where(p => (eAxoMessengerState)p.MessengerState.LastValue > eAxoMessengerState.Idle)
                    .Select(p => p.Category.LastValue).Max());
            }
            catch (Exception e)
            {
                return "secondary";
            }
        }
    }
    
    private string SeverityToColor(short? severity)
    {
        var highestSeverity = (eAxoMessageCategory)severity;
        
        switch (highestSeverity)
        {
            case eAxoMessageCategory.Trace:
            case eAxoMessageCategory.Debug:
            case eAxoMessageCategory.Info:
                return "info";

            case eAxoMessageCategory.TimedOut: 
            case eAxoMessageCategory.Notification:
            case eAxoMessageCategory.Warning:
                return "warning";
                
            case eAxoMessageCategory.Error: 
            case eAxoMessageCategory.ProgrammingError:
                return "danger";
            
            case eAxoMessageCategory.Critical:
            case eAxoMessageCategory.Fatal:
            case eAxoMessageCategory.Catastrophic:
                return "danger";
                
            case eAxoMessageCategory.All:
            case eAxoMessageCategory.None:
            default:
                return "secondary";
        }
    }
    
    /// <summary>
    /// Initializes the update process by adding messengers to polling and updating the values.
    /// </summary>
    /// <returns>A Task representing the asynchronous operation.</returns>
    public async Task InitializeUpdate()
    {
        await Task.Run(() => {
            foreach (var axoMessenger in this.Provider?.Messengers?
                         .SelectMany(p => new ITwinElement[] { p.MessengerState, 
                                                                           p.Category, 
                                                                           p.MessageCode,
                                                                           p.AcknowledgedBeforeFallen
                         })!)
            {
                Component.UpdateValuesOnChange(axoMessenger, 2500);
            }
        });
    }
    
}