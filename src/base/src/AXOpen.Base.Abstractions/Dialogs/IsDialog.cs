using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Dialogs
{

    public interface IsDialog : ITwinObject
    {
        string DialogId { get; set; }
        void Initialize(Action dialogAction);


    }
}
