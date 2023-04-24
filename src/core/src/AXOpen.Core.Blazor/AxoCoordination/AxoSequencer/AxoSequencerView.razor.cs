using System.ComponentModel;
using System.Runtime.CompilerServices;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoSequencerView : IDisposable, INotifyPropertyChanged
    {
        private bool _hasStepDetails = true;
        public IEnumerable<AxoStep?> Steps => Component.GetKids().OfType<AxoStep>();

        [Parameter]
        public bool IsControllable { get; set; }

        [Parameter] public bool HasTaskControlButton { get; set; } = true;

        [Parameter] public bool HasSettings { get; set; } = true;

        [Parameter] public bool HasStepControls { get; set; } = true;

        [Parameter]
        public bool HasStepDetails
        {
            get => _hasStepDetails;
            set
            {
                if (value == _hasStepDetails) return;
                _hasStepDetails = value;
                OnPropertyChanged();
            }
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            this.Component.Status.PropertyChanged += (sender, args) => InvokeAsync(StateHasChanged);
            UpdateValuesOnChange(Component);
        }

        public void Dispose()
        {
          
            Component.StopPolling();
        }

        public event PropertyChangedEventHandler? PropertyChanged;

        protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
            this.StateHasChanged();
        }

        protected bool SetField<T>(ref T field, T value, [CallerMemberName] string? propertyName = null)
        {
            if (EqualityComparer<T>.Default.Equals(field, value)) return false;
            field = value;
            OnPropertyChanged(propertyName);
            return true;
        }
    }
}
