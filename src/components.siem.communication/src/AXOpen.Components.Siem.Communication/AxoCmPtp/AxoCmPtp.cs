using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Siem.Communication
{
    public partial class AxoCmPtp
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
                // PortConfigTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("PortConfigTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("PortConfigTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("PortConfigTask restored.","")),
                // ReceiveResetTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("ReceiveResetTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("ReceiveResetTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("ReceiveResetTask restored.","")),
                // SendDataTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("SendDataTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("SendDataTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("SendDataTask restored.","")),
                //  General alarms
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwID` has invalid value in `Run` method!"                                                                      ,"Check the call of the `Run` method, if the `hwID` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected. Expected module: 'PTPCM Freeport V2.0'."                 ,"Check the hardware configuration.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                  ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `hwID` has invalid value in `Run` method!"                                                                     ,"Check the call of the `Run` method, if the `hwID` parameter is assigned.")),

                // PortConfigTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("PortConfigTask finished with error!"                                                                                 ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("PortConfigTask was aborted, while not yet completed!"                                                                ,"Check the details.")),
                // ReceiveResetTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("ReceiveResetTask finished with error!"                                                                                 ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("ReceiveResetTask was aborted, while not yet completed!"                                                                ,"Check the details.")),
                // SendDataTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("SendDataTask finished with error!"                                                                                 ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("SendDataTask was aborted, while not yet completed!"                                                                ,"Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                // PortConfigTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal/variable `_portConfig.done` to be set!"                                                                ,"Check the status of the `_portConfig.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal/variable `_portConfig.done` to be reseted!"                                                            ,"Check the status of the `_portConfig.done`  signal/variable.")),
                // ReceiveResetTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal/variable `_receiveReset.done` to be set!"                                                              ,"Check the status of the `_receiveReset.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal/variable `_receiveReset.done` to be reseted!"                                                          ,"Check the status of the `_receiveReset.done`  signal/variable.")),
                // SendDataTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal/variable `_sendP2P.done` to be set!"                                                                   ,"Check the status of the `_sendP2P.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal/variable `_sendP2P.done` to be reseted!"                                                               ,"Check the status of the `_sendP2P.done`  signal/variable.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoCmPtp_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    // PortConfigTask
                    errorDescriptionDict.Add(500, "Waiting for the signal/variable `_portConfig.done` to be set!");
                    errorDescriptionDict.Add(501, "Waiting for the signal/variable `_portConfig.done` to be reseted!");
                    // ReceiveResetTask
                    errorDescriptionDict.Add(510, "Waiting for the signal/variable `_receiveReset.done` to be set!");
                    errorDescriptionDict.Add(511, "Waiting for the signal/variable `_receiveReset.done` to be reseted!");
                    // SendDataTask
                    errorDescriptionDict.Add(520, "Waiting for the signal/variable `_sendP2P.done` to be set!");
                    errorDescriptionDict.Add(521, "Waiting for the signal/variable `_sendP2P.done` to be reseted!");
                    // General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `hwID` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected. Expected module: 'PTPCM Freeport V2.0'.");
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(1131, "Input variable `hwID` has invalid value in `Run` method!");
                    // PortConfigTask
                    errorDescriptionDict.Add(10000, "PortConfigTask finished with error!");
                    errorDescriptionDict.Add(10001, "PortConfigTask was aborted, while not yet completed!");
                    // ReceiveResetTask
                    errorDescriptionDict.Add(10010, "ReceiveResetTask finished with error!");
                    errorDescriptionDict.Add(10011, "ReceiveResetTask was aborted, while not yet completed!");
                    // SendDataTask
                    errorDescriptionDict.Add(10020, "SendDataTask finished with error!");
                    errorDescriptionDict.Add(10021, "SendDataTask was aborted, while not yet completed!");

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
                    // PortConfigTask
                    actionDescriptionDict.Add(100, "PortConfigTask started.");
                    actionDescriptionDict.Add(300, "PortConfigTask running: waiting for '_portConfig.done' to be on.");
                    actionDescriptionDict.Add(301, "PortConfigTask running: waiting for '_portConfig.done' to be off.");
                    actionDescriptionDict.Add(302, "PortConfigTask finished.");
                    actionDescriptionDict.Add(101, "PortConfigTask finished succesfully.");
                    actionDescriptionDict.Add(102, "PortConfigTask restored.");
                    // ReceiveResetTask
                    actionDescriptionDict.Add(110, "ReceiveResetTask started.");
                    actionDescriptionDict.Add(310, "ReceiveResetTask runnin: waiting for '_receiveReset.done' to be on.");
                    actionDescriptionDict.Add(311, "ReceiveResetTask runnin: waiting for '_receiveReset.done' to be off.");
                    actionDescriptionDict.Add(312, "ReceiveResetTask finished.");
                    actionDescriptionDict.Add(111, "ReceiveResetTask finished succesfully.");
                    actionDescriptionDict.Add(112, "ReceiveResetTask restored.");
                    // SendDataTask
                    actionDescriptionDict.Add(120, "SendDataTask started.");
                    actionDescriptionDict.Add(320, "SendDataTask running: waiting for '_sendP2P.done' to be on.");
                    actionDescriptionDict.Add(321, "SendDataTask running: waiting for '_sendP2P.done' to be off.");
                    actionDescriptionDict.Add(322, "SendDataTask finished.");
                    actionDescriptionDict.Add(121, "SendDataTask finished succesfully.");
                    actionDescriptionDict.Add(122, "SendDataTask restored.");
                    // General alarms
                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `hwID` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    actionDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected. Expected module: 'PTPCM Freeport V2.0'.");

                    actionDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(1131, "Input variable `hwId` has invalid value in `Run` method!");
                    // PortConfigTask
                    actionDescriptionDict.Add(10000, "PortConfigTask finished with error!");
                    actionDescriptionDict.Add(10001, "PortConfigTask was aborted, while not yet completed!");
                    // ReceiveResetTask
                    actionDescriptionDict.Add(10010, "ReceiveResetTask finished with error!");
                    actionDescriptionDict.Add(10011, "ReceiveResetTask was aborted, while not yet completed!");
                    // SendDataTask
                    actionDescriptionDict.Add(10020, "SendDataTask finished with error!");
                    actionDescriptionDict.Add(10021, "SendDataTask was aborted, while not yet completed!");
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
