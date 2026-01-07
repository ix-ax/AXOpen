using AXOpen.Messaging.Static;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Elements
{

    public partial class AxoRotaryIndexingTable_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    // TurnTask
                    errorDescriptionDict.Add(502, "Waiting for the signal/variable `Inputs.InPosition` to be reseted !");
                    errorDescriptionDict.Add(503, "Waiting for the signal/variable `Inputs.InPosition` to be set !");                       
                    // InitPositionTask
                    errorDescriptionDict.Add(512, "Waiting for the signal/variable `Inputs.InPosition` to be reseted !");
                    errorDescriptionDict.Add(513, "Waiting for the signal/variable `Inputs.InPosition` to be set !");
                    // General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Parameter 'Config.NumberOfPositions' is lower then 2. This parameters must be grater or equal to 2.");
                    errorDescriptionDict.Add(702, "Parameter 'Config.NumberOfPositions' is greather then 32. This parameters must be lower or equal to 32.");
                    errorDescriptionDict.Add(703, "Turn table is not in the initial position!");
                    errorDescriptionDict.Add(704, "Invalid coding, no signal from any coding sensor!");
                    errorDescriptionDict.Add(705, "Invalid coding, current position is greather then maximum!");
                    errorDescriptionDict.Add(706, "Invalid coding, unexpected value of coding sensors!");

                    // TurnTask
                    errorDescriptionDict.Add(10000, "TurnTask finished with error!");
                    errorDescriptionDict.Add(10001, "TurnTask was aborted, while not yet completed!");
                    // InitPositionTask
                    errorDescriptionDict.Add(10010, "InitPositionTask finished with error!");
                    errorDescriptionDict.Add(10011, "InitPositionTask was aborted, while not yet completed!");

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
                    // TurnTask
                    actionDescriptionDict.Add(100, "TurnTask started.");
                    actionDescriptionDict.Add(300, "TurnTask running: checking the initial position.");
                    actionDescriptionDict.Add(301, "TurnTask running: evaluating start index.");
                    actionDescriptionDict.Add(302, "TurnTask running: turn table moving, waiting for 'Inputs.InPosition' to be reseted.");
                    actionDescriptionDict.Add(303, "TurnTask running: turn table moving, waiting for 'Inputs.InPosition' to be set.");
                    actionDescriptionDict.Add(304, "TurnTask running: evaluating end index.");
                    actionDescriptionDict.Add(309, "TurnTask finished.");
                    actionDescriptionDict.Add(101, "TurnTask finished succesfully.");
                    actionDescriptionDict.Add(102, "TurnTask restored.");
                    // InitPositionTask
                    actionDescriptionDict.Add(110, "InitPositionTask started.");
                    actionDescriptionDict.Add(312, "InitPositionTask running: turn table moving, waiting for 'Inputs.InPosition' to be reseted.");
                    actionDescriptionDict.Add(313, "InitPositionTask running: turn table moving, waiting for 'Inputs.InPosition' to be set.");
                    actionDescriptionDict.Add(319, "InitPositionTask finished.");
                    actionDescriptionDict.Add(111, "InitPositionTask finished succesfully.");
                    actionDescriptionDict.Add(112, "InitPositionTask restored.");
                    // General alarms
                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Parameter 'Config.NumberOfPositions' is lower then 2. This parameters must be grater or equal to 2.");
                    actionDescriptionDict.Add(702, "Parameter 'Config.NumberOfPositions' is greather then 32. This parameters must be lower or equal to 32.");
                    actionDescriptionDict.Add(703, "Turn table is not in the initial position!");
                    actionDescriptionDict.Add(704, "Invalid coding, no signal from any coding sensor!");
                    actionDescriptionDict.Add(705, "Invalid coding, current position is greather then maximum!");
                    actionDescriptionDict.Add(706, "Invalid coding, unexpected value!");


                    // TurnTask
                    actionDescriptionDict.Add(10000, "TurnTask finished with error!");
                    actionDescriptionDict.Add(10001, "TurnTask was aborted, while not yet completed!");
                    // InitPositionTask
                    actionDescriptionDict.Add(10010, "InitPositionTask finished with error!");
                    actionDescriptionDict.Add(10011, "InitPositionTask was aborted, while not yet completed!");
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

