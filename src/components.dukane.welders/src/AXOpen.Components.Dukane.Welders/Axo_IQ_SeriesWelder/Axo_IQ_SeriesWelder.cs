using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Dukane.Welders
{
    public partial class Axo_IQ_SeriesWelder
    {
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            try
            {
                InitializeMessenger();
                InitializeTaskMessenger();
            }
            catch (Exception)
            {

                throw;
            }
        }
        private void InitializeMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,   new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.","")),
                // ClearErrorTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("ClearErrorTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("ClearErrorTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("ClearErrorTask restored.","")),
                // ChangeWeldingSetupTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("ChangeWeldingSetupTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("ChangeWeldingSetupTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("ChangeWeldingSetupTask restored.","")),
                // ChangeWeldingProbeTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("ChangeWeldingProbeTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("ChangeWeldingProbeTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("ChangeWeldingProbeTask restored.","")),
                // CycleStopTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(130, new AxoMessengerTextItem("CycleStopTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(131, new AxoMessengerTextItem("CycleStopTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(132, new AxoMessengerTextItem("CycleStopTask restored.","")),
                // RunWeldingWithTimeTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("RunWeldingWithTimeTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("RunWeldingWithTimeTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("RunWeldingWithTimeTask restored.","")),
                // TemplateTask_10steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("TemplateTask_10steps_6 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("TemplateTask_10steps_6 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("TemplateTask_10steps_6 restored.","")),
                // TemplateTask_20steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(160, new AxoMessengerTextItem("TemplateTask_20steps_1 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(161, new AxoMessengerTextItem("TemplateTask_20steps_1 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(162, new AxoMessengerTextItem("TemplateTask_20steps_1 restored.","")),
                // TemplateTask_20steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(180, new AxoMessengerTextItem("TemplateTask_20steps_2 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(181, new AxoMessengerTextItem("TemplateTask_20steps_2 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(182, new AxoMessengerTextItem("TemplateTask_20steps_2 restored.","")),
                // TemplateTask_20steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(200, new AxoMessengerTextItem("TemplateTask_20steps_3 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(201, new AxoMessengerTextItem("TemplateTask_20steps_3 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(202, new AxoMessengerTextItem("TemplateTask_20steps_3 restored.","")),
                // TemplateTask_20steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(220, new AxoMessengerTextItem("TemplateTask_20steps_4 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(221, new AxoMessengerTextItem("TemplateTask_20steps_4 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(222, new AxoMessengerTextItem("TemplateTask_20steps_4 restored.","")),
                // TemplateTask_20steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(240, new AxoMessengerTextItem("TemplateTask_20steps_5 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(241, new AxoMessengerTextItem("TemplateTask_20steps_5 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(242, new AxoMessengerTextItem("TemplateTask_20steps_5 restored.","")),
                // TemplateTask_20steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(260, new AxoMessengerTextItem("TemplateTask_20steps_6 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(261, new AxoMessengerTextItem("TemplateTask_20steps_6 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(262, new AxoMessengerTextItem("TemplateTask_20steps_6 restored.","")),
                //  General alarms
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_iQ_to_PLC_Inputs is zero."                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'ID_MODULE_INPUT'."           ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(910, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_PLC_to_iQ_Outputs is zero."                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(911, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(912, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(913, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(914, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(915, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(916, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'ID_MODULE_OUTPUT'."          ,"Check the hardware configuration.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                  ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_iQ_to_PLC_Inputs` has invalid value in `Run` method!"                                       ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_iQ_to_PLC_Inputs` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1152, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_PLC_to_iQ_Outputs` has invalid value in `Run` method!"                                      ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_PLC_to_iQ_Outputs` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_iQ_to_PLC_Inputs!"                                                     ,"Check the value of the Config.HWIDs.HwID_iQ_to_PLC_Inputs and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_PLC_to_iQ_Outputs!"                                                   ,"Check the value of the Config.HWIDs.HwID_PLC_to_iQ_Outputs and reacheability of the device!")),


                // ClearErrorTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("ClearErrorTask finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("ClearErrorTask was aborted, while not yet completed!","Check the details.")),
                // ChangeWeldingSetupTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("ChangeWeldingSetupTask finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("ChangeWeldingSetupTask was aborted, while not yet completed!","Check the details.")),
                // ChangeWeldingProbeTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("ChangeWeldingProbeTask finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("ChangeWeldingProbeTask was aborted, while not yet completed!","Check the details.")),
                // CycleStopTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10030, new AxoMessengerTextItem("CycleStopTask task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10031, new AxoMessengerTextItem("CycleStopTask task was aborted, while not yet completed!","Check the details.")),
                // RunWeldingWithTimeTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10040, new AxoMessengerTextItem("RunWeldingWithTimeTask task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10041, new AxoMessengerTextItem("RunWeldingWithTimeTask task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(10050, new AxoMessengerTextItem("TemplateTask_10steps_6 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10051, new AxoMessengerTextItem("TemplateTask_10steps_6 task was aborted, while not yet completed!","Check the details.")),

                // TemplateTask_20steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(10060, new AxoMessengerTextItem("TemplateTask_20steps_1 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10061, new AxoMessengerTextItem("TemplateTask_20steps_1 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(10080, new AxoMessengerTextItem("TemplateTask_20steps_2 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10081, new AxoMessengerTextItem("TemplateTask_20steps_2 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(10100, new AxoMessengerTextItem("TemplateTask_20steps_3 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10101, new AxoMessengerTextItem("TemplateTask_20steps_3 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(10120, new AxoMessengerTextItem("TemplateTask_20steps_4 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10121, new AxoMessengerTextItem("TemplateTask_20steps_4 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(10140, new AxoMessengerTextItem("TemplateTask_20steps_5 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10141, new AxoMessengerTextItem("TemplateTask_20steps_5 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(10160, new AxoMessengerTextItem("TemplateTask_20steps_6 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10161, new AxoMessengerTextItem("TemplateTask_20steps_6 task was aborted, while not yet completed!","Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                // ClearErrorTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal/variable Inputs.SystemStatus.Any_Fault` to be reseted !"                                   ,"Check the status of the `Inputs.SystemStatus.Any_Fault`  signal/variable.")),
                // ChangeWeldingSetupTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Invalid value of the required setup number!"                                                                      ,"Check the value of the required setup number variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.ActiveSetup` to be equal to 'Outputs.ActiveSetupSelection'!"              ,"Check the status of the `Inputs.ActiveSetup` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.RunningSetup` to be equal to 'Outputs.RunningSetupSelection'!"            ,"Check the status of the Inputs.RunningSetup`  signal/variable.")),
                // ChangeWeldingProbeTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Invalid value of the required probe number!"                                                                      ,"Check the value of the required probe number variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.RunningMPCProbe` to be equal to 'Outputs.RunningMPCProbeSelection' !"     ,"Check the status of the `Inputs.RunningMPCProbe`  signal/variable.")),
                //CycleStopTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.SystemStatus.InCycle` to be reseted !"                                    ,"Check the status of the `Inputs.SystemStatus.InCycle`  signal/variable.")),
                //RunWeldingWithTimeTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.SystemStatus.Any_Fault` to be reseted!"                                   ,"Check the status of the `Inputs.SystemStatus.Any_Fault`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.SystemStatus.Ready` to be set!"                                           ,"Check the status of the `Inputs.SystemStatus.Ready`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Invalid value of the required setup number!"                                                                      ,"Check the value of the required setup number variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.ActiveSetup` to be equal to 'Outputs.ActiveSetupSelection'!"              ,"Check the status of the `Inputs.ActiveSetup` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.RunningSetup` to be equal to 'Outputs.RunningSetupSelection'!"            ,"Check the status of the Inputs.RunningSetup`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(545,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.RunningMPCProbe` to be equal to 'Outputs.RunningMPCProbeSelection' !"     ,"Check the status of the `Inputs.RunningMPCProbe`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.SystemStatus.InCycle` to be set !"                                        ,"Check the status of the `Inputs.SystemStatus.InCycle` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(548,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.SystemStatus.InCycle` to be reseted !"                                    ,"Check the status of the `Inputs.SystemStatus.InCycle` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(549,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.SystemStatus.Ready` to be set!"                                           ,"Check the status of the `Inputs.SystemStatus.Ready` signal/variable.")),
        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class Axo_IQ_SeriesWelder_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    // ClearErrorTask
                    errorDescriptionDict.Add(500, "Waiting for the signal/variable `Inputs.SystemStatus.Any_Fault` to be reseted !");
                    // ChangeWeldingSetupTask
                    errorDescriptionDict.Add(510, "Invalid value of the required setup number!");
                    errorDescriptionDict.Add(511, "Waiting for the signal/variable `Inputs.ActiveSetup` to be equal to 'Outputs.ActiveSetupSelection'!");
                    errorDescriptionDict.Add(512, "Waiting for the signal/variable `Inputs.RunningSetup` to be equal to 'Outputs.RunningSetupSelection'!");
                    // ChangeWeldingProbeTask
                    errorDescriptionDict.Add(520, "Invalid value of the required probe number!");
                    errorDescriptionDict.Add(521, "Waiting for the signal/variable `Inputs.RunningMPCProbe` to be equal to 'Outputs.RunningMPCProbeSelection' !");
                    // CycleStopTask
                    errorDescriptionDict.Add(530, "Waiting for the signal/variable `Inputs.SystemStatus.InCycle` to be reseted !");
                    // RunWeldingWithTimeTask
                    errorDescriptionDict.Add(540, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(541, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(542, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(543, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(544, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(545, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(546, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(547, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(548, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(549, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwID_iQ_to_PLC_Inputs is zero.");
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'ID_MODULE_INPUT'.");
                    errorDescriptionDict.Add(910, "Hw configuration error. Value of Config.HWIDs.HwID_PLC_to_iQ_Outputs is zero.");
                    errorDescriptionDict.Add(911, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    errorDescriptionDict.Add(912, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    errorDescriptionDict.Add(913, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    errorDescriptionDict.Add(914, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    errorDescriptionDict.Add(915, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    errorDescriptionDict.Add(916, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'ID_MODULE_OUTPUT'.");
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1132, "Variable `Config.HWIDs.HwID_iQ_to_PLC_Inputs` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1152, "Variable `Config.HWIDs.HwID_PLC_to_iQ_Outputs` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1201, "Error reading the TemplateComponentInputStructure_HwID_iQ_to_PLC_Inputs!");
                    errorDescriptionDict.Add(1231, "Error writing the TemplateComponentOutputStructure_HwID_PLC_to_iQ_Outputs!");
                    // ClearErrorTask
                    errorDescriptionDict.Add(10000, "ClearErrorTask finished with error!");
                    errorDescriptionDict.Add(10001, "ClearErrorTask was aborted, while not yet completed!");
                    // ChangeWeldingSetupTask
                    errorDescriptionDict.Add(10010, "ChangeWeldingSetupTask finished with error!");
                    errorDescriptionDict.Add(10011, "ChangeWeldingSetupTask was aborted, while not yet completed!");
                    // ChangeWeldingProbeTask
                    errorDescriptionDict.Add(10020, "ChangeWeldingProbeTask finished with error!");
                    errorDescriptionDict.Add(10021, "ChangeWeldingProbeTask was aborted, while not yet completed!");
                    // CycleStopTask
                    errorDescriptionDict.Add(10030, "CycleStopTask task finished with error!");
                    errorDescriptionDict.Add(10031, "CycleStopTask task was aborted, while not yet completed!");
                    // RunWeldingWithTimeTask
                    errorDescriptionDict.Add(10040, "RunWeldingWithTimeTask task finished with error!");
                    errorDescriptionDict.Add(10041, "RunWeldingWithTimeTask task was aborted, while not yet completed!");
                    // TemplateTask_10steps_6
                    errorDescriptionDict.Add(10050, "TemplateTask_10steps_6 task finished with error!");
                    errorDescriptionDict.Add(10051, "TemplateTask_10steps_6 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_1
                    errorDescriptionDict.Add(10060, "TemplateTask_20steps_1 task finished with error!");
                    errorDescriptionDict.Add(10061, "TemplateTask_20steps_1 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_2
                    errorDescriptionDict.Add(10080, "TemplateTask_20steps_2 task finished with error!");
                    errorDescriptionDict.Add(10081, "TemplateTask_20steps_2 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_3
                    errorDescriptionDict.Add(10100, "TemplateTask_20steps_3 task finished with error!");
                    errorDescriptionDict.Add(10101, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_4
                    errorDescriptionDict.Add(10120, "TemplateTask_20steps_4 task finished with error!");
                    errorDescriptionDict.Add(10121, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_5
                    errorDescriptionDict.Add(10140, "TemplateTask_20steps_5 task finished with error!");
                    errorDescriptionDict.Add(10141, "TemplateTask_20steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_6
                    errorDescriptionDict.Add(10160, "TemplateTask_20steps_6 task finished with error!");
                    errorDescriptionDict.Add(10161, "TemplateTask_20steps_6 task was aborted, while not yet completed!");

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
                    actionDescriptionDict.Add(50, "Restore has been executed.");
                    // ClearErrorTask
                    actionDescriptionDict.Add(100, "ClearErrorTask started.");
                    actionDescriptionDict.Add(300, "ClearErrorTask running: waiting for the error flag is reseted.");
                    actionDescriptionDict.Add(301, "ClearErrorTask finished.");
                    actionDescriptionDict.Add(101, "ClearErrorTask finished succesfully.");
                    actionDescriptionDict.Add(102, "ClearErrorTask restored.");
                    // ChangeWeldingSetupTask
                    actionDescriptionDict.Add(110, "ChangeWeldingSetupTask started.");
                    actionDescriptionDict.Add(310, "ChangeWeldingSetupTask running: validating required setup number.");
                    actionDescriptionDict.Add(311, "ChangeWeldingSetupTask running: changing active setup selected.");
                    actionDescriptionDict.Add(312, "ChangeWeldingSetupTask running: changing running setup selected.");
                    actionDescriptionDict.Add(313, "ChangeWeldingSetupTask finished.");
                    actionDescriptionDict.Add(111, "ChangeWeldingSetupTask finished succesfully.");
                    actionDescriptionDict.Add(112, "ChangeWeldingSetupTask restored.");
                    // ChangeWeldingProbeTask
                    actionDescriptionDict.Add(120, "ChangeWeldingProbeTask started.");
                    actionDescriptionDict.Add(320, "ChangeWeldingProbeTask running: validating required probe number.");
                    actionDescriptionDict.Add(321, "ChangeWeldingProbeTask running: changing running probe selected.");
                    actionDescriptionDict.Add(322, "ChangeWeldingProbeTask finished.");
                    actionDescriptionDict.Add(121, "ChangeWeldingProbeTask finished succesfully.");
                    actionDescriptionDict.Add(122, "ChangeWeldingProbeTask restored.");
                    // CycleStopTask
                    actionDescriptionDict.Add(130, "CycleStopTask started.");
                    actionDescriptionDict.Add(330, "CycleStopTask running: waiting for the cycle is finished.");
                    actionDescriptionDict.Add(331, "CycleStopTask finished.");
                    actionDescriptionDict.Add(131, "CycleStopTask finished succesfully.");
                    actionDescriptionDict.Add(132, "CycleStopTask restored.");
                    // RunWeldingWithTimeTask
                    actionDescriptionDict.Add(140, "RunWeldingWithTimeTask started.");
                    actionDescriptionDict.Add(340, "RunWeldingWithTimeTask running: reseting the error.");
                    actionDescriptionDict.Add(341, "RunWeldingWithTimeTask running: waiting for the system to be ready.");
                    actionDescriptionDict.Add(342, "RunWeldingWithTimeTask running: validating required setup number.");
                    actionDescriptionDict.Add(343, "RunWeldingWithTimeTask running: changing active setup selected.");
                    actionDescriptionDict.Add(344, "RunWeldingWithTimeTask running: changing running setup selected.");
                    actionDescriptionDict.Add(345, "RunWeldingWithTimeTask running: changing running probe selected.");
                    actionDescriptionDict.Add(346, "RunWeldingWithTimeTask running: starting the welding cycle.");
                    actionDescriptionDict.Add(347, "RunWeldingWithTimeTask running: welding cycle running.");
                    actionDescriptionDict.Add(348, "RunWeldingWithTimeTask running: stopping the welding cycle.");
                    actionDescriptionDict.Add(349, "RunWeldingWithTimeTask finished.");
                    actionDescriptionDict.Add(141, "RunWeldingWithTimeTask finished succesfully.");
                    actionDescriptionDict.Add(142, "RunWeldingWithTimeTask restored.");
                    // General alarms
                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    actionDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwID_iQ_to_PLC_Inputs is zero.");
                    actionDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    actionDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    actionDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    actionDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    actionDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    actionDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'ID_MODULE_INPUT'.");
                    actionDescriptionDict.Add(910, "Hw configuration error. Value of Config.HWIDs.HwID_PLC_to_iQ_Outputs is zero.");
                    actionDescriptionDict.Add(911, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    actionDescriptionDict.Add(912, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    actionDescriptionDict.Add(913, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    actionDescriptionDict.Add(914, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    actionDescriptionDict.Add(915, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    actionDescriptionDict.Add(916, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'ID_MODULE_OUTPUT'.");
                    actionDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(1131, "Input variable `hwId` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwID_iQ_to_PLC_Inputs` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1152, "Input variable `Config.HWIDs.HwID_PLC_to_iQ_Outputs` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1201, "Error reading the TemplateComponentInputStructureConfig.HWIDs.HwID_iQ_to_PLC_Inputs!");
                    actionDescriptionDict.Add(1231, "Error writing the TemplateComponentOutputStructureConfig.HWIDs.HwID_PLC_to_iQ_Outputs!");
                    // ClearErrorTask
                    actionDescriptionDict.Add(10000, "ClearErrorTask finished with error!");
                    actionDescriptionDict.Add(10001, "ClearErrorTask was aborted, while not yet completed!");
                    // ChangeWeldingSetupTask
                    actionDescriptionDict.Add(10010, "ChangeWeldingSetupTask finished with error!");
                    actionDescriptionDict.Add(10011, "ChangeWeldingSetupTask was aborted, while not yet completed!");
                    // ChangeWeldingProbeTask
                    actionDescriptionDict.Add(10020, "ChangeWeldingProbeTask finished with error!");
                    actionDescriptionDict.Add(10021, "ChangeWeldingProbeTask was aborted, while not yet completed!");
                    // CycleStopTask
                    actionDescriptionDict.Add(10030, "CycleStopTask task finished with error!");
                    actionDescriptionDict.Add(10031, "CycleStopTask task was aborted, while not yet completed!");
                    // RunWeldingWithTimeTask
                    actionDescriptionDict.Add(10040, "RunWeldingWithTimeTask task finished with error!");
                    actionDescriptionDict.Add(10041, "RunWeldingWithTimeTask task was aborted, while not yet completed!");
                    // TemplateTask_10steps_6
                    actionDescriptionDict.Add(10050, "TemplateTask_10steps_6 task finished with error!");
                    actionDescriptionDict.Add(10051, "TemplateTask_10steps_6 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_1
                    actionDescriptionDict.Add(10060, "TemplateTask_20steps_1 task finished with error!");
                    actionDescriptionDict.Add(10061, "TemplateTask_20steps_1 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_2
                    actionDescriptionDict.Add(10080, "TemplateTask_20steps_2 task finished with error!");
                    actionDescriptionDict.Add(10081, "TemplateTask_20steps_2 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_3
                    actionDescriptionDict.Add(10100, "TemplateTask_20steps_3 task finished with error!");
                    actionDescriptionDict.Add(10101, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_4
                    actionDescriptionDict.Add(10120, "TemplateTask_20steps_4 task finished with error!");
                    actionDescriptionDict.Add(10121, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_5
                    actionDescriptionDict.Add(10140, "TemplateTask_20steps_5 task finished with error!");
                    actionDescriptionDict.Add(10141, "TemplateTask_20steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_6
                    actionDescriptionDict.Add(10160, "TemplateTask_20steps_6 task finished with error!");
                    actionDescriptionDict.Add(10161, "TemplateTask_20steps_6 task was aborted, while not yet completed!");

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
