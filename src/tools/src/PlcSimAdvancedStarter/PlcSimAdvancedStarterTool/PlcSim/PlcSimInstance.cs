using Cocona;
using System.Reflection;
using Microsoft.CodeAnalysis;
using System.Xml.Linq;
using System.Diagnostics;
using System.Net.NetworkInformation;
using System.Net;
using System.Threading;

namespace PlcSimAdvancedStarterTool.PlcSim
{
    public class PlcSim
    {
        [Command("startplcsim")]
        public Task StartPlcSim([Option('x', Description = "PlcSim instance name")] string PlcSimInstanceName,
                                        [Option('n', Description = "Plc name.")] string PlcName,
                                        [Option('t', Description = "Plc Ip address")] string PlcIpAddress)
        {
            string dllPath = "";
            string exePath = "";

            if (PlcSimInstallation.Check(ref dllPath, ref exePath))
            {
                // This is a workaround to get the local dll for the PlcSimAdvanced API
                var entry = new FileInfo(Assembly.GetEntryAssembly().Location);
                var folder = entry.Directory.FullName;

                // Check if PlcSim is already running
                if (Process.GetProcesses().Where(p => p.ProcessName.Equals("Siemens.Simatic.PlcSim.Advanced.UserInterface")).Count() > 0)
                {
                    Console.WriteLine("PlcSimAdvanced already running.");
                }
                else
                {
                    // Start PlcSim
                    Process.Start(new ProcessStartInfo(exePath));
                    Console.WriteLine("PlcSimAdvanced started.");
                }

                var plcSimAdvancedApiDll = Assembly.LoadFrom(dllPath);

                var simulationRuntimeManager = plcSimAdvancedApiDll.GetType("Siemens.Simatic.Simulation.Runtime.SimulationRuntimeManager");
                var networkModeProperty = simulationRuntimeManager.GetRuntimeProperty("NetworkMode");
                var eNetworkModeType = plcSimAdvancedApiDll.GetType("Siemens.Simatic.Simulation.Runtime.ENetworkMode");
                var tcpipSingleAdapterValue = Enum.Parse(eNetworkModeType, "TCPIPSingleAdapter");
                networkModeProperty.SetValue(null, tcpipSingleAdapterValue);

                // Check if PlcSimInstanceName is already registered
                bool instanceAlreadyRegistered = false;


                var iInstanceType = plcSimAdvancedApiDll.GetType("Siemens.Simatic.Simulation.Runtime.IInstance");
                object plcSimInstance = null;

                var registeredInstanceInfoProperty = simulationRuntimeManager.GetProperty("RegisteredInstanceInfo", BindingFlags.Static | BindingFlags.Public);
                var instanceInfos = registeredInstanceInfoProperty.GetValue(null) as Array;
                var eOperatingStateType = plcSimAdvancedApiDll.GetType("Siemens.Simatic.Simulation.Runtime.EOperatingState");
                string operatingStateTypeOffValue = Enum.Parse(eOperatingStateType, "Off").ToString();
                string operatingStateValue = "";
                if (instanceInfos != null)
                {
                    // Check the count of the already registered intances
                    int currInstancesCount = instanceInfos.Length;
                    // Unregister all instances if their number reachs the maximum
                    if (currInstancesCount >= Setup.Constants.PlcSimAdvancedMaxSessionCount)
                    {
                        Console.WriteLine($"Maximum number of registered instances ({Setup.Constants.PlcSimAdvancedMaxSessionCount}) reached.");
                        foreach (var instanceInfo in instanceInfos)
                        {
                            // Get name of the existing instance that is gonna to be kill
                            string instanceName = instanceInfo.GetType().GetField("Name", BindingFlags.Public | BindingFlags.Instance).GetValue(instanceInfo)?.ToString();

                            var createInterfaceMethod = simulationRuntimeManager.GetMethod("CreateInterface", BindingFlags.Static | BindingFlags.Public, null, new Type[] { typeof(string) }, null);
                            plcSimInstance = createInterfaceMethod.Invoke(null, new object[] { instanceName });

                            var unregisterInstanceMethod = plcSimInstance.GetType().GetMethod("UnregisterInstance",BindingFlags.Public | BindingFlags.Instance);

                            if (unregisterInstanceMethod != null)
                            {
                                unregisterInstanceMethod.Invoke(plcSimInstance, null);
                                Console.WriteLine($"Instance {instanceName} has been unregistered to release resources.");
                            }
                            else
                            {
                                Console.WriteLine("Method 'UnregisterInstance' not found.");
                            }
                        }
                        instanceInfos = registeredInstanceInfoProperty.GetValue(null) as Array;
                    }

                    foreach (var instanceInfo in instanceInfos)
                    {
                        // Get name of the existing instance
                        string instanceName = instanceInfo.GetType().GetField("Name", BindingFlags.Public | BindingFlags.Instance).GetValue(instanceInfo)?.ToString();

                        var createInterfaceMethod = simulationRuntimeManager.GetMethod("CreateInterface", BindingFlags.Static | BindingFlags.Public, null, new Type[] { typeof(string) }, null);
                        plcSimInstance = createInterfaceMethod.Invoke(null, new object[] { instanceName });

                        // Get IPs of the existing instance
                        string[] controllerIPs = plcSimInstance.GetType().GetProperty("ControllerIP").GetValue(plcSimInstance) as string[];

                        foreach (string controllerIp in controllerIPs)
                        {
                            // Power off the instance, if its IP address conflicts 
                            if (controllerIp.Equals(PlcIpAddress) && !instanceName.Equals(PlcSimInstanceName))
                            {
                                var powerOffMethod = plcSimInstance.GetType().GetMethod("PowerOff", BindingFlags.Public | BindingFlags.Instance, null, new Type[] { typeof(uint) }, null);
                                operatingStateValue = plcSimInstance.GetType().GetRuntimeProperty("OperatingState").GetValue(plcSimInstance).ToString();
                                if(operatingStateValue != operatingStateTypeOffValue)
                                {
                                    uint timeout = 6000;
                                    powerOffMethod.Invoke(plcSimInstance, new object[] { timeout });
                                    Console.WriteLine($"Instance {plcSimInstance} powered off, as its IP address {PlcIpAddress} has a conflict with IP address of the instance {PlcSimInstanceName}.");
                                }
                                break;
                            }
                        }

                        if (instanceName.Equals(PlcSimInstanceName))
                        {
                            Console.WriteLine($"Instance {PlcSimInstanceName} already registered.");
                            plcSimInstance = createInterfaceMethod.Invoke(null, new object[] { PlcSimInstanceName });
                            instanceAlreadyRegistered = true;
                            break;
                        }
                    }
                }


                // Register PlcSimInstanceName 
                if (!instanceAlreadyRegistered)
                {
                    var registerInstanceMethod = simulationRuntimeManager.GetMethod("RegisterInstance", BindingFlags.Static | BindingFlags.Public, null, new Type[] { typeof(string) }, null);
                    plcSimInstance = registerInstanceMethod.Invoke(null, new object[] { PlcSimInstanceName });
                    Console.WriteLine($"Instance {PlcSimInstanceName} registered.");
                }

                // Power On 
                operatingStateValue = plcSimInstance.GetType().GetRuntimeProperty("OperatingState").GetValue(plcSimInstance).ToString();

                if (operatingStateValue.Equals(operatingStateTypeOffValue))
                {
                    var powerOnMethod = plcSimInstance.GetType().GetMethod("PowerOn", BindingFlags.Public | BindingFlags.Instance, null, new Type[] { typeof(uint) }, null);
                    uint timeout = 6000;
                    powerOnMethod.Invoke(plcSimInstance, new object[] { timeout });
                    Console.WriteLine($"Instance {PlcSimInstanceName} powered on.");
                }
                else
                {
                    Console.WriteLine($"Instance {PlcSimInstanceName} already powered.");
                }

                //  Set Ip address
                var sipSuiteType = plcSimInstance.GetType().Assembly.GetType("Siemens.Simatic.Simulation.Runtime.SIPSuite4");

                if (sipSuiteType != null)
                {
                    var setIpSuiteMethod = plcSimInstance.GetType().GetMethod("SetIPSuite", BindingFlags.Public | BindingFlags.Instance);
                    if (setIpSuiteMethod != null)
                    {
                        var sipSuiteInstance = Activator.CreateInstance(sipSuiteType, new object[] { PlcIpAddress, "255.255.255.0", "0.0.0.0" });
                        if (sipSuiteInstance != null)
                        {
                            setIpSuiteMethod.Invoke(plcSimInstance, new object[] { (UInt32)0, sipSuiteInstance, true });
                        }
                        else
                        {
                            Console.WriteLine("Failed to create SIPSuite4 instance.");
                            return Task.CompletedTask;
                        }
                    }
                    else
                    {
                        Console.WriteLine("SetIPSuite method not found.");
                        return Task.CompletedTask;
                    }
                }
                else
                {
                    Console.WriteLine("SIPSuite4 type not found.");
                    return Task.CompletedTask;
                }

                // Run
                string operatingStateTypeStopValue = Enum.Parse(eOperatingStateType, "Stop").ToString();
                operatingStateValue = plcSimInstance.GetType().GetRuntimeProperty("OperatingState").GetValue(plcSimInstance).ToString();

                if (operatingStateValue.Equals(operatingStateTypeStopValue))
                {
                    try
                    {
                        var runMethod = plcSimInstance.GetType().GetMethod("Run", BindingFlags.Public | BindingFlags.Instance, null, new Type[] { typeof(uint) }, null);
                        uint timeout = 6000;
                        runMethod.Invoke(plcSimInstance, new object[] { timeout });
                        Console.WriteLine($"PLC set to RUN mode.");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Unable to set the PLC into the RUN mode. {ex.Message}");

                    }
                }
                const int timeoutSeconds = 60;
                const int pingIntervalMilliseconds = 1000; 

                bool isAccessible = false;
                DateTime startTime = DateTime.Now;

                Console.WriteLine($"Checking accessibility of the PLCsim instance: {PlcSimInstanceName} at IP address: {PlcIpAddress}.");

                using (Ping ping = new Ping())
                {
                    while ((DateTime.Now - startTime).TotalSeconds < timeoutSeconds)
                    {
                        try
                        {
                            PingReply reply = ping.Send(PlcIpAddress);

                            if (reply.Status == IPStatus.Success)
                            {
                                Console.WriteLine($"PLCsim instance: {PlcSimInstanceName} at IP address: {PlcIpAddress} is accessible!");
                                isAccessible = true;
                                break; 
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine($"Ping attempt failed: {ex.Message}");
                        }

                        Thread.Sleep(pingIntervalMilliseconds); 
                    }
                }

                if (!isAccessible)
                {
                    Console.WriteLine($"Error: Device did not respond within {timeoutSeconds} seconds.");
                }
            }
            return Task.CompletedTask;
        }
    }
}
