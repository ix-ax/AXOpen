using System.ComponentModel;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Process;
using AXOpen.Dev.Requisites;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

/// <summary>axdev copy-ctrl-folders — port of scripts/copy-ctrl-folders.ps1.</summary>
[Description("Copy every 'ctrl' directory under a source tree into a destination, preserving structure.")]
public sealed class CopyCtrlFoldersVerb : Command<CopyCtrlFoldersVerb.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<DESTINATION>")]
        [Description("Target root directory the ctrl folders are copied into.")]
        public string Destination { get; init; } = string.Empty;

        [CommandOption("-s|--source <SOURCE>")]
        [Description("Source root to scan (defaults to ./src).")]
        public string Source { get; init; } = string.Empty;
    }

    public override int Execute(CommandContext context, Settings settings)
        => new CopyCtrlFoldersCommand().Execute(settings.Source, settings.Destination);
}

/// <summary>axdev check-system-requisites — full faithful port of scripts/check_requisites.ps1.</summary>
[Description("Verify (and optionally install) the developer-machine prerequisites: Node, VC++, Git, .NET SDK + Desktop Runtime, VS Build Tools, AX Code, Apax, registries.")]
public sealed class CheckSystemRequisitesVerb : AsyncCommand<CheckSystemRequisitesVerb.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandOption("-y|--yes")]
        [Description("Answer 'yes' to every install/set prompt (unattended install).")]
        public bool AssumeYes { get; init; }

        [CommandOption("--non-interactive")]
        [Description("Answer 'no' to every prompt (report-only; never installs).")]
        public bool NonInteractive { get; init; }
    }

    public override Task<int> ExecuteAsync(CommandContext context, Settings settings)
    {
        IUserPrompt prompt = settings.AssumeYes ? new FixedUserPrompt(true)
            : settings.NonInteractive ? new FixedUserPrompt(false)
            : new ConsoleUserPrompt();

        return new SystemRequisitesChecker(new ProcessRunner(), prompt, new HttpFileDownloader()).RunAsync();
    }
}
