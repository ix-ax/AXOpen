using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public class AxoDialogEventArgs : EventArgs
    {
        public AxoDialogEventArgs(string dialogLocatorId, string dialogInstanceSymbol)
        {
            DialogLocatorId = dialogLocatorId;
            SymbolOfDialogInstance = dialogInstanceSymbol;
        }
        public string DialogLocatorId { get; set; }
        public string SymbolOfDialogInstance { get; set; }
    }
}
