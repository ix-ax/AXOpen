using AXOpen.Base.Abstractions.Dialogs;
using AXOpen.Dialogs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core
{

    public partial class AxoDialogBase : IsModalDialogType
    {
        public string DialogId { get; set; }

        public new void Initialize(Action dialogAction)
        {
            DeferredAction = dialogAction;
            this.IsInitialized.Cyclic = true;
            this.StartSignature.ValueChangeEvent += ExecuteAsync;
            _defferedActionCount++;
        }

        
        public new void DeInitialize()
        {
            this.IsInitialized.Cyclic = false;
            this.StartSignature.ValueChangeEvent -= ExecuteAsync;
            _defferedActionCount--;
        }


        public void Dispose()
        {
            DeInitialize();
        }
    }
}
