using System.Reflection;
using System.Xml.Linq;
using Siemens.Simatic.Simulation.Runtime;
using System.Diagnostics;


namespace PlcSimAdvancedStarter
{
    public static class PlcSimInstance
    {
        public static void StartPlcSim(Options options)
        {

            SimulationRuntimeManager.NetworkMode = ENetworkMode.TCPIPSingleAdapter;

            // Check if PlcSimInstanceName is already registered
            bool instanceAlreadyRegistered = false;
            IInstance plcSimInstance = null;
            SInstanceInfo[] instanceInfos = SimulationRuntimeManager.RegisteredInstanceInfo;
            foreach (SInstanceInfo instanceInfo in instanceInfos)
            {
                if (instanceInfo.Name.Equals(options.PlcSimInstanceName))
                {
                    Console.WriteLine($"Instance {options.PlcSimInstanceName} already registered.");
                    plcSimInstance = SimulationRuntimeManager.CreateInterface(options.PlcSimInstanceName);
                    instanceAlreadyRegistered = true;
                    break;
                }
            }

            // Register PlcSimInstanceName
            if (!instanceAlreadyRegistered)
            {
                plcSimInstance = SimulationRuntimeManager.RegisterInstance(options.PlcSimInstanceName);
                Console.WriteLine($"Instance {options.PlcSimInstanceName} registered.");
            }

            // Power On 
            if (plcSimInstance.OperatingState == EOperatingState.Off)
            {
                plcSimInstance.PowerOn(6000);
                Console.WriteLine($"Instance {options.PlcSimInstanceName} powered on.");
            }
            else
            {
                Console.WriteLine($"Instance {options.PlcSimInstanceName} already powered.");
            }
            //  Set Ip address
            plcSimInstance.SetIPSuite(0, new SIPSuite4(options.PlcIpAddress, "255.255.255.0", "0.0.0.0"), true);

            // Run
            if (plcSimInstance.OperatingState == EOperatingState.Stop)
            {
                try
                {
                    plcSimInstance.Run(6000);
                    Console.WriteLine($"PLC set to RUN mode.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Unable to set the PLC into the RUN mode. {ex.Message}");

                }

            }
        }


    }
}
