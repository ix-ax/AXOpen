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
                // TemplateTask_10steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("TemplateTask_10steps_1 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("TemplateTask_10steps_1 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("TemplateTask_10steps_1 restored.","")),
                // TemplateTask_10steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("TemplateTask_10steps_2 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("TemplateTask_10steps_2 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("TemplateTask_10steps_2 restored.","")),
                // TemplateTask_10steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("TemplateTask_10steps_3 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("TemplateTask_10steps_3 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("TemplateTask_10steps_3 restored.","")),
                // TemplateTask_10steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(130, new AxoMessengerTextItem("TemplateTask_10steps_4 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(131, new AxoMessengerTextItem("TemplateTask_10steps_4 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(132, new AxoMessengerTextItem("TemplateTask_10steps_4 restored.","")),
                // TemplateTask_10steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("TemplateTask_10steps_5 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("TemplateTask_10steps_5 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("TemplateTask_10steps_5 restored.","")),
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


                // TemplateTask_10steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("TemplateTask_10steps_1 finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("TemplateTask_10steps_1 was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("TemplateTask_10steps_2 finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("TemplateTask_10steps_2 was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("TemplateTask_10steps_3 finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("TemplateTask_10steps_3 was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(10030, new AxoMessengerTextItem("TemplateTask_10steps_4 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10031, new AxoMessengerTextItem("TemplateTask_10steps_4 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(10040, new AxoMessengerTextItem("TemplateTask_10steps_5 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10041, new AxoMessengerTextItem("TemplateTask_10steps_5 task was aborted, while not yet completed!","Check the details.")),
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
                // TemplateTask_10steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(504,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(505,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(506,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(507,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(508,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(509,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                // TemplateTask_10steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(517,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(518,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(519,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                // TemplateTask_10steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(525,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(526,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(527,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(528,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(529,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_10steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(536,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(537,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(538,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(539,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_10steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(545,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(547,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(548,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(549,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_10steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(552,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(553,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(554,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(555,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(556,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(557,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(558,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(559,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(560,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(561,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(562,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(563,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(564,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(565,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(566,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(567,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(568,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(569,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(570,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(571,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(572,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(573,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(574,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(575,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(576,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(577,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(578,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(579,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(580,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(581,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(582,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(583,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(584,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(585,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(586,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(587,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(588,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(589,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(590,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(591,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(592,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(593,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(594,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(595,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(596,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(597,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(598,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(599,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(603,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(604,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(605,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(606,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(607,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(608,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(609,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(613,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(614,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(615,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(616,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(617,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(618,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(619,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(620,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(621,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(622,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(623,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(624,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(625,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(626,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(627,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(628,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(629,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(630,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(631,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(632,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(633,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(634,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(635,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(636,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(637,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(638,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(639,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(640,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(641,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(642,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(643,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(644,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(645,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(646,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(647,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(648,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(649,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(650,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(651,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(652,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(653,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(654,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(655,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(656,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(657,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(658,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(659,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(660,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(661,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(662,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(663,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(664,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(665,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(666,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(667,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(668,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(669,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(670,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(671,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(672,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(673,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(674,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(675,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(676,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(677,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(678,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(679,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),



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
                    // TemplateTask_10steps_1
                    errorDescriptionDict.Add(500, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(501, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(502, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(503, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(504, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(505, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(506, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(507, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(508, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(509, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_10steps_2
                    errorDescriptionDict.Add(510, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(511, "Waiting for the signal `Inputs.Status.WorkSensor` to be reseted!");
                    errorDescriptionDict.Add(512, "Waiting for the signal `Inputs.Status.HomeSensor` to be set!");
                    errorDescriptionDict.Add(513, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(514, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(515, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(516, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(517, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(518, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(519, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_10steps_3
                    errorDescriptionDict.Add(520, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(521, "Waiting for the signal `Inputs.Status.HomeSensor` to be reseted!");
                    errorDescriptionDict.Add(522, "Waiting for the signal `Inputs.Status.WorkSensor` to be set!");
                    errorDescriptionDict.Add(523, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(524, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(525, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(526, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(527, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(528, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(529, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_10steps_4
                    errorDescriptionDict.Add(530, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(531, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(532, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(533, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(534, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(535, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(536, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(537, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(538, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(539, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_10steps_5
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
                    // TemplateTask_10steps_6
                    errorDescriptionDict.Add(550, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(551, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(552, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(553, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(554, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(555, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(556, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(557, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(558, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(559, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_1
                    errorDescriptionDict.Add(560, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(561, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(562, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(563, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(564, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(565, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(566, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(567, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(568, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(569, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(570, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(571, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(572, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(573, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(574, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(575, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(576, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(577, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(578, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(579, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_2
                    errorDescriptionDict.Add(580, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(581, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(582, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(583, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(584, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(585, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(586, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(587, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(588, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(589, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(590, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(591, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(592, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(593, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(594, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(595, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(596, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(597, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(598, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(599, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_3
                    errorDescriptionDict.Add(600, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(601, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(602, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(603, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(604, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(605, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(606, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(607, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(608, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(609, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(610, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(611, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(612, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(613, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(614, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(615, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(616, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(617, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(618, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(619, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_4
                    errorDescriptionDict.Add(620, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(621, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(622, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(623, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(624, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(625, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(626, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(627, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(628, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(629, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(630, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(631, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(632, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(633, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(634, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(635, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(636, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(637, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(638, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(639, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_5
                    errorDescriptionDict.Add(640, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(641, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(642, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(643, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(644, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(645, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(646, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(647, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(648, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(649, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(650, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(651, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(652, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(653, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(654, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(655, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(656, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(657, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(658, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(659, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_6
                    errorDescriptionDict.Add(660, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(661, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(662, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(663, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(664, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(665, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(666, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(667, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(668, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(669, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(670, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(671, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(672, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(673, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(674, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(675, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(676, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(677, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(678, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(679, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
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
                    // TemplateTask_10steps_1
                    errorDescriptionDict.Add(10000, "TemplateTask_10steps_1 finished with error!");
                    errorDescriptionDict.Add(10001, "TemplateTask_10steps_1 was aborted, while not yet completed!");
                    // TemplateTask_10steps_2
                    errorDescriptionDict.Add(10010, "TemplateTask_10steps_2 finished with error!");
                    errorDescriptionDict.Add(10011, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    // TemplateTask_10steps_3
                    errorDescriptionDict.Add(10020, "TemplateTask_10steps_3 finished with error!");
                    errorDescriptionDict.Add(10021, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    // TemplateTask_10steps_4
                    errorDescriptionDict.Add(10030, "TemplateTask_10steps_4 task finished with error!");
                    errorDescriptionDict.Add(10031, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_5
                    errorDescriptionDict.Add(10040, "TemplateTask_10steps_5 task finished with error!");
                    errorDescriptionDict.Add(10041, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
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
                    // TemplateTask_10steps_1
                    actionDescriptionDict.Add(100, "TemplateTask_10steps_1 started.");
                    actionDescriptionDict.Add(300, "TemplateTask_10steps_1 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(301, "TemplateTask_10steps_1 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(302, "TemplateTask_10steps_1 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(303, "TemplateTask_10steps_1 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(304, "TemplateTask_10steps_1 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(305, "TemplateTask_10steps_1 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(306, "TemplateTask_10steps_1 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(307, "TemplateTask_10steps_1 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(308, "TemplateTask_10steps_1 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(309, "TemplateTask_10steps_1 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(101, "TemplateTask_10steps_1 finished succesfully.");
                    actionDescriptionDict.Add(102, "TemplateTask_10steps_1 restored.");
                    // TemplateTask_10steps_2
                    actionDescriptionDict.Add(110, "TemplateTask_10steps_2 started.");
                    actionDescriptionDict.Add(310, "TemplateTask_10steps_2 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(311, "TemplateTask_10steps_2 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(312, "TemplateTask_10steps_2 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(313, "TemplateTask_10steps_2 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(314, "TemplateTask_10steps_2 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(315, "TemplateTask_10steps_2 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(316, "TemplateTask_10steps_2 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(317, "TemplateTask_10steps_2 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(318, "TemplateTask_10steps_2 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(319, "TemplateTask_10steps_2 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(111, "TemplateTask_10steps_2 finished succesfully.");
                    actionDescriptionDict.Add(112, "TemplateTask_10steps_2 restored.");
                    // TemplateTask_10steps_3
                    actionDescriptionDict.Add(120, "TemplateTask_10steps_3 started.");
                    actionDescriptionDict.Add(320, "TemplateTask_10steps_3 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(321, "TemplateTask_10steps_3 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(322, "TemplateTask_10steps_3 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(323, "TemplateTask_10steps_3 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(324, "TemplateTask_10steps_3 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(325, "TemplateTask_10steps_3 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(326, "TemplateTask_10steps_3 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(327, "TemplateTask_10steps_3 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(328, "TemplateTask_10steps_3 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(329, "TemplateTask_10steps_3 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(121, "TemplateTask_10steps_3 finished succesfully.");
                    actionDescriptionDict.Add(122, "TemplateTask_10steps_3 restored.");
                    // TemplateTask_10steps_4
                    actionDescriptionDict.Add(130, "TemplateTask_10steps_4 started.");
                    actionDescriptionDict.Add(330, "TemplateTask_10steps_4 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(331, "TemplateTask_10steps_4 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(332, "TemplateTask_10steps_4 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(333, "TemplateTask_10steps_4 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(334, "TemplateTask_10steps_4 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(335, "TemplateTask_10steps_4 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(336, "TemplateTask_10steps_4 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(337, "TemplateTask_10steps_4 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(338, "TemplateTask_10steps_4 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(339, "TemplateTask_10steps_4 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(131, "TemplateTask_10steps_4 finished succesfully.");
                    actionDescriptionDict.Add(132, "TemplateTask_10steps_4 restored.");
                    // TemplateTask_10steps_5
                    actionDescriptionDict.Add(140, "TemplateTask_10steps_5 started.");
                    actionDescriptionDict.Add(340, "TemplateTask_10steps_5 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(341, "TemplateTask_10steps_5 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(342, "TemplateTask_10steps_5 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(343, "TemplateTask_10steps_5 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(344, "TemplateTask_10steps_5 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(345, "TemplateTask_10steps_5 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(346, "TemplateTask_10steps_5 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(347, "TemplateTask_10steps_5 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(348, "TemplateTask_10steps_5 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(349, "TemplateTask_10steps_5 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(141, "TemplateTask_10steps_5 finished succesfully.");
                    actionDescriptionDict.Add(142, "TemplateTask_10steps_5 restored.");
                    // TemplateTask_10steps_6
                    actionDescriptionDict.Add(150, "TemplateTask_10steps_6 started.");
                    actionDescriptionDict.Add(350, "TemplateTask_10steps_6 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(351, "TemplateTask_10steps_6 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(352, "TemplateTask_10steps_6 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(353, "TemplateTask_10steps_6 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(354, "TemplateTask_10steps_6 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(355, "TemplateTask_10steps_6 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(356, "TemplateTask_10steps_6 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(357, "TemplateTask_10steps_6 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(358, "TemplateTask_10steps_6 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(359, "TemplateTask_10steps_6 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(151, "TemplateTask_10steps_6 finished succesfully.");
                    actionDescriptionDict.Add(152, "TemplateTask_10steps_6 restored.");

                    // TemplateTask_20steps_1
                    actionDescriptionDict.Add(160, "TemplateTask_20steps_1 started.");
                    actionDescriptionDict.Add(360, "TemplateTask_20steps_1 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(361, "TemplateTask_20steps_1 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(362, "TemplateTask_20steps_1 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(363, "TemplateTask_20steps_1 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(364, "TemplateTask_20steps_1 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(365, "TemplateTask_20steps_1 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(366, "TemplateTask_20steps_1 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(367, "TemplateTask_20steps_1 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(368, "TemplateTask_20steps_1 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(369, "TemplateTask_20steps_1 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(370, "TemplateTask_20steps_1 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(371, "TemplateTask_20steps_1 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(372, "TemplateTask_20steps_1 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(373, "TemplateTask_20steps_1 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(374, "TemplateTask_20steps_1 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(375, "TemplateTask_20steps_1 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(376, "TemplateTask_20steps_1 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(377, "TemplateTask_20steps_1 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(378, "TemplateTask_20steps_1 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(379, "TemplateTask_20steps_1 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(161, "TemplateTask_20steps_1 finished succesfully.");
                    actionDescriptionDict.Add(162, "TemplateTask_20steps_1 restored.");
                    // TemplateTask_20steps_2
                    actionDescriptionDict.Add(180, "TemplateTask_20steps_2 started.");
                    actionDescriptionDict.Add(380, "TemplateTask_20steps_2 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(381, "TemplateTask_20steps_2 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(382, "TemplateTask_20steps_2 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(383, "TemplateTask_20steps_2 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(384, "TemplateTask_20steps_2 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(385, "TemplateTask_20steps_2 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(386, "TemplateTask_20steps_2 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(387, "TemplateTask_20steps_2 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(388, "TemplateTask_20steps_2 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(389, "TemplateTask_20steps_2 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(390, "TemplateTask_20steps_2 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(391, "TemplateTask_20steps_2 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(392, "TemplateTask_20steps_2 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(393, "TemplateTask_20steps_2 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(394, "TemplateTask_20steps_2 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(395, "TemplateTask_20steps_2 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(396, "TemplateTask_20steps_2 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(397, "TemplateTask_20steps_2 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(398, "TemplateTask_20steps_2 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(399, "TemplateTask_20steps_2 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(181, "TemplateTask_20steps_2 finished succesfully.");
                    actionDescriptionDict.Add(182, "TemplateTask_20steps_2 restored.");
                    // TemplateTask_20steps_3
                    actionDescriptionDict.Add(200, "TemplateTask_20steps_3 started.");
                    actionDescriptionDict.Add(400, "TemplateTask_20steps_3 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(401, "TemplateTask_20steps_3 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(402, "TemplateTask_20steps_3 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(403, "TemplateTask_20steps_3 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(404, "TemplateTask_20steps_3 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(405, "TemplateTask_20steps_3 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(406, "TemplateTask_20steps_3 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(407, "TemplateTask_20steps_3 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(408, "TemplateTask_20steps_3 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(409, "TemplateTask_20steps_3 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(410, "TemplateTask_20steps_3 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(411, "TemplateTask_20steps_3 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(412, "TemplateTask_20steps_3 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(413, "TemplateTask_20steps_3 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(414, "TemplateTask_20steps_3 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(415, "TemplateTask_20steps_3 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(416, "TemplateTask_20steps_3 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(417, "TemplateTask_20steps_3 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(418, "TemplateTask_20steps_3 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(419, "TemplateTask_20steps_3 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(201, "TemplateTask_20steps_3 finished succesfully.");
                    actionDescriptionDict.Add(202, "TemplateTask_20steps_3 restored.");
                    // TemplateTask_20steps_4
                    actionDescriptionDict.Add(220, "TemplateTask_20steps_4 started.");
                    actionDescriptionDict.Add(420, "TemplateTask_20steps_4 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(421, "TemplateTask_20steps_4 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(422, "TemplateTask_20steps_4 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(423, "TemplateTask_20steps_4 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(424, "TemplateTask_20steps_4 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(425, "TemplateTask_20steps_4 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(426, "TemplateTask_20steps_4 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(427, "TemplateTask_20steps_4 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(428, "TemplateTask_20steps_4 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(429, "TemplateTask_20steps_4 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(430, "TemplateTask_20steps_4 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(431, "TemplateTask_20steps_4 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(432, "TemplateTask_20steps_4 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(433, "TemplateTask_20steps_4 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(434, "TemplateTask_20steps_4 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(435, "TemplateTask_20steps_4 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(436, "TemplateTask_20steps_4 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(437, "TemplateTask_20steps_4 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(438, "TemplateTask_20steps_4 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(439, "TemplateTask_20steps_4 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(221, "TemplateTask_20steps_4 finished succesfully.");
                    actionDescriptionDict.Add(222, "TemplateTask_20steps_4 restored.");
                    // TemplateTask_20steps_5
                    actionDescriptionDict.Add(240, "TemplateTask_20steps_5 started.");
                    actionDescriptionDict.Add(440, "TemplateTask_20steps_5 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(441, "TemplateTask_20steps_5 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(442, "TemplateTask_20steps_5 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(443, "TemplateTask_20steps_5 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(444, "TemplateTask_20steps_5 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(445, "TemplateTask_20steps_5 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(446, "TemplateTask_20steps_5 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(447, "TemplateTask_20steps_5 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(448, "TemplateTask_20steps_5 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(449, "TemplateTask_20steps_5 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(450, "TemplateTask_20steps_5 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(451, "TemplateTask_20steps_5 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(452, "TemplateTask_20steps_5 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(453, "TemplateTask_20steps_5 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(454, "TemplateTask_20steps_5 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(455, "TemplateTask_20steps_5 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(456, "TemplateTask_20steps_5 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(457, "TemplateTask_20steps_5 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(458, "TemplateTask_20steps_5 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(459, "TemplateTask_20steps_5 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(241, "TemplateTask_20steps_5 finished succesfully.");
                    actionDescriptionDict.Add(242, "TemplateTask_20steps_5 restored.");
                    // TemplateTask_20steps_6
                    actionDescriptionDict.Add(260, "TemplateTask_20steps_6 started.");
                    actionDescriptionDict.Add(460, "TemplateTask_20steps_6 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(461, "TemplateTask_20steps_6 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(462, "TemplateTask_20steps_6 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(463, "TemplateTask_20steps_6 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(464, "TemplateTask_20steps_6 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(465, "TemplateTask_20steps_6 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(466, "TemplateTask_20steps_6 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(467, "TemplateTask_20steps_6 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(468, "TemplateTask_20steps_6 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(469, "TemplateTask_20steps_6 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(470, "TemplateTask_20steps_6 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(471, "TemplateTask_20steps_6 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(472, "TemplateTask_20steps_6 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(473, "TemplateTask_20steps_6 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(474, "TemplateTask_20steps_6 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(475, "TemplateTask_20steps_6 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(476, "TemplateTask_20steps_6 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(477, "TemplateTask_20steps_6 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(478, "TemplateTask_20steps_6 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(479, "TemplateTask_20steps_6 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(261, "TemplateTask_20steps_6 finished succesfully.");
                    actionDescriptionDict.Add(262, "TemplateTask_20steps_6 restored.");
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
                    // TemplateTask_10steps_1
                    actionDescriptionDict.Add(10000, "TemplateTask_10steps_1 finished with error!");
                    actionDescriptionDict.Add(10001, "TemplateTask_10steps_1 was aborted, while not yet completed!");
                    // TemplateTask_10steps_2
                    actionDescriptionDict.Add(10010, "TemplateTask_10steps_2 finished with error!");
                    actionDescriptionDict.Add(10011, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    // TemplateTask_10steps_3
                    actionDescriptionDict.Add(10020, "TemplateTask_10steps_3 finished with error!");
                    actionDescriptionDict.Add(10021, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    // TemplateTask_10steps_4
                    actionDescriptionDict.Add(10030, "TemplateTask_10steps_4 task finished with error!");
                    actionDescriptionDict.Add(10031, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_5
                    actionDescriptionDict.Add(10040, "TemplateTask_10steps_5 task finished with error!");
                    actionDescriptionDict.Add(10041, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
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
