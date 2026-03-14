using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Io
{
    public partial class AxoIOLinkET200SP_Balluff_IO
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
                // ConfigTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("ConfigTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("ConfigTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("ConfigTask restored.","")),

                //  General alarms
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `inParent` has NULL reference in `Run` method!"                                                                 ,"Check the call of the `Run` method, if the `inParent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.Hwid` has invalid value in `Run` method!"                                                               ,"Check the call of the `Run` method, if the `Config.Hwid` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.Hwid is zero."                                                                         ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091)."                          ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094)."                          ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095)."                          ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096)."                          ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097)."                          ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected. Expected module: 'CM 4xIO-Link V2.2 32I/32O'."           ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the input structure of the 'CM 4xIO-Link V2.2 32I/32O' module!"                                                 ,"Check the value of the Config.Hwid and reacheability of the device!")),

                // ConfigTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("ConfigTask finished with error!"                                                                                             ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("ConfigTask was aborted, while not yet completed!"                                                                            ,"Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                // ConfigTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal/variable `_insert_name_` to be set/reseted!"                                                           ,"Check the status of the `_insert_name_`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(504,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(505,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(506,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(507,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(508,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(509,  new AxoMessengerTextItem("Waiting for the signal/variable `_readRecord.valid` to be set!"                                                               ,"Check the status of the `_readRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal/variable `_readRecord.valid` to be reseted!"                                                           ,"Check the status of the `_readRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Read value of the ISDU parameter Port 1 Index 55 does not match the written one!"                                             ,"")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal/variable `_insert_name_` to be set/reseted!"                                                           ,"Check the status of the `_insert_name_`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(517,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(518,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(519,  new AxoMessengerTextItem("Waiting for the signal/variable `_readRecord.valid` to be set!"                                                               ,"Check the status of the `_readRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal/variable `_readRecord.valid` to be reseted!"                                                           ,"Check the status of the `_readRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Read value of the ISDU parameter Port 2 Index 55 does not match the written one!"                                             ,"")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the signal/variable `_insert_name_` to be set/reseted!"                                                           ,"Check the status of the `_insert_name_`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(525,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(526,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(527,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(528,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(529,  new AxoMessengerTextItem("Waiting for the signal/variable `_readRecord.valid` to be set!"                                                               ,"Check the status of the `_readRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal/variable `_readRecord.valid` to be reseted!"                                                           ,"Check the status of the `_readRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Read value of the ISDU parameter Port 3 Index 55 does not match the written one!"                                             ,"")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal/variable `_insert_name_` to be set/reseted!"                                                           ,"Check the status of the `_insert_name_`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(536,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(537,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be set!"                                                               ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(538,  new AxoMessengerTextItem("Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                           ,"Check the status of the `_writeRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(539,  new AxoMessengerTextItem("Waiting for the signal/variable `_readRecord.valid` to be set!"                                                               ,"Check the status of the `_readRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal/variable `_readRecord.valid` to be reseted!"                                                           ,"Check the status of the `_readRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Read value of the ISDU parameter Port 4 Index 55 does not match the written one!"                                             ,"")),


        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoIOLinkET200SP_Balluff_IO_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    // ConfigTask
                    errorDescriptionDict.Add(500,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(501,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(502,  "Waiting for the signal/variable `_insert_name_` to be set/reseted!"                                                          );
                    errorDescriptionDict.Add(503,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(504,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(505,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(506,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(507,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(508,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(509,  "Waiting for the signal/variable `_readRecord.valid` to be set!"                                                              );
                    errorDescriptionDict.Add(510,  "Waiting for the signal/variable `_readRecord.valid` to be reseted!"                                                          );
                    errorDescriptionDict.Add(511,  "Read value of the ISDU parameter Port 1 Index 55 does not match the written one!"                                            );
                    errorDescriptionDict.Add(512,  "Waiting for the signal/variable `_insert_name_` to be set/reseted!"                                                          );
                    errorDescriptionDict.Add(513,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(514,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(515,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(516,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(517,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(518,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(519,  "Waiting for the signal/variable `_readRecord.valid` to be set!"                                                              );
                    errorDescriptionDict.Add(520,  "Waiting for the signal/variable `_readRecord.valid` to be reseted!"                                                          );
                    errorDescriptionDict.Add(521,  "Read value of the ISDU parameter Port 2 Index 55 does not match the written one!"                                            );
                    errorDescriptionDict.Add(522,  "Waiting for the signal/variable `_insert_name_` to be set/reseted!"                                                          );
                    errorDescriptionDict.Add(523,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(524,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(525,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(526,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(527,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(528,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(529,  "Waiting for the signal/variable `_readRecord.valid` to be set!"                                                              );
                    errorDescriptionDict.Add(530,  "Waiting for the signal/variable `_readRecord.valid` to be reseted!"                                                          );
                    errorDescriptionDict.Add(531,  "Read value of the ISDU parameter Port 3 Index 55 does not match the written one!"                                            );
                    errorDescriptionDict.Add(532,  "Waiting for the signal/variable `_insert_name_` to be set/reseted!"                                                          );
                    errorDescriptionDict.Add(533,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(534,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(535,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(536,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(537,  "Waiting for the signal/variable `_writeRecord.done` to be set!"                                                              );
                    errorDescriptionDict.Add(538,  "Waiting for the signal/variable `_writeRecord.done` to be reseted!"                                                          );
                    errorDescriptionDict.Add(539,  "Waiting for the signal/variable `_readRecord.valid` to be set!"                                                              );
                    errorDescriptionDict.Add(540,  "Waiting for the signal/variable `_readRecord.valid` to be reseted!");
                    errorDescriptionDict.Add(541, "Read value of the ISDU parameter Port 4 Index 55 does not match the written one!");


                //  General alarms
                    errorDescriptionDict.Add(700, "Input variable `inParent` has NULL reference in `Run` method!"                                                                 );
                    errorDescriptionDict.Add(701, "Input variable `Config.Hwid` has invalid value in `Run` method!"                                                               );
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        );
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.Hwid is zero."                                                                         );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091)."                          );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094)."                          );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095)."                          );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096)."                          );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097)."                          );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected. Expected module: 'CM 4xIO-Link V2.2 32I/32O'."           );
                    errorDescriptionDict.Add(1201,"Error reading the input structure of the 'CM 4xIO-Link V2.2 32I/32O' module!");
                    // ConfigTask
                    errorDescriptionDict.Add(10000, "ConfigTask finished with error!");
                    errorDescriptionDict.Add(10001, "ConfigTask was aborted, while not yet completed!");

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
                    // ConfigTask
                    actionDescriptionDict.Add(100, "ConfigTask started.");
                    actionDescriptionDict.Add(300, "ConfigTask running: datarecord 128 write running");
                    actionDescriptionDict.Add(301, "ConfigTask running: datarecord 128 write reset");
                    actionDescriptionDict.Add(302, "ConfigTask running: Port 1");
                    actionDescriptionDict.Add(303, "ConfigTask running: ISDU parameter write Port 1 Index 55 running");
                    actionDescriptionDict.Add(304, "ConfigTask running: ISDU parameter write Port 1 Index 55 reset");
                    actionDescriptionDict.Add(305, "ConfigTask running: ISDU parameter write Port 1 Index 2 running");
                    actionDescriptionDict.Add(306, "ConfigTask running: ISDU parameter write Port 1 Index 2 reset");
                    actionDescriptionDict.Add(307, "ConfigTask running: ISDU parameter write read request Port 1 Index 55 running");
                    actionDescriptionDict.Add(308, "ConfigTask running: ISDU parameter write read request Port 1 Index 55 reset");
                    actionDescriptionDict.Add(309, "ConfigTask running: ISDU parameter read Port 1 Index 55 running");
                    actionDescriptionDict.Add(310, "ConfigTask running: ISDU parameter read Port 1 Index 55 reset");
                    actionDescriptionDict.Add(311, "ConfigTask running: ISDU parameter Port 1 Index 55 compare");
                    actionDescriptionDict.Add(312, "ConfigTask running: Port 2");
                    actionDescriptionDict.Add(313, "ConfigTask running: ISDU parameter write Port 2 Index 55 running");
                    actionDescriptionDict.Add(314, "ConfigTask running: ISDU parameter write Port 2 Index 55 reset");
                    actionDescriptionDict.Add(315, "ConfigTask running: ISDU parameter write Port 2 Index 2 running");
                    actionDescriptionDict.Add(316, "ConfigTask running: ISDU parameter write Port 2 Index 2 reset");
                    actionDescriptionDict.Add(317, "ConfigTask running: ISDU parameter write read request Port 2 Index 55 running");
                    actionDescriptionDict.Add(318, "ConfigTask running: ISDU parameter write read request Port 2 Index 55 reset");
                    actionDescriptionDict.Add(319, "ConfigTask running: ISDU parameter read Port 2 Index 55 running");
                    actionDescriptionDict.Add(320, "ConfigTask running: ISDU parameter read Port 2 Index 55 reset");
                    actionDescriptionDict.Add(321, "ConfigTask running: ISDU parameter Port 2 Index 55 compare");
                    actionDescriptionDict.Add(322, "ConfigTask running: Port 3");
                    actionDescriptionDict.Add(323, "ConfigTask running: ISDU parameter write Port 3 Index 55 running");
                    actionDescriptionDict.Add(324, "ConfigTask running: ISDU parameter write Port 3 Index 55 reset");
                    actionDescriptionDict.Add(325, "ConfigTask running: ISDU parameter write Port 3 Index 2 running");
                    actionDescriptionDict.Add(326, "ConfigTask running: ISDU parameter write Port 3 Index 2 reset");
                    actionDescriptionDict.Add(327, "ConfigTask running: ISDU parameter write read request Port 3 Index 55 running");
                    actionDescriptionDict.Add(328, "ConfigTask running: ISDU parameter write read request Port 3 Index 55 reset");
                    actionDescriptionDict.Add(329, "ConfigTask running: ISDU parameter read Port 3 Index 55 running");
                    actionDescriptionDict.Add(330, "ConfigTask running: ISDU parameter read Port 3 Index 55 reset");
                    actionDescriptionDict.Add(331, "ConfigTask running: ISDU parameter Port 3 Index 55 compare");
                    actionDescriptionDict.Add(332, "ConfigTask running: Port 4");
                    actionDescriptionDict.Add(333, "ConfigTask running: ISDU parameter write Port 4 Index 55 running");
                    actionDescriptionDict.Add(334, "ConfigTask running: ISDU parameter write Port 4 Index 55 reset");
                    actionDescriptionDict.Add(335, "ConfigTask running: ISDU parameter write Port 4 Index 2 running");
                    actionDescriptionDict.Add(336, "ConfigTask running: ISDU parameter write Port 4 Index 2 reset");
                    actionDescriptionDict.Add(337, "ConfigTask running: ISDU parameter write read request Port 4 Index 55 running");
                    actionDescriptionDict.Add(338, "ConfigTask running: ISDU parameter write read request Port 4 Index 55 reset");
                    actionDescriptionDict.Add(339, "ConfigTask running: ISDU parameter read Port 4 Index 55 running");
                    actionDescriptionDict.Add(340, "ConfigTask running: ISDU parameter read Port 4 Index 55 reset");
                    actionDescriptionDict.Add(341, "ConfigTask running: ISDU parameter Port 4 Index 55 compare");


                    actionDescriptionDict.Add(101, "ConfigTask finished succesfully.");
                    actionDescriptionDict.Add(102, "ConfigTask restored.");

                    //  General alarms
                    actionDescriptionDict.Add(700, "Input variable `inParent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `Config.Hwid` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    actionDescriptionDict.Add(710, "Hw configuration error. Value of Config.Hwid is zero.");
                    actionDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091).");
                    actionDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094).");
                    actionDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095).");
                    actionDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096).");
                    actionDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097).");
                    actionDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected. Expected module: 'CM 4xIO-Link V2.2 32I/32O'.");
                    actionDescriptionDict.Add(1201, "Error reading the input structure of the 'CM 4xIO-Link V2.2 32I/32O' module!");
                    // ConfigTask
                    actionDescriptionDict.Add(10000, "ConfigTask finished with error!");
                    actionDescriptionDict.Add(10001, "ConfigTask was aborted, while not yet completed!");
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
