using System;

namespace AXOpen.Base.Dialogs
{
    public interface IAlertToast
    {
        public Guid Id { get; set; }
        public eAlertType Type { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public DateTimeOffset TimeToBurn { get; set; }
        public DateTimeOffset Posted { get; set; }
    }
}