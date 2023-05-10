using CommunityToolkit.Mvvm.Messaging.Messages;
using AXOpen.Core.blazor.Toaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core
{
    public class ToastMessage : ValueChangedMessage<Toast>
    {
        public ToastMessage(Toast toast) : base(toast)
        {
        }
    }
}
