using System;

namespace AXOpen.Core
{
    public partial class AxoTextList
    {

    }
    public class WarningLevelAttribute : Attribute
    {
        public WarningLevelAttribute()
        {
        }
        public WarningLevelAttribute(uint level)
        {
            Level = level;
        }

        public uint Level { get; }
    }

    public class ErrorLevelAttribute : Attribute
    {
        public ErrorLevelAttribute()
        {
        }
        public ErrorLevelAttribute(uint level)
        {
            Level = level;
        }

        public uint Level { get; }
    }

}
