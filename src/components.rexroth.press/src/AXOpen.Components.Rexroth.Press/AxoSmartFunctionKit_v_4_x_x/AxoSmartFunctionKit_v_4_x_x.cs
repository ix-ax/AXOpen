﻿using AXOpen.Messaging.Static;
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
using AXOpen.Components.Rexroth.Press.RestApi;


namespace AXOpen.Components.Rexroth.Press
{
    public partial class AxoSmartFunctionKit_v_4_x_x : AXOpen.Core.AxoComponent
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

                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                                                              "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwID` has invalid value in `Run` method!",                                                                                 "Check the call of the `Run` method, if the `hwID` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Input variable `hwIdParamCh_IDN` has invalid valuein `Run` method!",                                                                       "Check the call of the `Run` method, if the `hwIdParamCh_IDN` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Input variable `hwIdInput_24_Words` has invalid valuein `Run` method!",                                                                    "Check the call of the `Run` method, if the `hwIdInput_24_Words` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Input variable `hwIdOutput_21_Words` has invalid valuein `Run` method!",                                                                   "Check the call of the `Run` method, if the `hwIdOutput_21_Words` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Error reading the `hwIdParamCh_IDN` in the Run method!",                                                                                   "Check the value of the `hwIdParamCh_IDN` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Error reading the `hwIdInput_24_Words` in the Run method!",                                                                                "Check the value of the `hwIdInput_24_Words` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("Error writing the `hwIdParamCh_IDN` in the Run method!",                                                                                   "Check the value of the `hwIdParamCh_IDN` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("Error writing the `hwIdOutput_21_Words` in the Run method!",                                                                               "Check the value of the `hwIdOutput_21_Words` and reacheability of the device!")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Run command finished with error!",                                                                                                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Run command was aborted, while not yet completed!",                                                                                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Get results finished with error!",                                                                                                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Get results was aborted, while not yet completed!",                                                                                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Export curve finished with error!",                                                                                                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Export curve was aborted, while not yet completed!",                                                                                      "Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ES_IsEmergencyStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!",                                                     "Check the status of the `Inputs.Inputs.Safety.PS_IsProtectiveStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.SS_IsSafeguardStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!",                                                          "Check the status of the `Inputs.Inputs.Safety.RC_IsRecoveryMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(517,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(518,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!",                                                             "Check the status of the `Inputs.Inputs.Safety.VL_IsViolation` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(519,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ES_IsEmergencyStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!",                                                     "Check the status of the `Inputs.Inputs.Safety.PS_IsProtectiveStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.SS_IsSafeguardStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(536,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!",                                                          "Check the status of the `Inputs.Inputs.Safety.RC_IsRecoveryMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(537,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(538,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!",                                                             "Check the status of the `Inputs.Inputs.Safety.VL_IsViolation` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(539,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(545,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(547,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(548,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(549,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(560,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(561,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(562,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(563,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ES_IsEmergencyStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(564,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!",                                                     "Check the status of the `Inputs.Inputs.Safety.PS_IsProtectiveStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(565,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.SS_IsSafeguardStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(566,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!",                                                          "Check the status of the `Inputs.Inputs.Safety.RC_IsRecoveryMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(567,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(568,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!",                                                             "Check the status of the `Inputs.Inputs.Safety.VL_IsViolation` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(569,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(570,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(571,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_0` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_0`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(572,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_1` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_1`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(573,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_2` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_2`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(574,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_3` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_3`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(575,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_4` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_4`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(576,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_5` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_5`")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(580,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(581,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(582,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(583,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(584,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(585,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(586,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(587,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(588,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(589,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(590,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(591,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(592,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!",                                                         "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(620,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(621,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(622,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!",                                                         "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(630,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(631,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(632,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!",                                                         "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoSmartFunctionKit_ComponentStatus_v_4_x_x : AXOpen.Components.Abstractions.AxoComponent_Status
    {
        Dictionary<uint, string> errorDescriptionDict = new Dictionary<uint, string>();
        Dictionary<uint, string> actionDescriptionDict = new Dictionary<uint, string>();

        public string ErrorDescription
        {
            get
            {
                if (errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<uint, string>(); }
                if (errorDescriptionDict.Count == 0)
                {
                    errorDescriptionDict.Add(0, "   ");
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `hwID` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Input variable `hwIdParamCh_IDN` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(703, "Input variable `hwIdInput_24_Words` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(704, "Input variable `hwIdOutput_21_Words` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(705, "Error reading the `hwIdParamCh_IDN` in the Run method!");
                    errorDescriptionDict.Add(706, "Error reading the `hwIdInput_24_Words` in the Run method!");
                    errorDescriptionDict.Add(707, "Error writing the `hwIdParamCh_IDN` in the Run method!");
                    errorDescriptionDict.Add(708, "Error writing the `hwIdOutput_21_Words` in the Run method!");
                    errorDescriptionDict.Add(800, "Run command finished with error!");
                    errorDescriptionDict.Add(801, "Run command was aborted, while not yet completed!");
                    errorDescriptionDict.Add(810, "Get results finished with error!");
                    errorDescriptionDict.Add(811, "Get results was aborted, while not yet completed!");
                    errorDescriptionDict.Add(820, "Export curve finished with error!");
                    errorDescriptionDict.Add(821, "Export curve was aborted, while not yet completed!");

                    errorDescriptionDict.Add(10001, "No function or invalid input");
                    errorDescriptionDict.Add(10205,"Invalid character given within alphanumeric customID");
                    errorDescriptionDict.Add(10206,"Invalid entry");
                    errorDescriptionDict.Add(10207,"Invalid data type");
                    errorDescriptionDict.Add(10208,"Variable index exceeded");
                    errorDescriptionDict.Add(10209,"Value too small");
                    errorDescriptionDict.Add(10210,"Value too large");
                    errorDescriptionDict.Add(10211,"Value is invalid");
                    errorDescriptionDict.Add(20101,"Command active, command transition not permitted");
                    errorDescriptionDict.Add(30001,"Internal error");
                    errorDescriptionDict.Add(31901,"Internal error");
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
                if (actionDescriptionDict == null) { actionDescriptionDict = new Dictionary<uint, string>(); }
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

