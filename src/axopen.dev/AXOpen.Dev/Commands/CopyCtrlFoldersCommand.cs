using AXOpen.Dev.Observability;
using AXOpen.Dev.Utils;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Copies every <c>ctrl</c> directory under a source tree into a destination, preserving structure.
/// Port of <c>scripts/copy-ctrl-folders.ps1</c>.
/// </summary>
public sealed class CopyCtrlFoldersCommand
{
    public int Execute(string source, string destination)
    {
        if (string.IsNullOrWhiteSpace(destination))
        {
            Output.Error("Destination must not be empty.");
            return 1;
        }

        var sourceRoot = Path.GetFullPath(string.IsNullOrWhiteSpace(source) ? "src" : source);
        if (!Directory.Exists(sourceRoot))
        {
            Output.Error($"Source directory '{sourceRoot}' does not exist.");
            return 1;
        }

        var destinationRoot = Path.GetFullPath(destination);
        Directory.CreateDirectory(destinationRoot);

        var count = CtrlFolderCopier.Copy(sourceRoot, destinationRoot);
        if (count == 0)
        {
            Output.Warning($"No directories named 'ctrl' were found under '{sourceRoot}'.");
            return 0;
        }

        Output.Success($"Copied {count} 'ctrl' directories to '{destinationRoot}'.");
        return 0;
    }
}
