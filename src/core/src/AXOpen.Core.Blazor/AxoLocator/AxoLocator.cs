using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoDialogs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Core.Blazor.AxoAlertDialog;
using static System.Runtime.InteropServices.JavaScript.JSType;
using Serilog;

namespace AXOpen.Core.Blazor.Dialogs
{
    public abstract class AxoLocator : ComponentBase, IDisposable
    {
        [Inject]
        public NavigationManager NavigationManager { get; set; }

        [Inject]
        public IAlertService AlertDialogService { get; set; }

        [Inject]
        public AxoDialogAndAlertContainer DialogContainer { get; set; }

        [Parameter, EditorRequired]
        public IEnumerable<ITwinObject> ObservedObjects { get; set; }

        /// <summary>
        /// A unique identifier for the dialog locator, typically based on the URL of the page.
        /// This ensures dialogues are synchronized across different instances.
        /// </summary>
        [Parameter, EditorRequired]
        public string LocatorPath { get; set; }

        /// <summary>
        /// A unique GUID for the alert dialog locator instance, used for internal management and event subscription.
        /// </summary>
        public Guid LocatorGuid { get; private set; } = Guid.NewGuid();

        protected override void OnInitialized()
        {
            ChecLoacatorPath();
        }

        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                await InitializeObservationHandling();
            }
        }

        protected void ChecLoacatorPath()
        {
            if (string.IsNullOrEmpty(LocatorPath))
            {
                LocatorPath = NavigationManager.Uri;
            }
        }

        protected abstract Task InitializeObservationHandling();

        public abstract void Dispose();
    }
}