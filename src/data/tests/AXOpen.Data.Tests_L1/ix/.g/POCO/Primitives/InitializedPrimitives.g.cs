using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.Primitives
    {
        public partial class InitializedPrimitives : AXSharp.Connector.IPlain
        {
            public InitializedPrimitives()
            {
            }

            public Boolean v_BOOL { get; set; }
            public Byte v_BYTE { get; set; }
            public UInt16 v_WORD { get; set; }
            public UInt32 v_DWORD { get; set; }
            public UInt64 v_LWORD { get; set; }
            public SByte v_SINTMin { get; set; }
            public SByte v_SINTMax { get; set; }
            public Int16 v_INT { get; set; }
            public Int32 v_DINT { get; set; }
            public Int64 v_LINT { get; set; }
            public Byte v_USINT { get; set; }
            public UInt16 v_UINT { get; set; }
            public UInt32 v_UDINT { get; set; }
            public UInt64 v_ULINT { get; set; }
            public Single v_REAL { get; set; }
            public Double v_LREAL { get; set; }
            public TimeSpan v_TIME { get; set; } = default(TimeSpan);
            public TimeSpan v_LTIME { get; set; } = default(TimeSpan);
            public DateOnly v_DATE { get; set; } = new DateOnly(1970, 1, 1);
            public DateOnly v_LDATE { get; set; } = new DateOnly(1970, 1, 1);
            public TimeSpan v_TIME_OF_DAY { get; set; } = default(TimeSpan);
            public TimeSpan v_LTIME_OF_DAY { get; set; } = default(TimeSpan);
            public DateTime v_DATE_AND_TIME { get; set; } = new DateTime(1970, 1, 1);
            public DateTime v_LDATE_AND_TIME { get; set; } = new DateTime(1970, 1, 1);
            public Char v_CHAR { get; set; }
            public Char v_WCHAR { get; set; }
            public string v_STRING { get; set; } = string.Empty;
            public string v_WSTRING { get; set; } = string.Empty;
        }
    }
}