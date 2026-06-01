using System.Text;

namespace AXOpen.Dev.Scaffolding;

/// <summary>
/// Copies a component template tree to a destination, renaming directories/files that contain
/// the template name and replacing the template name + namespace inside text files.
/// Port of the copy/rename/sed steps in <c>create_complex_component.sh</c>.
/// </summary>
public static class ComponentScaffolder
{
    public static string Scaffold(
        string sourceDirectory,
        string destinationParent,
        string componentName,
        string componentNamespace,
        string templateName = "TemplateComponent",
        string templateNamespace = "Template.Axolibrary")
    {
        if (!Directory.Exists(sourceDirectory))
        {
            throw new DirectoryNotFoundException($"Source directory '{sourceDirectory}' does not exist.");
        }

        var finalDirectory = Path.Combine(destinationParent, componentName);
        if (Directory.Exists(finalDirectory) || File.Exists(finalDirectory))
        {
            throw new IOException($"Destination directory '{finalDirectory}' already exists.");
        }

        Directory.CreateDirectory(destinationParent);
        var copied = Path.Combine(destinationParent, Path.GetFileName(sourceDirectory.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)));
        CopyTree(sourceDirectory, copied);

        RenameDirectories(copied, templateName, componentName);
        // The copied root itself may carry the template name.
        var renamedRoot = RenameLeaf(copied, templateName, componentName);

        RenameFiles(renamedRoot, templateName, componentName);
        ReplaceInTextFiles(renamedRoot, templateName, componentName, templateNamespace, componentNamespace);

        return renamedRoot;
    }

    private static void CopyTree(string source, string destination)
    {
        Directory.CreateDirectory(destination);
        foreach (var dir in Directory.EnumerateDirectories(source, "*", SearchOption.AllDirectories))
        {
            Directory.CreateDirectory(dir.Replace(source, destination));
        }

        foreach (var file in Directory.EnumerateFiles(source, "*", SearchOption.AllDirectories))
        {
            File.Copy(file, file.Replace(source, destination), overwrite: false);
        }
    }

    private static void RenameDirectories(string root, string templateName, string componentName)
    {
        // Deepest first so parent renames don't invalidate child paths.
        var directories = Directory
            .EnumerateDirectories(root, "*", SearchOption.AllDirectories)
            .OrderByDescending(d => d.Length)
            .ToList();

        foreach (var dir in directories)
        {
            if (Path.GetFileName(dir).Contains(templateName, StringComparison.Ordinal))
            {
                RenameLeaf(dir, templateName, componentName);
            }
        }
    }

    private static void RenameFiles(string root, string templateName, string componentName)
    {
        foreach (var file in Directory.EnumerateFiles(root, "*", SearchOption.AllDirectories).ToList())
        {
            var name = Path.GetFileName(file);
            if (name.Contains(templateName, StringComparison.Ordinal))
            {
                var target = Path.Combine(Path.GetDirectoryName(file)!, name.Replace(templateName, componentName));
                File.Move(file, target);
            }
        }
    }

    private static string RenameLeaf(string path, string templateName, string componentName)
    {
        var name = Path.GetFileName(path);
        if (!name.Contains(templateName, StringComparison.Ordinal))
        {
            return path;
        }

        var target = Path.Combine(Path.GetDirectoryName(path)!, name.Replace(templateName, componentName));
        Directory.Move(path, target);
        return target;
    }

    private static void ReplaceInTextFiles(string root, string templateName, string componentName, string templateNamespace, string componentNamespace)
    {
        foreach (var file in Directory.EnumerateFiles(root, "*", SearchOption.AllDirectories))
        {
            var bytes = File.ReadAllBytes(file);
            if (Array.IndexOf(bytes, (byte)0) >= 0)
            {
                continue; // binary heuristic — skip (mirrors the bash `file | grep text` guard)
            }

            var text = Encoding.UTF8.GetString(bytes);
            var replaced = text
                .Replace(templateName, componentName)
                .Replace(templateNamespace, componentNamespace);

            if (!ReferenceEquals(text, replaced) && text != replaced)
            {
                File.WriteAllText(file, replaced, new UTF8Encoding(encoderShouldEmitUTF8Identifier: false));
            }
        }
    }
}
