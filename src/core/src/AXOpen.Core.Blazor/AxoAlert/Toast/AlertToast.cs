using AXOpen.Base.Dialogs;
using System;

namespace AXOpen.Core.Blazor.AxoAlertDialog
{
    /// <summary>
    /// Data structure representing AlertToast.
    /// </summary>
    public class AlertToast : IAlertToast
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public eAlertType Type { get; set; } = eAlertType.Undefined;
        public string Title { get; set; } = "";
        public string Message { get; set; } = "";
        public DateTimeOffset TimeToBurn { get; set; } = DateTimeOffset.Now.AddSeconds(30);
        public DateTimeOffset Posted { get; set; } = DateTimeOffset.Now;

        public AlertToast(eAlertType type, string title, string message, int time)
        {
            Type = type;
            Title = title;
            Message = message;
            TimeToBurn = DateTimeOffset.Now.AddSeconds(time);
        }
    }
}