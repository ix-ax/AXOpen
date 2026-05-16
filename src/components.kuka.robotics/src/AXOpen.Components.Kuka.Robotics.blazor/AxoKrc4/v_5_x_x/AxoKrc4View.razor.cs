using AXOpen.Core.Blazor;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Components.Kuka.Robotics.v_5_x_x
{
    public partial class AxoKrc4View : AxoComponentViewBase<AxoKrc4>
    {
        public override void ConfigurePolling()
        {
            // Mode & status flags driving header / state tabs
            this.StartPolling(Component.Inputs.RcReady);
            this.StartPolling(Component.Inputs.AlarmStopActive);
            this.StartPolling(Component.Inputs.UserSafetySwitchClosed);
            this.StartPolling(Component.Inputs.DrivesReady);
            this.StartPolling(Component.Inputs.RobotCalibrated);
            this.StartPolling(Component.Inputs.InterfaceActivated);
            this.StartPolling(Component.Inputs.StopMess);
            this.StartPolling(Component.Inputs.RobotStopped);

            this.StartPolling(Component.Inputs.InHome);
            this.StartPolling(Component.Inputs.Manual);
            this.StartPolling(Component.Inputs.Automatic);
            this.StartPolling(Component.Inputs.ExternalAutomatic);
            this.StartPolling(Component.Inputs.ProActive);
            this.StartPolling(Component.Inputs.ProgramMoveActive);
            this.StartPolling(Component.Inputs.PpMoved);
            this.StartPolling(Component.Inputs.StartAtMain);
            this.StartPolling(Component.Inputs.Error);

            // Areas / positions
            this.StartPolling(Component.Inputs.InArea_1);
            this.StartPolling(Component.Inputs.InArea_2);
            this.StartPolling(Component.Inputs.InArea_3);
            this.StartPolling(Component.Inputs.InArea_4);
            this.StartPolling(Component.Inputs.InPosition_1);
            this.StartPolling(Component.Inputs.InPosition_2);
            this.StartPolling(Component.Inputs.InPosition_3);
            this.StartPolling(Component.Inputs.InPosition_4);

            // Tool states
            this.StartPolling(Component.Inputs.Tool_1_Retract);
            this.StartPolling(Component.Inputs.Tool_1_Extend);
            this.StartPolling(Component.Inputs.Tool_2_Retract);
            this.StartPolling(Component.Inputs.Tool_2_Extend);
            this.StartPolling(Component.Inputs.Tool_3_Retract);
            this.StartPolling(Component.Inputs.Tool_3_Extend);
            this.StartPolling(Component.Inputs.Tool_4_Retract);
            this.StartPolling(Component.Inputs.Tool_4_Extend);

            // Task statuses
            this.StartPolling(Component.RestoreTask.Status);
            this.StartPolling(Component.ResetAllOutputsTask.Status);
            this.StartPolling(Component.StartMotorsTask.Status);
            this.StartPolling(Component.StartAtMainTask.Status);
            this.StartPolling(Component.StartMotorsProgramAndMovementsTask.Status);
            this.StartPolling(Component.StartProgramTask.Status);
            this.StartPolling(Component.StartMovementsTask.Status);
            this.StartPolling(Component.StartMotorsAndProgramTask.Status);
            this.StartPolling(Component.StopMovementsTask.Status);
            this.StartPolling(Component.StopMovementsAndProgramTask.Status);
            this.StartPolling(Component.StopProgramTask.Status);
            this.StartPolling(Component.StopMotorsTask.Status);
        }
    }

    public class AxoKrc4StatusView : AxoKrc4View
    {
        public AxoKrc4StatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class AxoKrc4CommandView : AxoKrc4View
    {
        public AxoKrc4CommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoKrc4SpotView : AxoKrc4View
    {
        public AxoKrc4SpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
