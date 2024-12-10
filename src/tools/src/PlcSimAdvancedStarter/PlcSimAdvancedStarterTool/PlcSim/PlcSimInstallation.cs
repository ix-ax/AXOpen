using Microsoft.VisualBasic;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Security.AccessControl;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;


namespace PlcSimAdvancedStarterTool.PlcSim
{
    public class PlcSimInstallation
    {
        public static bool Check(ref string dllPath, ref string exePath)
        {
            dllPath = "";
            exePath = "";
            using (RegistryKey baseKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry64))
            {
                using (RegistryKey? registryKey = baseKey.OpenSubKey("SOFTWARE\\WOW6432Node\\Siemens\\Shared Tools\\PLCSIMADV_SimRT", RegistryKeyPermissionCheck.ReadSubTree, RegistryRights.ReadKey))
                {
                    string registryPathValue = registryKey?.GetValue("Path") as string;
                    string registryVersionValue = registryKey?.GetValue("Version") as string;
                
                    if (string.IsNullOrWhiteSpace(registryPathValue) )
                    {
                        Console.WriteLine("Unable to discover PLCSimAdvanced installation.");
                        return false;
                    }

                    if (string.IsNullOrWhiteSpace(registryVersionValue))
                    {
                        Console.WriteLine("Unable to discover the version of the PLCSimAdvanced.");
                        return false;
                    }
                    
                    try
                    {
                        Version libraryVersion = Version.Parse(registryVersionValue);

                        if (libraryVersion < Setup.Constants.PlcSimAdvancedMinVersion)
                        {
                            Console.WriteLine($"PlcSimAdvanced version ({libraryVersion}) is lower then min supported version ({Setup.Constants.PlcSimAdvancedMinVersion}).");
                            return false;
                        }

                        if (libraryVersion > Setup.Constants.PlcSimAdvancedMaxVersion)
                        {
                            Console.WriteLine($"PlcSimAdvanced version ({libraryVersion}) is higher then max supported version ({Setup.Constants.PlcSimAdvancedMaxVersion}).");
                            return false;
                        }
                    }
                    catch (FormatException)
                    {
                        Console.WriteLine("Invalid version format.");
                        return false;
                    }

                    if (!Directory.Exists(registryPathValue))
                    {
                        Console.WriteLine($"Directory {registryPathValue} does not exists, or is not accessible.");
                        return false;
                    }
                    
                    registryPathValue = Path.Combine(registryPathValue, "API");
                    if (!Directory.Exists(registryPathValue))
                    {
                        Console.WriteLine($"Directory {registryPathValue} does not exists, or is not accessible.");
                        return false;
                    }

                    string[] registryVersionValueParts = registryVersionValue.Split('.');

                    registryPathValue = Path.Combine(registryPathValue, $"{registryVersionValueParts[0]}.{registryVersionValueParts[1]}");
                    if (!Directory.Exists(registryPathValue))
                    {
                        Console.WriteLine($"Directory {registryPathValue} does not exists, or is not accessible.");
                        return false;
                    }

                    registryPathValue = Path.Combine(registryPathValue, "Siemens.Simatic.Simulation.Runtime.Api.x64.dll");
                    if (!File.Exists(registryPathValue))
                    {
                        Console.WriteLine($"Required file {registryPathValue} does not exists, or is not accessible.");
                        return false;
                    }
                    dllPath = registryPathValue;
                }
                
                using (RegistryKey? registryKey = baseKey.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer\\Folders", RegistryKeyPermissionCheck.ReadSubTree, RegistryRights.ReadKey))
                {
                    string[] registryValues = registryKey?.GetValueNames();
                    string plcSimInstallationFolder = "";
                    foreach (string registryValue in registryValues)
                    {
                        if (registryValue.Contains("Siemens\\Automation\\PLCSIMADV\\bin\\"))
                        {
                            plcSimInstallationFolder = registryValue;
                            break;
                        }
                    }

                    if (String.IsNullOrEmpty(plcSimInstallationFolder))
                    {
                        return false;
                    }

                    if (!Directory.Exists(plcSimInstallationFolder))
                    {
                        Console.WriteLine($"Directory {plcSimInstallationFolder} does not exists, or is not accessible.");
                        return false;
                    }

                    plcSimInstallationFolder = Path.Combine(plcSimInstallationFolder, "Siemens.Simatic.PlcSim.Advanced.UserInterface.exe");
                    if (!File.Exists(plcSimInstallationFolder))
                    {
                        Console.WriteLine($"File {plcSimInstallationFolder} does not exists, or is not accessible.");
                        return false;
                    }
                    exePath = plcSimInstallationFolder;
                }
                return true;
            }
        }
    }
}
