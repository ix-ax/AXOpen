using AXOpen.Messaging.Static;
using AXSharp.Connector;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using AXOpen.Components.Rexroth.Press.v_4_x_x.RestApi;
using System.Security.Cryptography.Xml;
using System.Security.Policy;


namespace AXOpen.Components.Rexroth.Press.v_4_x_x
{
    public partial class AxoSmartFunctionKit : AXOpen.Core.AxoComponent
    {
       
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            try
            {
                InitializeMessenger();
                InitializeTaskMessenger();
                this.GetResultsTask.Initialize(()=>GetResults());
                this.ExportCurveTask.Initialize(()=>ExportCurve());
            }
            catch (Exception)
            {

                throw;
            }


        }
        private async void GetResults()
        {
            var rd = await this.ReadAsync();

            var client = new Client(Config.IpAddress.Cyclic);

            var curve = client.GetLastCurveData();
            Results.createdDate.Cyclic = curve.createdDate;
            Results.customId.Cyclic = curve.customId;
            Results.cycleTime.Cyclic = Convert.ToSingle(curve.cycleTime);
            Results.dataRecordingDisabled.Cyclic = curve.dataRecordingDisabled;
            Results.id.Cyclic = curve.id;
            Results.maxForce.Cyclic = Convert.ToSingle(curve.maxForce);
            Results.maxPosition.Cyclic = Convert.ToSingle(curve.maxPosition);
            Results.samplingInterval.Cyclic = (short)curve.samplingInterval;
            Results.status.Cyclic = curve.status;
            Results.valid.Cyclic = curve.valid;
            Results.validationTime.Cyclic = (short)curve.validationTime;
            Results._v.Cyclic = (short)curve.__v;
            var wr = await this.WriteAsync();

        }
        private string RemoveUnnecessary(string source)
        {
            string result = string.Empty;
            string regex = new string(Path.GetInvalidFileNameChars()) + new string(Path.GetInvalidPathChars());
            Regex reg = new Regex(string.Format("[{0}]", Regex.Escape(regex)));
            result = reg.Replace(source, "");
            return result;
        }
        private async void ExportCurve()
        {

            var rd = await this.ReadAsync();

            var client = new Client(Config.IpAddress.LastValue);


            if (Config.CurveExportLocation.Cyclic == string.Empty)
            {
                throw new FileNotFoundException(@"Export location is not defined!");

            }
            var curve = client.GetLastCurveData();

            string dateTieme = DateTime.Now.ToString("yyyyMMddHHmmss");
            string fileName = String.Format("{0}_{1}_{2}.json ", curve.customId, curve.id, dateTieme);
            string dirName = DateTime.Now.ToString("yyyyMMdd");
            Directory.CreateDirectory(Path.Combine(Config.CurveExportLocation.LastValue, dirName));
            string path = Path.Combine(Config.CurveExportLocation.Cyclic, dirName, RemoveUnnecessary(fileName));



            try
            {
                JsonSerializer serializer = new JsonSerializer();
                serializer.Converters.Add(new JavaScriptDateTimeConverter());
                serializer.NullValueHandling = NullValueHandling.Ignore;

                using (StreamWriter sw = new StreamWriter(path))
                using (JsonWriter writer = new JsonTextWriter(sw))
                {
                    serializer.Serialize(writer, curve);

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        private void InitializeMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,   new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                                                                                "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Run command started.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(300, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(301, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(302, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(303, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(304, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(305, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(306, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(307, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(308, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(309, new AxoMessengerTextItem("Run command running.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Run command finished succesfully.",                                                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Run command restored.",                                                                                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Get results started.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Get results finished succesfully.",                                                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Get results restored.",                                                                                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Export curve started.",                                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Export curve finished succesfully.",                                                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Export curve restored.",                                                                                                                    "")),

                //  General alarm
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                                                               ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!"                                                                                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                                                    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HW_ParamCh_IDN is zero."                                                                                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'ParamCh_5Words' (GsdId=ID_PaCh_5Words)."                                 ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HW_F-Modul_not_used is zero."                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'F-Modul_not_used' (Gsd = ID_FMod_NotUsed)."                              ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HW_Input_24_Words zero."                                                                                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(736, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'Input_24_Words' (Gsd = ID_InMod_24Words)."                               ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(740, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HW_Output_21_Words is zero."                                                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(741, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(742, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(743, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(744, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(745, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(746, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'Output_21_Words' ( GsdId = ID_OutMod_21Words)."                          ,"Check the hardware configuration.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(1400, new AxoMessengerTextItem("Input variable `RunCommand` has NULL reference in `Run` method!"                                                                                                          ,"Check the call of the `RunCommand` method, if the `Parameters` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(2000, new AxoMessengerTextItem("Run command finished with error!"                                                                                                                                         ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(2001, new AxoMessengerTextItem("Run command was aborted, while not yet completed!"                                                                                                                        ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(2010, new AxoMessengerTextItem("Get results finished with error!"                                                                                                                                         ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(2011, new AxoMessengerTextItem("Get results was aborted, while not yet completed!"                                                                                                                        ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(2020, new AxoMessengerTextItem("Export curve finished with error!"                                                                                                                                        ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(2021, new AxoMessengerTextItem("Export curve was aborted, while not yet completed!"                                                                                                                       ,"Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Handle` to be the same as the value of the ``Outputs.Handle`.",                                   "Check the value of the Inputs.Handle signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001,new AxoMessengerTextItem( "No function or invalid input","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10205,new AxoMessengerTextItem("Invalid character given within alphanumeric customID","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10206,new AxoMessengerTextItem("Invalid entry","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10207,new AxoMessengerTextItem("Invalid data type","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10208,new AxoMessengerTextItem("Variable index exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10209,new AxoMessengerTextItem("Value too small","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10210,new AxoMessengerTextItem("Value too large","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10211, new AxoMessengerTextItem("Value is invalid", "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(20101, new AxoMessengerTextItem("Command active, command transition not permitted","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(31007, new AxoMessengerTextItem("No available space left on IPC (PR21)","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40101,new AxoMessengerTextItem("Clear Error Command not possible","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40201,new AxoMessengerTextItem("Reading of SMC variables not possible","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40301,new AxoMessengerTextItem("Positioning command cannot be started","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40302,new AxoMessengerTextItem("Error in the processing of the stop command","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40303,new AxoMessengerTextItem("Target position was not reached","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40304,new AxoMessengerTextItem("Manual positioning command: Force limit exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40401,new AxoMessengerTextItem("Reading of motor feedback memory not possible","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40501,new AxoMessengerTextItem("Reboot of drive not possible","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40601,new AxoMessengerTextItem("Homing could not be started","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40602,new AxoMessengerTextItem("Referencing under load not possible","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40701,new AxoMessengerTextItem("Could not activate program","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40702,new AxoMessengerTextItem("Timeout while program will be activated","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40703,new AxoMessengerTextItem("Timeout after program is activated","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40801,new AxoMessengerTextItem("Could not write SMC variable","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40901,new AxoMessengerTextItem("Transition Error Parameter Mode <> Operation Mode","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41001,new AxoMessengerTextItem("Could not start program","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41002,new AxoMessengerTextItem("Could not stop program","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41003,new AxoMessengerTextItem("Program error: Max. position exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41004,new AxoMessengerTextItem("Program error: Max. force exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41005,new AxoMessengerTextItem("Program error: Cancelled manually","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41006,new AxoMessengerTextItem("Program error: Abort due to drive error","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41007,new AxoMessengerTextItem("Program error: Could not write Y-Parameter","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41008,new AxoMessengerTextItem("Program error: Timeout exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41009,new AxoMessengerTextItem("Program error: Safety active","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41010,new AxoMessengerTextItem("Program error: Out of target window, force too low","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41011,new AxoMessengerTextItem("Program error: Out of target window, force exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41012,new AxoMessengerTextItem("Program error: Out of target window, invalid force evaluation","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41013,new AxoMessengerTextItem("Program error: Out of target window, position too low","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41014,new AxoMessengerTextItem("Program error: Out of target window, force and position too low","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41015,new AxoMessengerTextItem("Program error: Out of target window, force exceeded, position too low","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41016,new AxoMessengerTextItem("Program error: Out of target window, invalid force evaluation, position too low","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41017,new AxoMessengerTextItem("Program error: Out of target window, position exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41018,new AxoMessengerTextItem("Program error: Out of target window, force too low, position exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41019,new AxoMessengerTextItem("Program error: Out of target window, force and position exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41020,new AxoMessengerTextItem("Program error: Out of target window, invalid force evaluation, position exceeded","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41021,new AxoMessengerTextItem("Program error: Out of target window, invalid position evaluation","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41022,new AxoMessengerTextItem("Program error: Out of target window, force too low, invalid position evaluation","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41023,new AxoMessengerTextItem("Program error: Out of target window, force exceeded, invalid position evaluation","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41024,new AxoMessengerTextItem("Program error: Out of target window, invalid force and position evaluation","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41101,new AxoMessengerTextItem("S- or P-parameter could not be read","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41201,new AxoMessengerTextItem("S- or P-parameter could not be written","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41301,new AxoMessengerTextItem("Could not load Y-Parameter file","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41401,new AxoMessengerTextItem("Tare not possible","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41501,new AxoMessengerTextItem("Basic parameter loading not possible at drive commissioning","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41601,new AxoMessengerTextItem("Absolute dimension could not be set","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41701,new AxoMessengerTextItem("Could not read Y-Parameter","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(41801,new AxoMessengerTextItem("Could not write Y-Parameter","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(50001,new AxoMessengerTextItem("Character string too long, error while writing","")),
            };

            for (uint i = 30001; i <= 31901; i++)
            {
                if (i != 31007) messengerTextList.Add(new KeyValuePair<ulong, AxoMessengerTextItem>(i, new AxoMessengerTextItem("Internal error", "")));
            }

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoSmartFunctionKit_ComponentStatus : AXOpen.Components.Abstractions.AxoComponent_Status
    {
        Dictionary<ulong, string> errorDescriptionDict = new Dictionary<ulong, string>();
        Dictionary<ulong, string> actionDescriptionDict = new Dictionary<ulong, string>();

        public string ErrorDescription
        {
            get
            {
                if (errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<ulong, string>(); }
                if (errorDescriptionDict.Count == 0)
                {
                    errorDescriptionDict.Add(0, "   ");

                    //  General alarm
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                                                                               );
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!"                                                                                                                  );
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                                                    );
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HW_ParamCh_IDN is zero."                                                                                                                 );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                                                           );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                                                           );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                                                           );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                                                           );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                                                           );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'ParamCh_5Words' (GsdId=ID_PaCh_5Words)."                                 );
                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HW_F-Modul_not_used is zero."                                                                                                            );
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                                                           );
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                                                           );
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                                                           );
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                                                           );
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                                                           );
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'F-Modul_not_used' (Gsd = ID_FMod_NotUsed)."                              );
                    errorDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HW_Input_24_Words zero."                                                                                                                 );
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."                                                           );
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."                                                           );
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."                                                           );
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."                                                           );
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."                                                           );
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'Input_24_Words' (Gsd = ID_InMod_24Words)."                               );
                    errorDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HW_Output_21_Words is zero."                                                                                                             );
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."                                                           );
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."                                                           );
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."                                                           );
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."                                                           );
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."                                                           );
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'Output_21_Words' ( GsdId = ID_OutMod_21Words)."                          );
                    errorDescriptionDict.Add(1400, "Input variable `RunCommand` has NULL reference in `Run` method!"                                                                                                          );
                    errorDescriptionDict.Add(2000, "Run command finished with error!"                                                                                                                                         );
                    errorDescriptionDict.Add(2001, "Run command was aborted, while not yet completed!"                                                                                                                        );
                    errorDescriptionDict.Add(2010, "Get results finished with error!"                                                                                                                                         );
                    errorDescriptionDict.Add(2011, "Get results was aborted, while not yet completed!"                                                                                                                        );
                    errorDescriptionDict.Add(2020, "Export curve finished with error!"                                                                                                                                        );
                    errorDescriptionDict.Add(2021, "Export curve was aborted, while not yet completed!");


                    errorDescriptionDict.Add(10001, "No function or invalid input");
                    errorDescriptionDict.Add(10205,"Invalid character given within alphanumeric customID");
                    errorDescriptionDict.Add(10206,"Invalid entry");
                    errorDescriptionDict.Add(10207,"Invalid data type");
                    errorDescriptionDict.Add(10208,"Variable index exceeded");
                    errorDescriptionDict.Add(10209,"Value too small");
                    errorDescriptionDict.Add(10210,"Value too large");
                    errorDescriptionDict.Add(10211,"Value is invalid");
                    errorDescriptionDict.Add(20101,"Command active, command transition not permitted");
                    for (uint i = 30001; i <= 31901; i++)
                    {
                        if(i!=31007) errorDescriptionDict.Add(i, "Internal error");
                    }

                    errorDescriptionDict.Add(31007,"No available space left on IPC (PR21)");
                    errorDescriptionDict.Add(40101,"Clear Error Command not possible");
                    errorDescriptionDict.Add(40201,"Reading of SMC variables not possible");
                    errorDescriptionDict.Add(40301,"Positioning command cannot be started");
                    errorDescriptionDict.Add(40302,"Error in the processing of the stop command");
                    errorDescriptionDict.Add(40303,"Target position was not reached");
                    errorDescriptionDict.Add(40304,"Manual positioning command: Force limit exceeded");
                    errorDescriptionDict.Add(40401,"Reading of motor feedback memory not possible");
                    errorDescriptionDict.Add(40501,"Reboot of drive not possible");
                    errorDescriptionDict.Add(40601,"Homing could not be started");
                    errorDescriptionDict.Add(40602,"Referencing under load not possible");
                    errorDescriptionDict.Add(40701,"Could not activate program");
                    errorDescriptionDict.Add(40702,"Timeout while program will be activated");
                    errorDescriptionDict.Add(40703,"Timeout after program is activated");
                    errorDescriptionDict.Add(40801,"Could not write SMC variable");
                    errorDescriptionDict.Add(40901,"Transition Error Parameter Mode <> Operation Mode");
                    errorDescriptionDict.Add(41001,"Could not start program");
                    errorDescriptionDict.Add(41002,"Could not stop program");
                    errorDescriptionDict.Add(41003,"Program error: Max. position exceeded");
                    errorDescriptionDict.Add(41004,"Program error: Max. force exceeded");
                    errorDescriptionDict.Add(41005,"Program error: Cancelled manually");
                    errorDescriptionDict.Add(41006,"Program error: Abort due to drive error");
                    errorDescriptionDict.Add(41007,"Program error: Could not write Y-Parameter");
                    errorDescriptionDict.Add(41008,"Program error: Timeout exceeded");
                    errorDescriptionDict.Add(41009,"Program error: Safety active");
                    errorDescriptionDict.Add(41010,"Program error: Out of target window, force too low");
                    errorDescriptionDict.Add(41011,"Program error: Out of target window, force exceeded");
                    errorDescriptionDict.Add(41012,"Program error: Out of target window, invalid force evaluation");
                    errorDescriptionDict.Add(41013,"Program error: Out of target window, position too low");
                    errorDescriptionDict.Add(41014,"Program error: Out of target window, force and position too low");
                    errorDescriptionDict.Add(41015,"Program error: Out of target window, force exceeded, position too low");
                    errorDescriptionDict.Add(41016,"Program error: Out of target window, invalid force evaluation, position too low");
                    errorDescriptionDict.Add(41017,"Program error: Out of target window, position exceeded");
                    errorDescriptionDict.Add(41018,"Program error: Out of target window, force too low, position exceeded");
                    errorDescriptionDict.Add(41019,"Program error: Out of target window, force and position exceeded");
                    errorDescriptionDict.Add(41020,"Program error: Out of target window, invalid force evaluation, position exceeded");
                    errorDescriptionDict.Add(41021,"Program error: Out of target window, invalid position evaluation");
                    errorDescriptionDict.Add(41022,"Program error: Out of target window, force too low, invalid position evaluation");
                    errorDescriptionDict.Add(41023,"Program error: Out of target window, force exceeded, invalid position evaluation");
                    errorDescriptionDict.Add(41024,"Program error: Out of target window, invalid force and position evaluation");
                    errorDescriptionDict.Add(41101,"S- or P-parameter could not be read");
                    errorDescriptionDict.Add(41201,"S- or P-parameter could not be written");
                    errorDescriptionDict.Add(41301,"Could not load Y-Parameter file");
                    errorDescriptionDict.Add(41401,"Tare not possible");
                    errorDescriptionDict.Add(41501,"Basic parameter loading not possible at drive commissioning");
                    errorDescriptionDict.Add(41601,"Absolute dimension could not be set");
                    errorDescriptionDict.Add(41701,"Could not read Y-Parameter");
                    errorDescriptionDict.Add(41801,"Could not write Y-Parameter");
                    errorDescriptionDict.Add(50001,"Character string too long, error while writing");


                }
                string errorDescription = "   ";

                if (Error == null || Error.Id == null)
                    return errorDescription;

                if (errorDescriptionDict.TryGetValue(Error.Id.Cyclic, out errorDescription))
                {
                    return errorDescription;
                }
                else

                {
                    return "   ";
                }
            }
        }

        public string ActionDescription
        {
            get
            {
                if (actionDescriptionDict == null) { actionDescriptionDict = new Dictionary<ulong, string>(); }
                if (actionDescriptionDict.Count == 0)
                {
                    actionDescriptionDict.Add(0, "   ");
                    actionDescriptionDict.Add(50,  "Restore has been executed.");
                    actionDescriptionDict.Add(100, "Run command started.");
                    actionDescriptionDict.Add(300, "Run command running.");
                    actionDescriptionDict.Add(301, "Run command running.");
                    actionDescriptionDict.Add(302, "Run command running.");
                    actionDescriptionDict.Add(303, "Run command running.");
                    actionDescriptionDict.Add(304, "Run command running.");
                    actionDescriptionDict.Add(305, "Run command running.");
                    actionDescriptionDict.Add(306, "Run command running.");
                    actionDescriptionDict.Add(307, "Run command running.");
                    actionDescriptionDict.Add(308, "Run command running.");
                    actionDescriptionDict.Add(309, "Run command running.");
                    actionDescriptionDict.Add(101, "Run command finished succesfully.");
                    actionDescriptionDict.Add(102, "Run command restored.");
                    actionDescriptionDict.Add(110, "Get results started.");
                    actionDescriptionDict.Add(111, "Get results finished succesfully.");
                    actionDescriptionDict.Add(112, "Get results restored.");
                    actionDescriptionDict.Add(120, "Export curve started.");
                    actionDescriptionDict.Add(121, "Export curve finished succesfully.");
                    actionDescriptionDict.Add(122, "Export curve restored.");


                }

                string actionDescription = "   ";

                if (Action == null || Action.Id == null)
                    return actionDescription;

                if (actionDescriptionDict.TryGetValue(Action.Id.Cyclic, out actionDescription))
                {
                    return actionDescription;
                }
                else
                {
                    return "   ";
                }

            }
        }
    }
}

