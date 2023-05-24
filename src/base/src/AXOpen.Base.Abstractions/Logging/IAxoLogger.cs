using Microsoft.Extensions.DependencyInjection;

namespace AXOpen.Logging
{
    public interface IAxoLogger
    {
        void Debug(string message);
        void Debug<T>(string message, T propertyValue);
        void Verbose(string message);
        void Verbose<T>(string message, T propertyValue);
        void Information(string message);
        void Information<T>(string message, T propertyValue);
        void Warning(string message);
        void Warning<T>(string message, T propertyValue);
        void Error(string message);
        void Error<T>(string message, T propertyValue);
        void Fatal(string message);
        void Fatal<T>(string message, T propertyValue);
    }
}