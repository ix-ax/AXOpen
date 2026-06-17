using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- SIMATIC S7-1500 (Platform) ----------------------------------------------------------

    private const string Simatic1500DocDir = "src/showcase/app/src/simatic1500";

    public static ShowcasePageDescriptor Simatic1500Showcase { get; } = new()
    {
        Route = "/simatic1500/Documentation/Simatic1500Showcase",
        Title = "SIMATIC S7-1500 Showcase",
        LibraryNamespace = "AXOpen.S71500",
        Category = "SIMATIC",
        Vendor = null,
        Icon = "cpu-chip",
        BrandIcon = "cpu-chip",
        Description = "Platform-specific implementations of IAxoRtc (real-time clock) and IAxoRtm (runtime measurement) for the SIMATIC S7-1500 PLC family. These services are injected into AxoContext to provide system clock and elapsed time capabilities.",
        Tags = ["simatic", "s7-1500", "platform", "rtc", "rtm", "real-time-clock", "runtime-measurement"],
        NavGroup = "Foundation",
        NavOrder = 84,
        ContextSourcePath = $"{Simatic1500DocDir}/Simatic1500Showcase.st",
        SourceFilePaths =
        [
            $"{Simatic1500DocDir}/Simatic1500Showcase.st",
        ],
        LibrarySources =
        [
            new("src/simatic1500/ctrl/src/Rtc.st"),
            new("src/simatic1500/ctrl/src/Rtm.st"),
            new("src/simatic1500/ctrl/apax.yml"),
        ],
        // Zero-component platform library: the page renders the documentation context directly
        // (no per-component tabs). The layout drives rendering and polling from RootBind.
        RootBind = c => c.simatic1500_documentation,
    };
}
