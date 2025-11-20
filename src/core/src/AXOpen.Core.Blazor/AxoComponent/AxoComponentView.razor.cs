using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using AXOpen.Core;
using AXSharp.Connector.ValueTypes;
using Microsoft.AspNetCore.Components;
using Pocos.AXOpen.Core;
using Serilog;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using System.Collections.Generic;
using AXOpen.ToolBox.Extensions;
using Polly;
using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Claims;
using System.Security.Principal;
using System.Linq;

namespace AXOpen.Core
{
    public partial class AxoComponentView : RenderableComplexComponentBase<AxoComponent>
    {
        [Inject]
        private AuthenticationStateProvider? AuthenticationStateProvider { get; set; }

        [Parameter]
        public bool IsControllable { get; set; }

        [Parameter]
        public bool HideHeader { get; set; }

        private string _currentPresentation = "Status-Display";
        private bool _containsHeaderAttribute { get; set; } = false;
        private bool _containsDetailsAttribute { get; set; } = false;
        private IEnumerable<string> _tabNames { get; set; } = new List<string>();
        private IEnumerable<ClaimsIdentity> _identities { get; set; }

        private IEnumerable<AxoMessenger>? _messengers => this.Component?.GetChildren().Flatten(p => p.GetChildren()).OfType<AxoMessenger>();

        private eAlarmLevel _alarmLevel
        {
            get
            {
                var _messengers = this._messengers?.ToList();
                if (_messengers == null) { return eAlarmLevel.NoAlarms; }

                if (_messengers.Any(p => p.State > eAxoMessengerState.Idle))
                {
                    var seriousness = (eAxoMessageCategory)_messengers.Max(p => p.Category.LastValue);

                    switch (seriousness)
                    {
                        case eAxoMessageCategory.Info:
                            return eAlarmLevel.ActiveInfo;
                        case eAxoMessageCategory.Warning:
                            return eAlarmLevel.ActiveWarnings;
                        case eAxoMessageCategory.Error:
                        case eAxoMessageCategory.ProgrammingError:
                        case eAxoMessageCategory.Critical:
                            return eAlarmLevel.ActiveErrors;
                        default:
                            break;
                    }
                }
                else if (_messengers.Any(p => p.State > eAxoMessengerState.InactiveWaitingForAcknowledge))
                {
                    return eAlarmLevel.Unacknowledged;
                }

                return eAlarmLevel.NoAlarms;
            }
        }

        private ITwinObject _header;
        private ITwinObject Header
        {
            get
            {
                return _header = _header ?? new ComponentGroupContext(this.Component,
                    this.Component.GetKids().Where(p => p.GetAttribute<ComponentHeaderAttribute>() != null)
                        .ToList());
            }
        }

        private IEnumerable<ITwinObject> _detailsTabs { get; set; }
        private IEnumerable<ITwinObject> DetailsTabs
        {
            get { return _detailsTabs = _detailsTabs ?? CreateDetailsTabs(); }
        }

        private AxoMessageProvider? _messageProvider { get; set; }
        private bool _showAlarms { get; set; } = false;
        private int _previousAlarmCount { get; set; } = 0;

        private int _alarmCount => _messageProvider?.Messengers.Count(a => a.State != eAxoMessengerState.Idle) ?? 0;

        private bool _hasCriticalAlarms => this._alarmLevel == eAlarmLevel.ActiveErrors;

        protected override void OnInitialized()
        {
            base.OnInitialized();
            _containsHeaderAttribute = this.Header.GetKids().Count() != 0;
            _tabNames = GetAllTabNames(this.Component);
            _containsDetailsAttribute = this.DetailsTabs.Count() != 0;
            this._messageProvider = AxoMessageProvider.Create(new ITwinObject[] { this.Component });
        }

        protected override async Task OnInitializedAsync()
        {
            var messengers = _messengers?.SelectMany(p => new ITwinPrimitive[] { p.Category, p.MessengerState, p.MessageCode });
            var connector = _messengers?.FirstOrDefault()?.GetConnector();
            if (connector != null)
            {
                await connector?.ReadBatchAsync(messengers);
            }
            _identities = await GetClaimsIdentitiesAsync();
            await base.OnInitializedAsync();
        }

        protected override void OnAfterRender(bool firstRender)
        {
            base.OnAfterRender(firstRender);

            // Auto-collapse alarm panel when all alarms are cleared
            if (_previousAlarmCount > 0 && _alarmCount == 0 && _showAlarms)
            {
                _showAlarms = false;
                StateHasChanged();
            }

            _previousAlarmCount = _alarmCount;
        }

        private async Task<IEnumerable<ClaimsIdentity>?> GetClaimsIdentitiesAsync()
        {
            var authenticationState = await AuthenticationStateProvider.GetAuthenticationStateAsync();
            return authenticationState?.User?.Identities;
        }

        private IEnumerable<string> GetAllTabNames(ITwinObject twinObject)
        {
            return twinObject.GetKids().Where(p => p.GetAttribute<ComponentDetailsAttribute>() != null)
                .Select(p => p.GetAttribute<ComponentDetailsAttribute>().TabName)
                .Distinct()
                .Where(p => !string.IsNullOrEmpty(p));
        }

        private IEnumerable<ITwinElement> GetAllKidsWithComponentDetailsAttribute(ITwinObject twinObject)
        {
            return twinObject.GetKids().Where(p => p.GetAttribute<ComponentDetailsAttribute>() != null);
        }

        private IEnumerable<ITwinObject> CreateDetailsTabs()
        {
            IList<ITwinObject> _detailsTabs = new List<ITwinObject>();

            foreach (string tabName in _tabNames)
            {
                List<ITwinElement> currentTabElements = this.Component.GetKids()
                .Where(p =>
                {
                    var tabNameAttr = p.GetAttribute<ComponentDetailsAttribute>();
                    var displayRoleAttr = p.GetAttribute<DisplayRoleAttribute>();
                    string displayRoleName = displayRoleAttr == null ? "" : displayRoleAttr.RoleName == null ? "" : displayRoleAttr.RoleName;
                    bool isToBeDisplayed = String.IsNullOrEmpty(displayRoleName) || DisplayByTheRole(displayRoleName);
                    return tabNameAttr != null && !string.IsNullOrEmpty(tabNameAttr.TabName) && tabNameAttr.TabName.Equals(tabName) && isToBeDisplayed;
                }).ToList();

                ITwinObject _detailsTab = new ComponentGroupContext(this.Component, currentTabElements, tabName);
                _detailsTabs.Add(_detailsTab);
            }

            List<ITwinElement> notNamedTabElements = this.Component.GetKids()
                .Where(p => p.GetAttribute<ComponentDetailsAttribute>() != null
                            && string.IsNullOrEmpty(p.GetAttribute<ComponentDetailsAttribute>().TabName)).ToList();

            if (notNamedTabElements.Count() > 0)
            {
                ITwinObject _notNamedTab = new ComponentGroupContext(this.Component, notNamedTabElements, "Tab name not defined");
                _detailsTabs.Add(_notNamedTab);
            }

            return _detailsTabs;
        }

        private bool DisplayByTheRole(string role)
        {
            if (_identities != null && role != null)
            {
                List<ClaimsIdentity> identities = _identities.ToList();

                for (int i = 0; i < identities.Count; i++)
                {
                    if (identities[i] != null)
                    {
                        if (identities[i].HasClaim(identities[i].RoleClaimType, role))
                        {
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        public override void OnComponentChanged()
        {
            _header = null;
            _detailsTabs = null;
            this.StopPolling();
            this.OnInitialized();
        }

        public override void ConfigurePolling()
        {
            if (this.Component is AxoComponent axoComponent)
            {
                this.StartPolling(axoComponent._isManuallyControllable);
            }

            _messengers?.Select(p => p.MessengerState).ToList().ForEach(messenger =>
            {
                this.StartPolling(messenger, 1500);
            });
        }
    }

    public enum eAlarmLevel
    {
        NoAlarms,
        Unacknowledged,
        ActiveInfo,
        ActiveWarnings,
        ActiveErrors
    }

    public class AxoComponentCommandView : AxoComponentView
    {
        public AxoComponentCommandView()
        {
            IsControllable = true;
        }
    }

    public class AxoComponentStatusView : AxoComponentView
    {
        public AxoComponentStatusView()
        {
            IsControllable = false;
        }
    }
}