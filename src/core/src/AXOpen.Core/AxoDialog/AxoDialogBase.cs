using AXOpen.Dialogs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core
{

    public partial class AxoDialogBase : IsDialog
    {
        public string DialogId { get; set; }
        public bool Show { get; set; }

    }
}
