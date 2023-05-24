// AXOpen.Base.Abstractions
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

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
    IAxoLogger Logger { get; }

    /// <summary>
    /// Gets current user.
    /// </summary>
    string CurrentUser { get; }
}