using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using Operon.Components.Dropdown;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Security.Blazor.Services
{
    public interface ISerialService
    {
        public Task<bool> OpenPortAsync(int baudRate, bool onlyPreviouslyAuthorizedPort = false, int dataBits = 8, bool flowControl = false, int parity = 0, int stopBits = 1);

        public Task ClosePortAsync();

        public Task WriteDataAsync(byte[] data);

        public event Action<byte[]>? DataReceived;

        public event Action? SerialError;

        public event Action? DeviceInfoReceived;

        public event Action? AfterOpenPort;

        public bool PortOpen { get; }
    }

    public class SerialService : ISerialService
    {
        private IJSRuntime _jsRuntime { get; set; }
        private IJSObjectReference? _module { get; set; }
        private DotNetObjectReference<SerialService>? _selfRef { get; set; }

        public event Action<byte[]>? DataReceived;

        public event Action? SerialError;

        public event Action? DeviceInfoReceived;

        public event Action? AfterOpenPort;

        public bool PortOpen { get; set; } = false;

        public SerialService(IJSRuntime jsRuntime)
        {
            _jsRuntime = jsRuntime;
        }

        public async Task<bool> OpenPortAsync(int baudRate, bool onlyPreviouslyAuthorizedPort = false, int dataBits = 8, bool flowControl = false, int parity = 0, int stopBits = 1)
        {
            if (PortOpen)
                throw new InvalidOperationException("Cannot open serial port because a serial port is already open.");

            _selfRef = DotNetObjectReference.Create(this);
            string flowControlString = flowControl ? "none" : "hardware";
            string parityString = parity switch
            {
                1 => "even",
                2 => "odd",
                _ => "none"
            };

            if(_module == null)
                _module = await _jsRuntime.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.Security.Blazor/js/SerialCommunication.js");
            int operationStatus = await _module.InvokeAsync<int>("openPortAsync", _selfRef, onlyPreviouslyAuthorizedPort, baudRate, 512, dataBits, flowControlString, parityString, stopBits);

            switch (operationStatus)
            {
                case 1:
                    AfterOpenPort?.Invoke();
                    return false;
                case 11:
                    AfterOpenPort?.Invoke();
                    throw new InvalidOperationException("Web Serial API not supported in this browser.");
                case 12:
                    AfterOpenPort?.Invoke();
                    throw new InvalidOperationException("No previously authorized port found.");
                case 13:
                    AfterOpenPort?.Invoke();
                    throw new InvalidOperationException("Insufficient permissions for accessing serial ports.");
                case 14:
                    AfterOpenPort?.Invoke();
                    throw new InvalidOperationException("Cannot open serial port because is already open.");
                case 15:
                    AfterOpenPort?.Invoke();
                    throw new InvalidOperationException("Failed to open the serial port");
                default: // 0
                    PortOpen = true;
                    AfterOpenPort?.Invoke();
                    return true;
            }
        }

        public async Task ClosePortAsync()
        {
            if (!PortOpen) return;

            try
            {
                if (_module == null)
                    _module = await _jsRuntime.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.Security.Blazor/js/SerialCommunication.js");
                await _module.InvokeVoidAsync("closePortAsync");
                _selfRef!.Dispose();
            }
            catch (Exception ex)
            {
                
            }

            PortOpen = false;
        }

        public async Task WriteDataAsync(byte[] data)
        {
            if (!PortOpen)
                throw new InvalidOperationException("Cannot write to the serial port because no port has been opened.");

            try
            {
                if (_module == null)
                    _module = await _jsRuntime.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.Security.Blazor/js/SerialCommunication.js");
                await _module.InvokeVoidAsync("writeDataAsync", new object[] { data });
            }
            catch (JSException ex)
            {
                throw new InvalidOperationException("Failed to write data to serial port: " + ex.Message);
            }
        }

        [JSInvokable]
        public void OnDataReceived(byte[] data)
        {
            DataReceived?.Invoke(data);
        }

        [JSInvokable]
        public void OnSerialError()
        {
            _selfRef!.Dispose();
            PortOpen = false;
            SerialError?.Invoke();
        }

        [JSInvokable]
        public void OnDeviceInfoReceived(ushort? vendorID, ushort? deviceID)
        {
            DeviceInfoReceived?.Invoke();
        }
    }
}
