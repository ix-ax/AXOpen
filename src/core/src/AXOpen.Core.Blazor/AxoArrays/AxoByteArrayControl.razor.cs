//using AXSharp.Connector;
//using AXSharp.Connector.ValueTypes;
//using System.Text;
//using System.Reflection;
//using AXSharp.Presentation.Blazor.Controls.RenderableContent;
//using Microsoft.AspNetCore.Components;
//using System.Threading;
//using System.ComponentModel;
//using Newtonsoft.Json.Linq;
//using static System.Runtime.InteropServices.JavaScript.JSType;
//using System.Globalization;
//using System.Runtime.InteropServices.JavaScript;

//namespace AXOpen.Core
//{
//    //public enum eDisplayFormat { Array_of_hexdecimals , Array_of_decimals, String };
//    public partial class AxoByteArrayControl : RenderableComplexComponentBase<AxoByteArray>, IDisposable
//    {

//        private eDisplayFormat _currentDisplayFormat;
//        private uint _maxLen = 3;
//        private string _style = "width: 2.1em";

//        public eDisplayFormat CurrentDisplayFormat
//        {
//            get => _currentDisplayFormat;
//            set
//            {
//                _currentDisplayFormat = value;
//                FormatData(null, null);
//            }
//        }

//        public uint MaxLen
//        {
//            get => _maxLen;
//            private set { _maxLen = value; }
//        }

//        public string Style
//        {
//            get => _style;
//            private set { _style = value; }
//        }

//        private bool initialized;
//        private int length;
//        private OnlinerByte[] _data;

//        public IndexedData<string>[] Data { get; set; }

//        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
//        {
            
//        }

//        protected override void OnInitialized()
//        {
//            UpdateValuesOnChange(Component);
//            base.OnInitialized();                      
//        }

//        protected override async Task OnInitializedAsync()
//        {
//            await Task.Run(() => UploadAndFormatData(null, null));
//            //Component.DataChanged.Subscribe(UpdateAndFormatData);
//            await base.OnInitializedAsync();           
//        }


//        private async void UploadAndFormatData(ITwinPrimitive sender, ValueChangedEventArgs args)
//        {
//            try
//            {
//                if (!initialized)
//                {
//                    if (Component != null && Component.GetType() != null && Component.GetType().GetProperty("Data") != null)
//                    {
//                        Type type = Component.GetType().GetProperty("Data").GetValue(Component).GetType();
//                        if (type != null && type.IsArray && type.Name != null && type.Name.ToString().Equals("OnlinerByte[]"))
//                        {
//                            OnlinerByte[] _data = Component.GetType().GetProperty("Data").GetValue(Component) as OnlinerByte[];

//                            if (Data == null)
//                            {
//                                length = _data.Length;
//                                //Data = new IndexedData<OnlinerByte>[_data.Length];
//                                Data = new IndexedData<string>[_data.Length];

//                                if (Component.DisplayFormat != null)
//                                {
//                                    string _displayFormat = Component.DisplayFormat.ToString().ToLower();
//                                    CurrentDisplayFormat = eDisplayFormat.Array_of_hexdecimals;
//                                    if (_displayFormat.Equals("decimal")) CurrentDisplayFormat = eDisplayFormat.Array_of_decimals;
//                                    if (_displayFormat.Equals("string")) CurrentDisplayFormat = eDisplayFormat.String;
//                                }

//                                initialized = true;
//                            }
//                        }
//                    }
//                }
//                if (initialized)
//                {
//                    Upload(null,null);

//                    FormatData(null, null);
//                }
//                await InvokeAsync(StateHasChanged);
//            }
//            catch (System.Exception ex)
//            {

//                throw;
//            }
//        }

//        private async void FormatData(ITwinPrimitive sender, ValueChangedEventArgs args)
//        {
//            try
//            {
//                if (!initialized)
//                {
//                    if (Component != null && Component.GetType() != null && Component.GetType().GetProperty("Data") != null)
//                    {
//                        Type type = Component.GetType().GetProperty("Data").GetValue(Component).GetType();
//                        if (type != null && type.IsArray && type.Name != null && type.Name.ToString().Equals("OnlinerByte[]"))
//                        {
//                            OnlinerByte[] _data = Component.GetType().GetProperty("Data").GetValue(Component) as OnlinerByte[];

//                            if (Data == null)
//                            {
//                                length = _data.Length;
//                                //Data = new IndexedData<OnlinerByte>[_data.Length];
//                                Data = new IndexedData<string>[_data.Length];

//                                if (Component.DisplayFormat != null)
//                                {
//                                    string _displayFormat = Component.DisplayFormat.ToString().ToLower();
//                                    CurrentDisplayFormat = eDisplayFormat.Array_of_hexdecimals;
//                                    if (_displayFormat.Equals("decimal")) CurrentDisplayFormat = eDisplayFormat.Array_of_decimals;
//                                    if (_displayFormat.Equals("string")) CurrentDisplayFormat = eDisplayFormat.String;
//                                }

//                                initialized = true;
//                            }
//                        }
//                    }
//                }
//                if (initialized)
//                {
//                    _data = Component.GetType().GetProperty("Data").GetValue(Component) as OnlinerByte[];

//                    for (int i = 0; i < length; i++)
//                    {
//                        byte _byte = _data[i] != null ? _data[i].Shadow : (byte)0;
//                        if (CurrentDisplayFormat == eDisplayFormat.Array_of_decimals)
//                        {
//                            Data[i] = new IndexedData<string>(i, _byte.ToString());
//                            MaxLen = 3;
//                            Style = "width: 2.1em; border:hidden";
//                        }
//                        else if (CurrentDisplayFormat == eDisplayFormat.Array_of_hexdecimals)
//                        {
//                            Data[i] = new IndexedData<string>(i, _byte.ToString("X"));
//                            MaxLen = 2;
//                            Style = "width: 1.8em; border:hidden";
//                        }
//                        else if (CurrentDisplayFormat == eDisplayFormat.String)
//                        {
//                            Data[i] = new IndexedData<string>(i, Encoding.UTF8.GetString(new byte[] { _byte }) );
//                            MaxLen = 1;
//                            Style = "width: 1.3em; border:hidden";
//                        }
//                    }
//                }
//                await InvokeAsync(StateHasChanged);
//            }
//            catch (System.Exception ex)
//            {

//                throw;
//            }
//        }


//        private async void Upload(ITwinPrimitive sender, ValueChangedEventArgs args)
//        {
//            try
//            {
//                if (initialized)
//                {
//                    await Component.ReadAsync();
//                    await Component.OnlineToShadowAsync();
//                }
//            }
//            catch (System.Exception ex)
//            {

//                throw;
//            }
//        }

//        private async void Download(ITwinPrimitive sender, ValueChangedEventArgs args)
//        {
//            try
//            {
//                if (initialized)
//                {

//                    for (int i = 0; i < length; i++)
//                    {
//                        byte _byte = _data[i] != null ? _data[i].Shadow : (byte)0;
//                        if (CurrentDisplayFormat == eDisplayFormat.Array_of_decimals)
//                        {
//                            _data[i].Shadow = (byte) Decimal.Parse(Data[i].Data as string, NumberStyles.None);
//                        }
//                        else if (CurrentDisplayFormat == eDisplayFormat.Array_of_hexdecimals)
//                        {
//                            _data[i].Shadow = (byte)Convert.ToInt32(Data[i].Data as string, 16);
//                        }
//                        else if (CurrentDisplayFormat == eDisplayFormat.String)
//                        {
//                            if(Data[i].Data.Length == 1)
//                            {
//                                _data[i].Shadow = Encoding.ASCII.GetBytes(Data[i].Data)[0];
//                            }
//                        }
//                    }
//                    await Component.ShadowToOnlineAsync();
//                    await Component.WriteAsync();
//                    Component.DataChanged.Cyclic = !Component.DataChanged.Cyclic;
//                }
//                await InvokeAsync(StateHasChanged);
//            }
//            catch (System.Exception ex)
//            {

//                throw;
//            }
//        }
//        public override void Dispose()
//        {
//            //Component.DataChanged.UnSubscribe(UpdateAndFormatData);
//            base.Dispose();
//        }
//    }

//    public class AxoByteArrayCommandView : AxoByteArrayControl
//    {
//        public AxoByteArrayCommandView()
//        {
//        }
//    }

//    public class AxoByteArrayControlView : AxoByteArrayControl
//    {
//        public AxoByteArrayControlView()
//        {
//        }
//    }
//}
