using AXOpen.Core;
using AXOpen.Core.Blazor.AxoDialogs;
using AXOpen.Logging;
using AXSharp.Connector;
using Pocos.AXOpen.Inspectors;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Inspectors
{
    public partial class AxoInspectorDialogDialogView : AxoDialogBaseView<AxoInspectorDialog>, IDisposable
    {

        public bool RetryDisabled { get; set; } = false;

        protected override void OnAfterRender(bool firstRender)
        {
            _inspector = null;
            try
            {
                // _inspectorIndentity property is subscribed in the method base.AddToPolling()
                var parent = Component.GetConnector().IdentityProvider.GetTwinByIdentity(Component._inspectorIndentity.Cyclic);

                if (parent != null)
                {
                    if (parent is AxoInspector i)
                    {
                        _inspector = i;
                    }
                }
            }
            catch (Exception)
            {
            }

            if (base.Component._isOverInspected.Cyclic)
                RetryDisabled = true;
        }

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            base.AddToPolling(element, pollingInterval);
            
        }

        public async Task Retry()
        {
            if (base.Component != null && !base.Component._isOverInspected.Cyclic)
            {
                RetryDisabled = false;
                base.Component._dialogueRetry.Edit = true;
                await base.CloseDialogsWithSignalR();
                var identity = (await _asp.GetAuthenticationStateAsync()).User.Identity;
                AxoApplication.Current.Logger.Information($"{nameof(Retry)} of {Component.HumanReadable} was executed.", identity);
            }
            else
            {
                RetryDisabled = true;
            }

        }
        public async Task Terminate()
        {
            base.Component._dialogueTerminate.Edit = true;
            await base.CloseDialogsWithSignalR();
            var identity = (await _asp.GetAuthenticationStateAsync()).User.Identity;
            AxoApplication.Current.Logger.Information($"{nameof(Terminate)} of {Component.HumanReadable} was executed.", identity);
        }
        public async Task Override()
        {
            base.Component._dialogueOverride.Edit = true;
            await base.CloseDialogsWithSignalR();
            var identity = (await _asp.GetAuthenticationStateAsync()).User.Identity;
            AxoApplication.Current.Logger.Information($"{nameof(Override)} of {Component.HumanReadable} was executed.", identity);
        }


        public string Description
        {
            get => string.IsNullOrEmpty(base.Component.AttributeName) ? base.Component.GetSymbolTail() : base.Component.AttributeName;

        }

        private ITwinObject _inspector;
        public ITwinObject Inspector
        {
            get
            {

                return _inspector;
            }

        }

        public override void Dispose()
        {
            base.Dispose();
        }

    }

}
