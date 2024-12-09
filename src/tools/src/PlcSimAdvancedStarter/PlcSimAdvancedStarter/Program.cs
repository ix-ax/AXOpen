using CommandLine;
using System;
using System.Resources;
using System.Reflection;

namespace PlcSimAdvancedStarter
{
    public class Program
    {
        public static void Main(string[] args)
        {

            Parser.Default.ParseArguments<Options>(args)
            .WithParsed(o =>
            {
                var recoverCurrentDirectory = Environment.CurrentDirectory;
                try
                {
                    PlcSimInstance.StartPlcSim(o);
                    Console.WriteLine("Done.");
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }
                finally
                {
                    Environment.CurrentDirectory = recoverCurrentDirectory;
                }
            });
        }
    }


    public class Options
    {
        [Option('x', "PlcSimInstanceName", Required = true, HelpText = "PlcSim instance name")]
        public string PlcSimInstanceName { get; set; }

        [Option('n', "PlcName", Required = true,
            HelpText = "Plc name")]
        public string PlcName { get; set; }

        [Option('t', "PlcIpAddress", Required = true, HelpText = "Plc Ip address")]
        public string PlcIpAddress { get; set; }

        [Option('h', "hwid", Required = false, HelpText = "Export hardware identifiers")]
        public bool HwId { get; set; }

    }
}
