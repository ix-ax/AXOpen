using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Dialogs
{

    public interface IsDialogType : ITwinObject
    {
        /// <summary>
        /// Gets or sets dialog locator id.
        /// </summary>
        string DialogId { get; set; }

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
