// axopen_core_blazor
// Copyright (c)2024 Peter Kurhajec and Contributors All Rights Reserved.
// Contributors: https://github.com/PTKu/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/PTKu/ix/blob/master/LICENSE
// Third party licenses: https://github.com/PTKu/ix/blob/master/notices.md

using System.Collections;
using AXSharp.Connector;
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
    /// Initializes the update process by adding messengers to polling and updating the values.
    /// </summary>
    /// <returns>A Task representing the asynchronous operation.</returns>
    public async Task InitializeUpdate()
    {
        await Task.Run(() => {
            foreach (var axoMessenger in this.Provider?.Messengers?.SelectMany(p => new ITwinElement[] { p.MessengerState })!)
            {
                Component.AddToPolling(axoMessenger, 2500);
                Component.UpdateValuesOnChange(axoMessenger);
            }
        });
    }
}