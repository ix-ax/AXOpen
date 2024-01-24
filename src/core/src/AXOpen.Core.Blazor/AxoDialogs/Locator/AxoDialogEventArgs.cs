using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public class AxoDialogEventArgs : EventArgs
    {
        public AxoDialogEventArgs( string dialogInstanceSymbol)
        {
            SymbolOfDialogInstance = dialogInstanceSymbol;
        }
        public string SymbolOfDialogInstance { get; set; }
    }
}
