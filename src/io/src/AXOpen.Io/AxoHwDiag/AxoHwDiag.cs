using AXOpen.Messaging.Static;
using AXSharp.Connector;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Io
{
    public partial class AxoHwDiag
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
                // UpdateDiagnosticTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("UpdateDiagnosticTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("UpdateDiagnosticTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("UpdateDiagnosticTask restored.","")),
                //  General alarms
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable array `hwIDsList` must be zero based.!"                                                                         ,"Check the list of the hawrware identifiers passed to the 'hwIDsList' input vairable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Size of input variable array `hwIDsList` must be greather then 1."                                                             ,"Check the list of the hawrware identifiers passed to the 'hwIDsList' input vairable.")),

                // UpdateDiagnosticTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("UpdateDiagnosticTask finished with error!"                                                                                 ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("UpdateDiagnosticTask was aborted, while not yet completed!"                                                                ,"Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                // UpdateDiagnosticTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal/variable `_currentIndex` to be equal to INT#-1!"                                                       ,"Check the actual value of this signal/variable.")),
        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }

        private Type _hwIdEnumType;

        /// <summary>
        /// Assigns an enum type to be used for hardware ID interpretation.
        /// </summary>
        /// <typeparam name="TEnum">Enum type to be used for the HW ID interpretation.</typeparam>
        public void UseHwIdEnum<TEnum>() where TEnum : Enum
        {
            _hwIdEnumType = typeof(TEnum);
        }

        /// <summary>
        /// Gets the hardware ID as a string, using the assigned enum type if available.
        /// </summary>
        /// <param name="hardwareId">Hardware id (numerical value)</param>
        /// <returns></returns>
        public string GetHwIdAsString(ushort hardwareId)
        {
            if (_hwIdEnumType == null)
                return $"0x{hardwareId:X4} (enum not assigned)";

            if (Enum.IsDefined(_hwIdEnumType, hardwareId))
            {
                var name = Enum.GetName(_hwIdEnumType, hardwareId).Replace("_HwID", "");
                return name ?? hardwareId.ToString();
            }

            return $"0x{hardwareId:X4} (unknown)";
        }
    }

    public partial class AxoHwDiag_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    // UpdateDiagnosticTask
                    errorDescriptionDict.Add(501, "Waiting for the signal/variable `_currentIndex` to be equal to INT#-1!");
                    // General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable array `hwIDsList` must be zero based.!");
                    errorDescriptionDict.Add(702, "Size of input variable array `hwIDsList` must be greather then 1.");

                    // UpdateDiagnosticTask
                    errorDescriptionDict.Add(10000, "UpdateDiagnosticTask finished with error!");
                    errorDescriptionDict.Add(10001, "UpdateDiagnosticTask was aborted, while not yet completed!");
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
                    // UpdateDiagnosticTask
                    actionDescriptionDict.Add(100, "UpdateDiagnosticTask started.");
                    actionDescriptionDict.Add(300, "UpdateDiagnosticTask running: cleaning all diagnostics results.");
                    actionDescriptionDict.Add(301, "UpdateDiagnosticTask running: waiting for the accessibility to the HwIdList.");
                    actionDescriptionDict.Add(302, "UpdateDiagnosticTask running: discovering PLC-ReadSlotFromHardwareID running.");
                    actionDescriptionDict.Add(303, "UpdateDiagnosticTask running: discovering PLC-comparing GeoAddr details.");
                    actionDescriptionDict.Add(304, "UpdateDiagnosticTask running: discovering PLC-check maximal index.");
                    actionDescriptionDict.Add(305, "UpdateDiagnosticTask running: get diagnostics of the PLC system.");
                    actionDescriptionDict.Add(306, "UpdateDiagnosticTask running: get diagnostics of the PLC sub system.");
                    actionDescriptionDict.Add(307, "UpdateDiagnosticTask running: discovering IoSystem-ReadSlotFromHardwareID running.");
                    actionDescriptionDict.Add(308, "UpdateDiagnosticTask running: discovering IoSystem-comparing GeoAddr details.");
                    actionDescriptionDict.Add(309, "UpdateDiagnosticTask running: discovering IoSystem-check maximal index.");
                    actionDescriptionDict.Add(310, "UpdateDiagnosticTask running: get diagnostics of the IoSystem system.");
                    actionDescriptionDict.Add(311, "UpdateDiagnosticTask running: get diagnostics of the IoSystem sub system.");
                    actionDescriptionDict.Add(312, "UpdateDiagnosticTask running: discovering Station-ReadSlotFromHardwareID running.");
                    actionDescriptionDict.Add(313, "UpdateDiagnosticTask running: discovering Station-comparing GeoAddr details.");
                    actionDescriptionDict.Add(314, "UpdateDiagnosticTask running: discovering Station-check maximal index.");
                    actionDescriptionDict.Add(315, "UpdateDiagnosticTask running: get diagnostics of the Station system.");
                    actionDescriptionDict.Add(316, "UpdateDiagnosticTask running: get diagnostics of the Station sub system.");
                    actionDescriptionDict.Add(317, "UpdateDiagnosticTask running: discovering Module-ReadSlotFromHardwareID running.");
                    actionDescriptionDict.Add(318, "UpdateDiagnosticTask running: discovering Module-comparing GeoAddr details.");
                    actionDescriptionDict.Add(319, "UpdateDiagnosticTask running: discovering Module-check maximal index.");
                    actionDescriptionDict.Add(320, "UpdateDiagnosticTask running: get diagnostics of the Module system.");
                    actionDescriptionDict.Add(321, "UpdateDiagnosticTask running: get diagnostics of the Module sub system.");
                    actionDescriptionDict.Add(322, "UpdateDiagnosticTask running: discovering Submodule-ReadSlotFromHardwareID running.");
                    actionDescriptionDict.Add(323, "UpdateDiagnosticTask running: discovering Submodule-comparing GeoAddr details.");
                    actionDescriptionDict.Add(324, "UpdateDiagnosticTask running: discovering Submodule-check maximal index.");
                    actionDescriptionDict.Add(325, "UpdateDiagnosticTask running: get diagnostics of the Submodule system.");
                    actionDescriptionDict.Add(326, "UpdateDiagnosticTask running: get diagnostics of the SubModule sub system.");
                    actionDescriptionDict.Add(327, "UpdateDiagnosticTask running: should never get into this step.");

                    actionDescriptionDict.Add(330, "UpdateDiagnosticTask running: at least one error present.");
                    actionDescriptionDict.Add(331, "UpdateDiagnosticTask running: get diagnostics of the faulty item.");
                    actionDescriptionDict.Add(332, "UpdateDiagnosticTask done: error present.");

                    actionDescriptionDict.Add(340, "UpdateDiagnosticTask done:  none error present.");

                    actionDescriptionDict.Add(101, "UpdateDiagnosticTask finished succesfully.");
                    actionDescriptionDict.Add(102, "UpdateDiagnosticTask restored.");
                    // General alarms
                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable array `hwIDsList` must be zero based.!");
                    actionDescriptionDict.Add(702, "Size of input variable array `hwIDsList` must be greather then 1.");
                    // UpdateDiagnosticTask
                    actionDescriptionDict.Add(10000, "UpdateDiagnosticTask finished with error!");
                    actionDescriptionDict.Add(10001, "UpdateDiagnosticTask was aborted, while not yet completed!");
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
