using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Text;
using System.Reflection;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoBoolArrayView : RenderableComplexComponentBase<AxoBoolArray>, IDisposable
    {
        private bool initialized;
        private int length;
        private OnlinerBool[] _data;

        [Parameter]
        public bool IsControllable { get; set; }
        public bool IsDisabled { get; set; }

        public IndexedData<bool>[] Data { get; private set; } 
        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            
        }

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            base.OnInitialized();
            UpdateData(null, null);
            Component.DataChanged.Subscribe(UpdateData);
        }

        private async void UpdateData(ITwinPrimitive sender, ValueChangedEventArgs args)
        {
            try
            {
                if (!initialized)
                {
                    if (Component != null && Component.GetType() != null && Component.GetType().GetProperty("Data") != null)
                    {
                        Type type = Component.GetType().GetProperty("Data").GetValue(Component).GetType();
                        if (type != null && type.IsArray && type.Name != null && type.Name.ToString().Equals("OnlinerBool[]"))
                        {
                            OnlinerBool[] _data = Component.GetType().GetProperty("Data").GetValue(Component) as OnlinerBool[];

                            if (Data == null)
                            {
                                length = _data.Length;
                                Data = new IndexedData<bool>[_data.Length];
                                initialized = true;
                            }
                        }
                    }
                }
                if (initialized)
                {
                    await Component.ReadAsync();

                    _data = Component.GetType().GetProperty("Data").GetValue(Component) as OnlinerBool[];

                    for (int i = 0; i < length; i++)
                    {
                        Data[i] = new IndexedData<bool>(i, _data[i] != null ? _data[i].LastValue : (bool)false);
                    }
                }
            }
            catch (System.Exception ex)
            {

                throw;
            }
        }

        public override void Dispose()
        {
            Component.DataChanged.UnSubscribe(UpdateData);
            base.Dispose();
        }
    }

    public class AxoBoolArrayCommandView : AxoBoolArrayView
    {
        public AxoBoolArrayCommandView()
        {
            IsControllable = true;
            IsDisabled = false;
        }
    }

    public class AxoBoolArrayStatusView : AxoBoolArrayView
    {
        public AxoBoolArrayStatusView()
        {
            IsControllable = false;
            IsDisabled = true;
        }
    }

    public class AxoBoolArrayDisplayView : AxoBoolArrayView
    {
        public AxoBoolArrayDisplayView()
        {
            IsControllable = false;
            IsDisabled = true;
        }
    }
    public class AxoBoolArrayControlView : AxoBoolArrayView
    {
        public AxoBoolArrayControlView()
        {
            IsControllable = true;
            IsDisabled = false;
        }
    }
}
