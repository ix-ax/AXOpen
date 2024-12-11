using System.Security.Principal;

namespace AXOpen;

/// <summary>
/// Provides identity for the operations from the controller.
/// </summary>
internal class ControllerIdentity() : GenericIdentity("Controller");