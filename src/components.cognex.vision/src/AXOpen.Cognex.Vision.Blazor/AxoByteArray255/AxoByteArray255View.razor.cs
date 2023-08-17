using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Net.Http.Headers;
using System.Reflection;
using System.Security.Principal;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using static System.Formats.Asn1.AsnWriter;
using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using System.Text;

namespace AXOpen.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoByteArray255View
    {
        public enum eDisplayFormat { Array_of_decimals, Array_of_hexdecimals, String };

        private eDisplayFormat _currentDisplayFormat;
        public eDisplayFormat CurrentDisplayFormat
        {
            get => _currentDisplayFormat;
            set
            {
                _currentDisplayFormat = value;
                UpdateAndFormatData();
            }
        }
        public ObservableCollection<IndexedData<string>> Data { get; private set; }
        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            base.OnInitialized();
            UpdateAndFormatData();
            Component.DataChanged.Subscribe((sender, arg) => UpdateAndFormatData());
        }

        private async void UpdateAndFormatData()
        {
                try
                {
                    if (Data == null)
                    {
                        Data = new ObservableCollection<IndexedData<string>>();
                    }
                    else
                    {
                        Data.Clear();
                    }
                    if (Component != null && Component.GetConnector() != null && Component.Data != null)
                    {

                        await Component.ReadAsync();
                        int length = Component.Data.Length;
                        length = 255;
                        if (CurrentDisplayFormat == eDisplayFormat.Array_of_decimals)
                        {
                            for (int i = 0; i < length; i++)
                            {
                                byte _item = Component.Data[i].LastValue;
                                Data.Add(new IndexedData<string>(i, _item.ToString()));
                            }
                        }
                        else if (CurrentDisplayFormat == eDisplayFormat.Array_of_hexdecimals)
                        {
                            for (int i = 0; i < length; i++)
                            {
                                byte _item = Component.Data[i].LastValue;
                                Data.Add(new IndexedData<string>(i, _item.ToString("X")));
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

                                Data.Add(new IndexedData<string>(i, _string));
                            }
                        }
                    }
                }
                catch (System.Exception ex)
                {

                    throw;
                }
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
