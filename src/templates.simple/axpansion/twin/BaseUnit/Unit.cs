// axosimple
// Copyright (c)2024 Peter Kurhajec and Contributors All Rights Reserved.
// Contributors: https://github.com/PTKu/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/PTKu/ix/blob/master/LICENSE
// Third party licenses: https://github.com/PTKu/ix/blob/master/notices.md

using axosimple.server.Units;

namespace axosimple.BaseUnit
{
    public partial class UnitBase : AXOpen.Core.AxoObject, axosimple.IUnit
    {
        public IUnitServices UnitServices { get; internal set; }
        
        public AxoTask Automat
        {
            get { return this.GetType().GetProperty("AutomatSequence").GetValue(this) as AxoTask; }
        }

        public AxoTask Ground
        {
            get { return this.GetType().GetProperty("GroundSequence").GetValue(this) as AxoTask; }
        }

        public AxoTask Service
        {
            get { return this.GetType().GetProperty("ServiceMode").GetValue(this) as AxoTask; }
        }

        public eAxoTaskState GroundStatus
        {
            get
            {
                try
                {
                    return (AXOpen.Core.eAxoTaskState)Ground?.Status.LastValue;
                }
                catch
                {
                    return eAxoTaskState.Disabled;
                }
            }
        }

        public eAxoTaskState AutomatStatus
        {
            get
            {
                try
                {
                    return (AXOpen.Core.eAxoTaskState)Automat?.Status.LastValue;
                }
                catch
                {
                    return eAxoTaskState.Disabled;
                }
            }
        }

        public eAxoTaskState ServiceStatus
        {
            get
            {
                try
                {
                    return (AXOpen.Core.eAxoTaskState)Service?.Status.LastValue;
                }
                catch
                {
                    return eAxoTaskState.Disabled;
                }
            }
        }
    }
}