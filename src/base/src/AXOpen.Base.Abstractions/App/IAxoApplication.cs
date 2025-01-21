// AXOpen.Base.Abstractions
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/inxton/axsharp/blob/dev/notices.md

using System.Security.Principal;
using AXOpen.Logging;

namespace AXOpen;

/// <summary>
/// Provide access to the services of an AxoApplication.
/// </summary>
public interface IAxoApplication
{
    /// <summary>
    /// Gets logger configured for this application.
    /// </summary>
    ILogger Logger { get; }
    
    /// <summary>
    /// Provides identity for the logging operation for controller provenience.
    /// </summary>
    IIdentity ControllerIdentity { get; }
}