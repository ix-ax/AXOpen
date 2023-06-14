// AXOpen.Logging.Serilog
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using System.Security.Principal;
using AXSharp.Connector;
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

public class SerilogLogger : ILogger
{
    public SerilogLogger(Serilog.ILogger logger)
    {
        Log.Logger = logger ?? Log.Logger;
    }

    public void Debug(string message, IIdentity identity)
    {
        Log.Debug("{message} {identity}",message, new { UserName = identity.Name });
    }

    public void Debug(string message, ITwinElement sender, IIdentity identity, object details)
    {
        Log.Debug<object, object, object>($"{message} {{sender}} {{identity}} {{details}}",
            new { Symbol = sender?.Symbol, Label = sender?.HumanReadable },
            new { UserName = identity.Name, Type = identity.AuthenticationType },
            details
        );
    }

    public void Verbose(string message, IIdentity identity)
    {
        Log.Verbose("{message} {identity}", message, new { UserName = identity.Name });
    }

    public void Verbose(string message, ITwinElement sender, IIdentity identity, object details)
    {
        Log.Verbose<object, object, object>($"{message} {{sender}} {{identity}} {{details}}",
            new { Symbol = sender?.Symbol, Label = sender?.HumanReadable },
            new { UserName = identity.Name, Type = identity.AuthenticationType },
            details
        );
    }

    public void Information(string message, IIdentity identity)
    {
        Log.Information("{message} {identity}", message,new { UserName = identity.Name });
    }

    public void Information(string message, ITwinElement sender, IIdentity identity, object details)
    {
        Log.Information<object, object, object>($"{message} {{sender}} {{identity}} {{details}}",
            new { Symbol = sender?.Symbol, Label = sender?.HumanReadable },
            new { UserName = identity.Name, Type = identity.AuthenticationType },
            details);
    }

    public void Warning(string message, IIdentity identity)
    {
        Log.Warning("{message} {identity}", message, new { UserName = identity.Name });
    }

    public void Warning(string message, ITwinElement sender, IIdentity identity, object details)
    {
        Log.Warning<object, object, object>($"{message} {{sender}} {{identity}} {{details}}",
            new { Symbol = sender?.Symbol, Label = sender?.HumanReadable },
            new { UserName = identity.Name, Type = identity.AuthenticationType },
            details
        );
    }

    public void Error(string message, IIdentity identity)
    {
        Log.Error("{message} {identity}", message, new { UserName = identity.Name });
    }

    public void Error(string message, ITwinElement sender, IIdentity identity, object details)
    {
        Log.Error<object, object, object>($"{message} {{sender}} {{identity}} {{details}}",
            new { Symbol = sender?.Symbol, Label = sender?.HumanReadable },
            new { UserName = identity.Name, Type = identity.AuthenticationType },
            details
        );
    }

    public void Fatal(string message, IIdentity identity)
    {
        Log.Fatal("{message} {identity}", message, new { UserName = identity.Name });
    }

    public void Fatal(string message, ITwinElement sender, IIdentity identity, object details)
    {
        Log.Fatal<object, object, object>($"{message} {{sender}} {{identity}} {{details}}",
            new { Symbol = sender?.Symbol, Label = sender?.HumanReadable },
            new { UserName = identity.Name, Type = identity.AuthenticationType },
            details
        );
    }
}