using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.SIEM.Identification
{
    public partial class AxoIOLink_RF200Device_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    errorDescriptionDict.Add(500, "Waiting for the variable `_switchAntenna_done` to be set!");
                    errorDescriptionDict.Add(501, "Waiting for the variable `_switchAntenna_done` to be reseted!");
                    errorDescriptionDict.Add(502, "Waiting for the variable `_switchAntenna_presence` to be set!");
                    errorDescriptionDict.Add(503, "Waiting for the variable `_readTag_done` to be set!");
                    errorDescriptionDict.Add(504, "Waiting for the variable `_readTag_done` to be reseted!");

                    errorDescriptionDict.Add(520, "Waiting for the variable `_switchAntenna_done` to be set!");
                    errorDescriptionDict.Add(521, "Waiting for the variable `_switchAntenna_done` to be reseted!");
                    errorDescriptionDict.Add(522, "Waiting for the variable `_switchAntenna_presence` to be set!");
                    errorDescriptionDict.Add(523, "Waiting for the variable `_writeTag_done` to be set!");
                    errorDescriptionDict.Add(524, "Waiting for the variable `_writeTag_done` to be reseted!");

                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");

                    errorDescriptionDict.Add(800, "Read finished with error!");
                    errorDescriptionDict.Add(801, "Read was aborted, while not yet completed!");
                    errorDescriptionDict.Add(820, "Write finished with error!");
                    errorDescriptionDict.Add(821, "Write was aborted, while not yet completed!");

                    errorDescriptionDict.Add(0xFEFE0001, "Input variable 'identData' has NULL reference in 'AxoIOLink_RF200_ReadTag.Run()' method!");
                    errorDescriptionDict.Add(0xFEFE0002, "Input variable 'identData' has NULL reference in 'AxoIOLink_RF200_WriteTag.Run()' method!");


                    errorDescriptionDict.Add(0x00018101,"The transponder has left the field before the read/write process finished.");
                    errorDescriptionDict.Add(0x00018102,"The previous job is not yet complete. The operation will be terminated as soon as possible.");
                    errorDescriptionDict.Add(0x00018103,"No transponder was recognized in the reader's field within the specified time period.");
                    errorDescriptionDict.Add(0x00018104,"The specified length is shorter than 4 (IO-Link V1.0) or 28 (IO-Link V1.1).");



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

                    actionDescriptionDict.Add(100, "Read started.");
                    actionDescriptionDict.Add(300, "Read running.");
                    actionDescriptionDict.Add(301, "Read running.");
                    actionDescriptionDict.Add(302, "Read running.");
                    actionDescriptionDict.Add(303, "Read running.");
                    actionDescriptionDict.Add(304, "Read running.");
                    actionDescriptionDict.Add(305, "Read running.");
                    actionDescriptionDict.Add(306, "Read running.");
                    actionDescriptionDict.Add(307, "Read running.");
                    actionDescriptionDict.Add(308, "Read running.");
                    actionDescriptionDict.Add(309, "Read running.");
                    actionDescriptionDict.Add(101, "Read finished succesfully.");
                    actionDescriptionDict.Add(102, "Read restored.");

                    actionDescriptionDict.Add(120, "Write started.");
                    actionDescriptionDict.Add(320, "Write running.");
                    actionDescriptionDict.Add(321, "Write running.");
                    actionDescriptionDict.Add(322, "Write running.");
                    actionDescriptionDict.Add(323, "Write running.");
                    actionDescriptionDict.Add(324, "Write running.");
                    actionDescriptionDict.Add(325, "Write running.");
                    actionDescriptionDict.Add(326, "Write running.");
                    actionDescriptionDict.Add(327, "Write running.");
                    actionDescriptionDict.Add(328, "Write running.");
                    actionDescriptionDict.Add(329, "Write running.");
                    actionDescriptionDict.Add(121, "Write finished succesfully.");
                    actionDescriptionDict.Add(122, "Write restored.");

                    actionDescriptionDict.Add(140, "Soft reset started.");
                    actionDescriptionDict.Add(340, "Soft reset running.");
                    actionDescriptionDict.Add(341, "Soft reset running.");
                    actionDescriptionDict.Add(342, "Soft reset running.");
                    actionDescriptionDict.Add(343, "Soft reset running.");
                    actionDescriptionDict.Add(344, "Soft reset running.");
                    actionDescriptionDict.Add(345, "Soft reset running.");
                    actionDescriptionDict.Add(346, "Soft reset running.");
                    actionDescriptionDict.Add(347, "Soft reset running.");
                    actionDescriptionDict.Add(348, "Soft reset running.");
                    actionDescriptionDict.Add(349, "Soft reset running.");
                    actionDescriptionDict.Add(141, "Soft reset finished succesfully.");
                    actionDescriptionDict.Add(142, "Soft reset restored.");

                    actionDescriptionDict.Add(150, "Reset reader started.");
                    actionDescriptionDict.Add(350, "Reset reader running.");
                    actionDescriptionDict.Add(351, "Reset reader running.");
                    actionDescriptionDict.Add(352, "Reset reader running.");
                    actionDescriptionDict.Add(353, "Reset reader running.");
                    actionDescriptionDict.Add(354, "Reset reader running.");
                    actionDescriptionDict.Add(355, "Reset reader running.");
                    actionDescriptionDict.Add(356, "Reset reader running.");
                    actionDescriptionDict.Add(357, "Reset reader running.");
                    actionDescriptionDict.Add(358, "Reset reader running.");
                    actionDescriptionDict.Add(359, "Reset reader running.");
                    actionDescriptionDict.Add(151, "Reset reader finished succesfully.");
                    actionDescriptionDict.Add(152, "Reset reader restored.");


                    actionDescriptionDict.Add(800, "Read finished with error!");
                    actionDescriptionDict.Add(801, "Read was aborted, while not yet completed!");
                    actionDescriptionDict.Add(820, "Write finished with error!");
                    actionDescriptionDict.Add(821, "Write was aborted, while not yet completed!");
                    actionDescriptionDict.Add(840, "Soft reset finished with error!");
                    actionDescriptionDict.Add(841, "Soft reset was aborted, while not yet completed!");
                    actionDescriptionDict.Add(850, "Reset reader finished with error!");
                    actionDescriptionDict.Add(851, "Reset reader was aborted, while not yet completed!");
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

