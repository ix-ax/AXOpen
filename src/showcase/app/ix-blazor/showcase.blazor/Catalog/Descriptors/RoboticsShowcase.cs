using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Robotics (Base) ---------------------------------------------------------------------

    private const string RoboticsDocDir = "src/showcase/app/src/components.robotics/Documentation";

    public static ShowcasePageDescriptor RoboticsShowcase { get; } = new()
    {
        Route = "/components-robotics/Documentation/RoboticsShowcase",
        Title = "Robotics",
        LibraryNamespace = "AXOpen.Components.Robotics",
        Category = "Robotics",
        Vendor = null,
        Icon = "cpu-chip",
        BrandIcon = "cpu-chip",
        Description = "Generic robotics base library providing abstract interfaces and common types for vendor-specific robot integrations. See the vendor-specific pages (ABB, KUKA, UR, Mitsubishi) for concrete component demos.",
        Tags = ["robotics", "base", "abstract", "interfaces", "utilities"],
        NavGroup = "Components",
        NavOrder = 14,
        ContextSourcePath = $"{RoboticsDocDir}/Robotics.st",
        SourceFilePaths =
        [
            $"{RoboticsDocDir}/Robotics.st",
        ],
        LibraryDocs =
        [
            new("src/components.robotics/docs/README.md", "README — Overview", Mono: false),
            new("src/components.robotics/docs/RoboticsUtilities.md", "Robotics Utilities — Guide", Mono: false),
            new("src/components.robotics/docs/VendorImplementations.md", "Vendor Implementations", Mono: false),
            new("src/components.robotics/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.robotics/ctrl/src/AxoRobotics/AxoRobot_Status.st"),
            new("src/components.robotics/ctrl/src/AxoRobotics/CalculateDistance.st"),
            new("src/components.robotics/ctrl/src/AxoRobotics/CoordinatesAreNearlyEqual.st"),
            new("src/components.robotics/ctrl/src/AxoRobotics/IsNearlyEqual.st"),
        ],
        // Zero-component utility library: the page renders the documentation context directly
        // (no per-component tabs). The layout drives rendering and polling from RootBind.
        RootBind = c => c.robotics_documentation,
    };
}
