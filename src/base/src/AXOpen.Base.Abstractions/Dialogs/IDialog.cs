using AXSharp.Connector;
using System;

namespace AXOpen.Base.Dialogs
{

    public interface IDialog : ITwinObject
    {
        /// <summary>
        /// Gets or sets dialog locator id.
        /// </summary>
        string DialogLocatorId { get; set; }

        /// <summary>
        /// Initialized remote task for this dialog, with polling instead of cyclic subscription.
        /// </summary>
        /// <param name="dialogAction">Action that will be performed on remove call.</param>
        void Initialize(Action dialogAction);

        /// <summary>
        /// Removes handling of this dialogue, unsubscribing from polling and removed all event handler.
        /// </summary>
        void DeInitialize();
    }
}
