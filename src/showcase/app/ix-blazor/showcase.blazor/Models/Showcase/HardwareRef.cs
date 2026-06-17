namespace showcase.Models.Showcase;

/// <summary>
/// One hardware device shown on the "Hardware configuration" tab. Each (path, region) pair is a
/// tagged region loaded via <c>CodeSnippetProvider</c>: the device instance (in the line config),
/// the device template, and the IO-system wiring.
/// </summary>
public sealed class HardwareRef
{
    public required string Label { get; init; }

    public required string InstancePath { get; init; }
    public required string DeviceRegion { get; init; }

    public required string TemplatePath { get; init; }
    public required string TemplateRegion { get; init; }

    public required string IoSystemPath { get; init; }
    public required string IoSystemRegion { get; init; }

    public SnippetRef DeviceSnippet =>
        new(InstancePath, DeviceRegion, "language-yaml", RegionNote: $"<{DeviceRegion}> region");

    public SnippetRef TemplateSnippet =>
        new(TemplatePath, TemplateRegion, "language-yaml", RegionNote: $"<{TemplateRegion}> region", MaxHeight: "24rem");

    public SnippetRef IoSystemSnippet =>
        new(IoSystemPath, IoSystemRegion, "language-yaml", RegionNote: $"<{IoSystemRegion}> region");
}
