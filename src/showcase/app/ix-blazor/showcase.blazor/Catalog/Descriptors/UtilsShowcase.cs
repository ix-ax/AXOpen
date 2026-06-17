using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Utils (generic) ---------------------------------------------------------------------

    // The Utils showcase keeps its declarations and usage in one UtilsShowcase.st context with
    // per-aspect tagged regions (UtilsDeclarations / StringBuilderUsage / CrcUsage) rather than the
    // one-file-per-component ComponentDeclaration / Initialization convention the shared
    // Declaration()/Initialization() helpers assume. Snippet refs are therefore built inline so the
    // code-reference tab loads the same regions the original page did.
    private const string UtilsContextPath = "src/showcase/app/src/utils/UtilsShowcase.st";

    public static ShowcasePageDescriptor UtilsShowcase { get; } = new()
    {
        Route = "/utils/Documentation/UtilsShowcase",
        Title = "Utils Showcase",
        LibraryNamespace = "AXOpen.Utils",
        Category = "Utils",
        Icon = "wrench-screwdriver",
        BrandIcon = "wrench-screwdriver",
        Description = "String building with AxoStringBuilder and CRC checksum functions (CRC-8, CRC-16, CRC-32) " +
                      "for data integrity verification and string composition in PLC applications.",
        Tags = ["utils", "string", "CRC", "checksum", "builder", "axostringbuilder"],
        NavGroup = "Foundation",
        NavOrder = 86,
        ContextSourcePath = UtilsContextPath,
        SourceFilePaths =
        [
            UtilsContextPath,
        ],
        LibrarySources =
        [
            new("src/utils/ctrl/apax.yml"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "Utils",
                MaturityKey = "Utils",
                Declaration = new(UtilsContextPath, "UtilsDeclarations", "language-iecst",
                    Heading: "Utility declarations (ST)", RegionNote: "<UtilsDeclarations> region"),
                Initialization = new(UtilsContextPath, "StringBuilderUsage", "language-iecst",
                    Heading: "String builder usage (ST)", RegionNote: "<StringBuilderUsage> region"),
                ExtraSnippets =
                [
                    new(UtilsContextPath, "CrcUsage", "language-iecst",
                        Heading: "CRC checksum usage (ST)", RegionNote: "<CrcUsage> region"),
                ],
                Twin = c => c.utils_documentation,
                Sequencer = c => c.utils_documentation._automat,
                Steps = c => c.utils_documentation._automat.Steps,
            },
        ],
    };
}
