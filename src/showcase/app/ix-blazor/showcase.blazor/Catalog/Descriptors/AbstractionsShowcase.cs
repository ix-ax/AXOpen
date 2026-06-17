using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Abstractions ------------------------------------------------------------------------

    private const string AbstractionsContextPath = "src/showcase/app/src/abstractions/AbstractionsShowcase.st";

    public static ShowcasePageDescriptor AbstractionsShowcase { get; } = new()
    {
        Route = "/abstractions/Documentation/AbstractionsShowcase",
        Title = "Abstractions Showcase",
        LibraryNamespace = "AXOpen.Abstractions",
        Category = "Abstractions",
        Icon = "cube-transparent",
        BrandIcon = "cube-transparent",
        Description = "Core interfaces and enums that define the AXOpen contract layer: IAxoContext, IAxoObject, " +
                      "IAxoMessenger, IAxoLogger, IAxoRtc, IAxoRtm, eAxoMessageCategory, and eLogLevel. " +
                      "All AXOpen libraries build upon these abstractions.",
        Tags = ["abstractions", "interfaces", "enums", "iaxoobject", "iaxocontext", "messaging", "logging", "foundation"],
        NavGroup = "Foundation",
        NavOrder = 80,
        ContextSourcePath = AbstractionsContextPath,
        SourceFilePaths =
        [
            AbstractionsContextPath,
        ],
        LibrarySources =
        [
            new("src/abstractions/ctrl/apax.yml"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "Abstractions Showcase",
                MaturityKey = "Abstractions",
                // Non-standard snippet regions (not ComponentDeclaration/Initialization), so the
                // SnippetRefs are built inline with the actual region names from the .st file.
                Declaration = new(AbstractionsContextPath, "AbstractionsDeclarations", "language-iecst",
                    Heading: "Abstraction declarations (ST)", RegionNote: "<AbstractionsDeclarations> region"),
                Initialization = new(AbstractionsContextPath, "IAxoObjectUsage", "language-iecst",
                    Heading: "IAxoObject usage (ST)", RegionNote: "<IAxoObjectUsage> region"),
                ExtraSnippets =
                [
                    new(AbstractionsContextPath, "MessageCategoryUsage", "language-iecst",
                        Heading: "Message category enum (ST)", RegionNote: "<MessageCategoryUsage> region"),
                    new(AbstractionsContextPath, "LogLevelUsage", "language-iecst",
                        Heading: "Log level enum (ST)", RegionNote: "<LogLevelUsage> region"),
                ],
                Twin = c => c.abstractions_documentation,
            },
        ],
    };
}
