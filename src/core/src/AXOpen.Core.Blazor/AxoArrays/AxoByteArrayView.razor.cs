using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Text;
using System.Reflection;

namespace AXOpen.Core
{
    public enum eDisplayFormat { Array_of_decimals, Array_of_hexdecimals, String };
    public partial class AxoByteArrayView : IDisposable
    {

        private eDisplayFormat _currentDisplayFormat;

        public eDisplayFormat CurrentDisplayFormat
        {
            get => _currentDisplayFormat;
            set
            {
                _currentDisplayFormat = value;
                UpdateAndFormatData(null, null);
            }
        }

        private bool initialized;
        private int length;
        private OnlinerByte[] _data;

        public IndexedData<string>[] Data { get; private set; } 
        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            
        }

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            base.OnInitialized();
            UpdateAndFormatData(null, null);
            Component.DataChanged.Subscribe(UpdateAndFormatData);
        }

        private async void UpdateAndFormatData(ITwinPrimitive sender, ValueChangedEventArgs args)
        {
            try
            {
                if (!initialized)
                {
                    if (Component != null && Component.GetType() != null && Component.GetType().GetProperty("Data") != null)
                    {
                        Type type = Component.GetType().GetProperty("Data").GetValue(Component).GetType();
                        if (type != null && type.IsArray && type.Name != null && type.Name.ToString().Equals("OnlinerByte[]"))
                        {
                            OnlinerByte[] _data = Component.GetType().GetProperty("Data").GetValue(Component) as OnlinerByte[];

                            if (Data == null)
                            {
                                length = _data.Length;
                                Data = new IndexedData<string>[_data.Length];
                                initialized = true;
                            }
                        }
                    }
                }
                if (initialized)
                {
                    await Component.ReadAsync();

                    _data = Component.GetType().GetProperty("Data").GetValue(Component) as OnlinerByte[];

                    for (int i = 0; i < length; i++)
                    {
                        byte _byte = _data[i] != null ? _data[i].LastValue : (byte)0;
                        if (CurrentDisplayFormat == eDisplayFormat.Array_of_decimals)
                        {
                            Data[i] = new IndexedData<string>(i, _byte.ToString());
                        }
                        else if (CurrentDisplayFormat == eDisplayFormat.Array_of_hexdecimals)
                        {
                            Data[i] = new IndexedData<string>(i, _byte.ToString("X"));
                        }
                        else if (CurrentDisplayFormat == eDisplayFormat.String)
                        {
                            Data[i] = new IndexedData<string>(i, _byte>0 ? Encoding.UTF8.GetString(new byte[] { _byte }) : "N/A" );
                        }
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
            Component.DataChanged.UnSubscribe(UpdateAndFormatData);
            base.Dispose();
        }
    }

    public class AxoByteArrayCommandView : AxoByteArrayView
    {
        public AxoByteArrayCommandView()
        {
        }
    }

    public class AxoByteArrayStatusView : AxoByteArrayView
    {
        public AxoByteArrayStatusView()
        {
        }
    }

    public class AxoByteArrayDisplayView : AxoByteArrayView
    {
        public AxoByteArrayDisplayView()
        {
        }
    }
    public class AxoByteArrayControlView : AxoByteArrayView
    {
        public AxoByteArrayControlView()
        {
        }
    }
}
