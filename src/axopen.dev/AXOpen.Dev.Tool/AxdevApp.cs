using AXOpen.Dev.Tool.Commands;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool;

/// <summary>
/// Builds the shared <see cref="CommandApp"/> used by both the packed dotnet tool
/// (<c>axdev</c>) and the in-repo file-based dispatcher (<c>src/scripts/axdev.cs</c>).
/// Descriptive verb names are canonical; the apax aliases are real invokable aliases.
/// </summary>
public static class AxdevApp
{
    public static CommandApp Build()
    {
        var app = new CommandApp();
        app.Configure(config =>
        {
            config.SetApplicationName("axdev");

            config.AddCommand<ValidateIpCommand>("validate-ip")
                .WithDescription("Validate an IPv4 address.");

            config.AddCommand<RestartPlcVerb>("restart-plc")
                .WithAlias("r")
                .WithDescription("Restart the PLC (STOP then RUN). apax alias: r");

            config.AddCommand<CleanPlcVerb>("clean-plc")
                .WithAlias("clean_plc")
                .WithDescription("Reset the PLC keeping only its IP. apax alias: clean_plc");

            config.AddCommand<ResetPlcVerb>("reset-plc")
                .WithAlias("reset_plc")
                .WithDescription("Full factory reset of the PLC. apax alias: reset_plc");

            config.AddCommand<HwDiagVerb>("hw-diag")
                .WithAlias("hdl")
                .WithDescription("List hardware diagnostics from the PLC. apax alias: hdl");

            config.AddCommand<CertCheckVerb>("cert-check")
                .WithDescription("Compare stored certificate SHA1 with the PLC's certificate.");

            config.AddCommand<CopyHardwareIdsVerb>("copy-hardware-ids")
                .WithAlias("hwid")
                .WithDescription("Generate HwIdentifiers.st + HwIdentifierList.st. apax alias: hwid");

            config.AddCommand<CopyIoAddressesVerb>("copy-io-addresses")
                .WithAlias("hwadr")
                .WithDescription("Generate Inputs.st + Outputs.st + IoStructures.st. apax alias: hwadr");

            config.AddCommand<HwCompileVerb>("hw-compile")
                .WithAlias("hwcc")
                .WithDescription("Compile the hardware configuration. apax alias: hwcc");

            config.AddCommand<GsdVerb>("install-gsd")
                .WithAlias("gsd")
                .WithDescription("Copy and install GSDML files. apax alias: gsd");

            config.AddCommand<HwlVerb>("copy-hwl-templates")
                .WithAlias("hwl")
                .WithDescription("Copy hardware library templates. apax alias: hwl");

            config.AddCommand<SetupSecureCommVerb>("setup-secure-communication")
                .WithAlias("ssc")
                .WithDescription("Set up secure communication + certificates. apax alias: ssc");

            config.AddCommand<HwFirstDownloadVerb>("hw-first-download")
                .WithAlias("hwfd")
                .WithDescription("First-time HW provisioning + download. apax alias: hwfd");

            config.AddCommand<HwFirstDownloadOnlyVerb>("hw-first-download-only")
                .WithAlias("hwfdo")
                .WithDescription("First HW download with master password + pull cert. apax alias: hwfdo");

            config.AddCommand<SwDownloadFullVerb>("sw-download-full")
                .WithAlias("swfdo")
                .WithDescription("Full software download via certificate. apax alias: swfdo");

            config.AddCommand<SwBuildDownloadFullVerb>("sw-build-download-full")
                .WithAlias("swfd")
                .WithDescription("Build + full software download. apax alias: swfd");

            config.AddCommand<SwDownloadDeltaVerb>("sw-download-delta")
                .WithAlias("swddo")
                .WithDescription("Delta software download via certificate. apax alias: swddo");

            config.AddCommand<SwBuildDownloadDeltaVerb>("sw-build-download-delta")
                .WithAlias("swdd")
                .WithDescription("Build + delta software download. apax alias: swdd");

            config.AddCommand<HwDownloadOnlyVerb>("hw-download-only")
                .WithAlias("hwdo")
                .WithDescription("Download compiled HW using certificate. apax alias: hwdo");

            config.AddCommand<DcpDiscoverVerb>("dcp-discover")
                .WithAlias("dcpd")
                .WithDescription("Discover PNIO devices from a source MAC. apax alias: dcpd");

            config.AddCommand<DcpListInterfacesVerb>("dcp-list-interfaces")
                .WithAlias("dcpli")
                .WithDescription("List network interfaces. apax alias: dcpli");

            config.AddCommand<PlcSimVerb>("plcsim")
                .WithDescription("Start PLCSIM Advanced (Windows only). apax alias: plcsim");

            config.AddCommand<HwUpdateVerb>("hw-update")
                .WithAlias("hwu")
                .WithDescription("Update HW: gsd + templates + compile + cert download. apax alias: hwu");

            config.AddCommand<CompareAllVerb>("compare-all")
                .WithAlias("cpa")
                .WithDescription("Compare online vs offline software (exit 0/9/10/11). apax alias: cpa");

            config.AddCommand<CheckRequisitesVerb>("check-requisites")
                .WithDescription("Check apax / NuGet / custom registry prerequisites.");

            config.AddCommand<CopyCtrlFoldersVerb>("copy-ctrl-folders")
                .WithDescription("Copy every 'ctrl' directory under a source tree into a destination.");

            config.AddCommand<CheckSystemRequisitesVerb>("check-system-requisites")
                .WithDescription("Verify/install developer-machine prerequisites (full check_requisites.ps1 port).");

            config.AddCommand<CompileAllVerb>("compile-all")
                .WithAlias("cla")
                .WithDescription("Compile HW + SW and pull certificate. apax alias: cla");

            config.AddCommand<CompileAllCompareAllVerb>("compile-all-compare-all")
                .WithAlias("cca")
                .WithDescription("Compile everything then compare. apax alias: cca");

            config.AddCommand<AllFirstVerb>("all-first")
                .WithAlias("alf")
                .WithDescription("Full initial PLC bring-up (HW + SW). apax alias: alf");

            config.AddCommand<AllVerb>("all")
                .WithAlias("a")
                .WithDescription("Smart update (first-setup / fast update / regenerate). apax alias: a");
        });
        return app;
    }
}
