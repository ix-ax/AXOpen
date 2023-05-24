// AXOpen.Logging.Serilog
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using Microsoft.Extensions.DependencyInjection;
using Serilog;

namespace AXOpen.Logging;

/// <summary>Class containing DI services.</summary>
public static class LoggingServiceConfiguration
{
    public static void AddAxoLoggingServices(this IServiceCollection services)
    {
        services.AddSingleton<SerilogLogger>();
    }
}

public class SerilogLogger : IAxoLogger
{
    public SerilogLogger(ILogger logger)
    {
        Log.Logger = logger ?? Log.Logger;
    }

    public void Debug(string message)
    {
        Log.Debug(message);
    }

    public void Debug<T>(string message, T propertyValue)
    {
        Log.Debug<T>(message, propertyValue);
    }

    public void Verbose(string message)
    {
        Log.Verbose(message);
    }

    public void Verbose<T>(string message, T propertyValue)
    {
        Log.Verbose<T>(message, propertyValue);
    }

    public void Information(string message)
    {
        Log.Information(message);
    }

    public void Information<T>(string message, T propertyValue)
    {
        Log.Information<T>(message, propertyValue);
    }

    public void Warning(string message)
    {
        Log.Warning(message);
    }

    public void Warning<T>(string message, T propertyValue)
    {
        Log.Warning<T>(message, propertyValue);
    }

    public void Error(string message)
    {
        Log.Error(message);
    }

    public void Error<T>(string message, T propertyValue)
    {
        Log.Error<T>(message, propertyValue);
    }

    public void Fatal(string message)
    {
        Log.Fatal(message);
    }

    public void Fatal<T>(string message, T propertyValue)
    {
        Log.Fatal<T>(message, propertyValue);
    }
}