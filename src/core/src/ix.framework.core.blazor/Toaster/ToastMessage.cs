using CommunityToolkit.Mvvm.Messaging.Messages;
using ix.framework.core.blazor.Toaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ix.framework.core
{
    public class ToastMessage : ValueChangedMessage<Toast>
    {
        public ToastMessage(Toast toast) : base(toast)
        {
        }
    }
}
