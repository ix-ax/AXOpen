using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- I/O (generic) -----------------------------------------------------------------------

    // The IO showcase keeps one .st file per component, each tagged with the standard
    // <ComponentDeclaration> / <Initialization> regions, so the shared Declaration()/Initialization()
    // helpers resolve the same snippets the original page loaded.
    private const string IoDocDir = "src/showcase/app/src/IO";

    public static ShowcasePageDescriptor IoShowcase { get; } = new()
    {
        Route = "/io/Documentation/IoShowcase",
        Title = "I/O Showcase",
        LibraryNamespace = "AXOpen.Io",
        Category = "I/O",
        Icon = "rectangle-group",
        BrandIcon = "rectangle-group",
        Description = "Hardware diagnostics, IO component monitoring, record access tools, and IO-Link module configuration. " +
                      "Each tab demonstrates a different IO library component with live PLC bindings and code examples.",
        Tags = ["io", "io-link", "hardware diagnostics", "record access", "et200sp", "axoiocomponent", "axohwdiag", "axorecordaccesstool"],
        NavGroup = "Foundation",
        NavOrder = 82,
        ContextSourcePath = $"{IoDocDir}/IoShowcase.st",
        SourceFilePaths =
        [
            $"{IoDocDir}/IoShowcase.st",
            $"{IoDocDir}/AxoIoComponent_Showcase.st",
            $"{IoDocDir}/AxoHwDiag_Showcase.st",
            $"{IoDocDir}/AxoRecordAccessTool_Showcase.st",
            $"{IoDocDir}/AxoIOLinkET200SP_Balluff_IO_Showcase.st",
        ],
        LibrarySources =
        [
            new("src/io/ctrl/src/AxoIoComponent/AxoIoComponent.st", "AxoIoComponent.st", Mono: false),
            new("src/io/ctrl/src/AxoHwDiag/AxoHwDiag.st", "AxoHwDiag.st", Mono: false),
            new("src/io/ctrl/src/AxoRecordAccessTool/AxoRecordAccessTool.st", "AxoRecordAccessTool.st", Mono: false),
            new("src/io/ctrl/apax.yml", "apax.yml", Mono: false),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoIoComponent",
                MaturityKey = "IO",
                Declaration = Declaration($"{IoDocDir}/AxoIoComponent_Showcase.st"),
                Initialization = Initialization($"{IoDocDir}/AxoIoComponent_Showcase.st"),
                Twin = c => c.io_documentation.axoIoComponent,
                Sequencer = c => c.io_documentation.axoIoComponent.Sequencer,
                Steps = c => c.io_documentation.axoIoComponent.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoHwDiag",
                MaturityKey = "IO",
                Declaration = Declaration($"{IoDocDir}/AxoHwDiag_Showcase.st"),
                Initialization = Initialization($"{IoDocDir}/AxoHwDiag_Showcase.st"),
                Twin = c => c.io_documentation.axoHwDiag,
                Sequencer = c => c.io_documentation.axoHwDiag.Sequencer,
                Steps = c => c.io_documentation.axoHwDiag.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoRecordAccessTool",
                MaturityKey = "IO",
                Declaration = Declaration($"{IoDocDir}/AxoRecordAccessTool_Showcase.st"),
                Initialization = Initialization($"{IoDocDir}/AxoRecordAccessTool_Showcase.st"),
                Twin = c => c.io_documentation.axoRecordAccessTool,
                Sequencer = c => c.io_documentation.axoRecordAccessTool.Sequencer,
                Steps = c => c.io_documentation.axoRecordAccessTool.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoIOLinkET200SP",
                MaturityKey = "IO",
                Declaration = Declaration($"{IoDocDir}/AxoIOLinkET200SP_Balluff_IO_Showcase.st"),
                Initialization = Initialization($"{IoDocDir}/AxoIOLinkET200SP_Balluff_IO_Showcase.st"),
                Twin = c => c.io_documentation.axoIOLinkET200SP_Balluff_IO,
                Sequencer = c => c.io_documentation.axoIOLinkET200SP_Balluff_IO.Sequencer,
                Steps = c => c.io_documentation.axoIOLinkET200SP_Balluff_IO.Steps,
            },
        ],
    };
}
