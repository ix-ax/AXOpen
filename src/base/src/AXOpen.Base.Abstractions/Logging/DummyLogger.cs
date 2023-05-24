using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Logging;

namespace AXOpen.Logging
{
    internal class DummyLogger : IAxoLogger
    {
        public string LastMessage { get; private set; }

        public object LastObject { get; private set; }

        public string LastCategory { get; private set; }

        public void Debug(string message)
        {
            LastMessage = message;
            LastCategory = "Debug";
        }

        public void Debug<T>(string message, T propertyValue)
        {
            Debug(message);
            LastObject = propertyValue;
        }

        public void Verbose(string message)
        {
            LastMessage = message;
            LastCategory = "Verbose";
        }

        public void Verbose<T>(string message, T propertyValue)
        {
            Verbose(message);
            LastObject = propertyValue;
        }

        public void Information(string message)
        {
            LastMessage = message;
            LastCategory = "Information";
        }

        public void Information<T>(string message, T propertyValue)
        {
            Information(message);
            LastObject = propertyValue;
        }

        public void Warning(string message)
        {
            LastMessage = message;
            LastCategory = "Warning";
        }

        public void Warning<T>(string message, T propertyValue)
        {
            Warning(message);
            LastObject = propertyValue;
        }

        public void Error(string message)
        {
            LastMessage = message;
            LastCategory = "Error";
        }

        public void Error<T>(string message, T propertyValue)
        {
            Error(message);
            LastObject = propertyValue;
        }

        public void Fatal(string message)
        {
            LastMessage = message;
            LastCategory = "Fatal";
        }

        public void Fatal<T>(string message, T propertyValue)
        {
            Fatal(message);
            LastObject = propertyValue;
        }
    }
}
