using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Text;
using System.Reflection;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using System.Globalization;

namespace AXOpen.Core
{
    public enum eDisplayFormat { Array_of_hexdecimals , Array_of_decimals, String };
    public partial class AxoByteArrayView : RenderableComplexComponentBase<AxoByteArray>, IDisposable
    {
        private eDisplayFormat _displayFormat;
        private uint _maxLen = 3;
        private bool _isReadOnly = false;

        [Parameter]
        public bool IsControllable { get; set; }

        public eDisplayFormat DisplayFormat
        {
            get => _displayFormat;
            set
            {
                _displayFormat = value;
                FormatData(null, null);
            }
        }

        public uint MaxLen
        {
            get => _maxLen;
            private set { _maxLen = value; }
        }

        public bool IsReadOnly
        {
            get => _isReadOnly;
            private set { _isReadOnly = value; }
        }


        private bool initialized;
        private int length;
        private OnlinerByte[] _data;

        public IndexedData<string>[] Data { get; set; } 
        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            
        }

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            base.OnInitialized();                      
        }

        protected override async Task OnInitializedAsync()
        {
            await Task.Run(() => UploadAndFormatData(null, null));
            Component.DataChanged.Subscribe(UploadAndFormatData);
            await base.OnInitializedAsync();           
        }
        private async void UploadAndFormatData(ITwinPrimitive sender, ValueChangedEventArgs args)
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

                                if (Component.DisplayFormat != null)
                                {
                                    string _displayFormat = Component.DisplayFormat.ToString().ToLower();
                                    _isReadOnly = _data[0].ReadWriteAccess.Equals(ReadWriteAccess.Read);
                                    DisplayFormat = eDisplayFormat.Array_of_hexdecimals;
                                    if (_displayFormat.Equals("decimal")) DisplayFormat = eDisplayFormat.Array_of_decimals;
                                    if (_displayFormat.Equals("string")) DisplayFormat = eDisplayFormat.String;
                                }

                                initialized = true;
                            }
                        }
                    }
                }
                if (initialized)
                {
                    Upload(null, null);

                    FormatData(null, null);
                }
                await InvokeAsync(StateHasChanged);
            }
            catch (System.Exception ex)
            {

                throw;
            }
        }

        private async void FormatData(ITwinPrimitive sender, ValueChangedEventArgs args)
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
                                //Data = new IndexedData<OnlinerByte>[_data.Length];
                                Data = new IndexedData<string>[_data.Length];

                                if (Component.DisplayFormat != null)
                                {
                                    string _displayFormat = Component.DisplayFormat.ToString().ToLower();
                                    DisplayFormat = eDisplayFormat.Array_of_hexdecimals;
                                    if (_displayFormat.Equals("decimal")) DisplayFormat = eDisplayFormat.Array_of_decimals;
                                    if (_displayFormat.Equals("string")) DisplayFormat = eDisplayFormat.String;
                                }

                                initialized = true;
                            }
                        }
                    }
                }
                if (initialized)
                {
                    _data = Component.GetType().GetProperty("Data").GetValue(Component) as OnlinerByte[];

                    for (int i = 0; i < length; i++)
                    {
                        byte _byte = _data[i] != null ? _data[i].Shadow : (byte)0;
                        if (DisplayFormat == eDisplayFormat.Array_of_decimals)
                        {
                            Data[i] = new IndexedData<string>(i, _byte.ToString());
                            MaxLen = 3;
                        }
                        else if (DisplayFormat == eDisplayFormat.Array_of_hexdecimals)
                        {
                            Data[i] = new IndexedData<string>(i, _byte.ToString("X"));
                            MaxLen = 2;
                        }
                        else if (DisplayFormat == eDisplayFormat.String)
                        {
                            Data[i] = new IndexedData<string>(i, Encoding.UTF8.GetString(new byte[] { _byte }));
                            MaxLen = 1;
                        }
                    }
                }
                await InvokeAsync(StateHasChanged);
            }
            catch (System.Exception ex)
            {

                throw;
            }
        }

        private async void Upload(ITwinPrimitive sender, ValueChangedEventArgs args)
        {
            try
            {
                if (initialized)
                {
                    await Component.ReadAsync();
                    await Component.OnlineToShadowAsync();
                }
            }
            catch (System.Exception ex)
            {

                throw;
            }
        }

        private async void Download(ITwinPrimitive sender, ValueChangedEventArgs args)
        {
            try
            {
                if (initialized)
                {

                    for (int i = 0; i < length; i++)
                    {
                        byte _byte = _data[i] != null ? _data[i].Shadow : (byte)0;
                        if (DisplayFormat == eDisplayFormat.Array_of_decimals)
                        {
                            _data[i].Shadow = (byte)Decimal.Parse(Data[i].Data as string, NumberStyles.None);
                        }
                        else if (DisplayFormat == eDisplayFormat.Array_of_hexdecimals)
                        {
                            _data[i].Shadow = (byte)Convert.ToInt32(Data[i].Data as string, 16);
                        }
                        else if (DisplayFormat == eDisplayFormat.String)
                        {
                            if (Data[i].Data.Length == 1)
                            {
                                _data[i].Shadow = Encoding.ASCII.GetBytes(Data[i].Data)[0];
                            }
                        }
                    }
                    await Component.ShadowToOnlineAsync();
                    await Component.WriteAsync();
                    Component.DataChanged.Cyclic = !Component.DataChanged.Cyclic;
                }
                await InvokeAsync(StateHasChanged);
            }
            catch (System.Exception ex)
            {

                throw;
            }
        }

        public override void Dispose()
        {
            Component.DataChanged.UnSubscribe(UploadAndFormatData);
            base.Dispose();
        }
    }

    public class AxoByteArrayCommandView : AxoByteArrayView
    {
        public AxoByteArrayCommandView()
        {
            IsControllable = true;
        }
    }

    public class AxoByteArrayStatusView : AxoByteArrayView
    {
        public AxoByteArrayStatusView()
        {
            IsControllable = false;
        }
    }

    public class AxoByteArrayDisplayView : AxoByteArrayView
    {
        public AxoByteArrayDisplayView()
        {
            IsControllable = false;
        }
    }

    public class AxoByteArrayControlView : AxoByteArrayView
    {
        public AxoByteArrayControlView()
        {
            IsControllable = true;
        }
    }
}
