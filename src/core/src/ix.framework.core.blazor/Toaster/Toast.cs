using CommunityToolkit.Mvvm.Messaging.Messages;

namespace AXOpen.Core.blazor.Toaster
{
    public class Toast
    {
        public Guid Id = Guid.NewGuid();
        public string Type { get; set; } = "Info";
        public string Title { get; set; } = "";
        public string Message { get; set; } = "";
        public DateTimeOffset TimeToBurn { get; set; } = DateTimeOffset.Now.AddSeconds(30);
        public DateTimeOffset Posted = DateTimeOffset.Now;

        public Toast(string type, string title, string message, int time)
        {
            Type = type;
            Title = title;
            Message = message;
            TimeToBurn = DateTimeOffset.Now.AddSeconds(time);
        }
    }
}