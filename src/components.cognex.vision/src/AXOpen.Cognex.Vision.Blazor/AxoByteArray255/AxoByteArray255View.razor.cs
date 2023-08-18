using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Text;

namespace AXOpen.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoByteArray255View : IDisposable
    {
        public enum eDisplayFormat { Array_of_decimals, Array_of_hexdecimals, String };

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
        public IndexedData<string>[] Data { get; private set; } = new IndexedData<string>[255];
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
                if (Component != null && Component.GetConnector() != null && Component.Data != null)
                {
                    await Component.ReadAsync();
                    int length = 255;
                    if (CurrentDisplayFormat == eDisplayFormat.Array_of_decimals)
                    {
                        for (int i = 0; i < length; i++)
                        {
                            byte _item = Component.Data[i].LastValue;
                            Data[i] = new IndexedData<string>(i, _item.ToString());
                        }
                    }
                    else if (CurrentDisplayFormat == eDisplayFormat.Array_of_hexdecimals)
                    {
                        for (int i = 0; i < length; i++)
                        {
                            byte _item = Component.Data[i].LastValue;
                            Data[i] = new IndexedData<string>(i, _item.ToString("X"));
                        }
                    }
                    else if (CurrentDisplayFormat == eDisplayFormat.String)
                    {
                        for (int i = 0; i < length; i++)
                        {
                            byte _byte = Component.Data[i].LastValue;
                            string _string = "";
                            if (_byte > 0)
                                _string = Encoding.UTF8.GetString(new byte[] { _byte });
                            else _string = "N/A";
                            Data[i] = new IndexedData<string>(i, _string);
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

    public class AxoByteArray255CommandView : AxoByteArray255View
    {
        public AxoByteArray255CommandView()
        {
        }
    }

    public class AxoByteArray255StatusView : AxoByteArray255View
    {
        public AxoByteArray255StatusView()
        {
        }
    }
}
