// AXOpen.Base.Abstractions
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using AXOpen.Logging;

namespace AXOpen;

/// <summary>
/// Provides access to the an AxoApplication builder.
/// </summary>
public interface IAxoApplicationBuilder
{
    /// <summary>
    /// Configures logger for an AxoApplication
    /// </summary>
    /// <param name="logger">AxoLogger</param>
    /// <returns>Application builder.</returns>
    IAxoApplicationBuilder ConfigureLogger(ILogger logger);

    /// <summary>
    /// Builds an AxoApplication.
    /// </summary>
    /// <returns>AxoApplication</returns>
    IAxoApplication Build();
}