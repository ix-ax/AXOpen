using AXOpen.Base.Abstractions.Dialogs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core
{
    public partial class AxoAlertDialog: IsAlertDialogType
    {
        public string DialogId { get; set; }
    }
}
