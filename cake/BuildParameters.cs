// Build
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md

using Cake.Common.Tools.DotNet;
using CommandLine;

// Destination for package push and release creation. The --do-publish/--do-publish-release
// flags decide WHETHER to publish/release; this enum decides WHERE.
public enum PublishTarget { GitLab, GitHub }

public class BuildParameters
{
    // Default GitHub so the retained .github/workflows/* (which never pass this flag) keep their
    // original behavior unchanged. The GitLab pipeline always passes --publish-target gitlab|github
    // explicitly, so the default never affects it.
    [Option("publish-target", Required = false, Default = PublishTarget.GitHub,
        HelpText = "Package/release destination: gitlab | github")]
    public PublishTarget Target { get; set; }

    [Option('t', "do-test", Required = false, Default = false, HelpText = "Runs tests")]
    public bool DoTest { get; set; }

    [Option('d', "do-docs", Required = false, Default = false, HelpText = "Generates documentation")]
    public bool DoDocs { get; set; }

    [Option('k', "do-pack", Required = false, Default = false, HelpText = "Creates packages")]
    public bool DoPack { get; set; }

    [Option('p', "do-publish", Required = false, Default = false, HelpText = "Publishes packages")]
    public bool DoPublish { get; set; }

    [Option('c', "configuration", Required = false, Default = "Release", HelpText = "Configuration")]
    public string Configuration { get; set; }

    [Option('v', "verbosity", Required = false, Default = DotNetVerbosity.Minimal, HelpText = "Verbosity (default Quiet)")]
    public DotNetVerbosity Verbosity { get; set; }

    [Option('l', "test-level", Required = false, Default = 1, HelpText = "Test level 1 - 4")]
    public int TestLevel { get; set; }

    [Option('r', "do-publish-release", Required = false, Default = false, HelpText = "Publishes release on GH")]
    public bool DoPublishRelease { get; set; }

    [Option('u', "do-apax-update", Required = false, Default = false, HelpText = "Publishes release on GH")]
    public bool DoApaxUpdate { get; set; }

    [Option('d', "do-apax-install-re-download", Required = false, Default = false, HelpText = "Forces re-download of apax packages")]
    public bool DoApaxInstallReDownload { get; set; }

    [Option('x', "parallel", Required = false, Default = false, HelpText = "Parallelism of some parts of the build process.")]
    public bool Paralellize { get; set; }

    [Option('n', "clean-up", Required = false, Default = false, HelpText = "Cleans up build.")]
    public bool CleanUp { get; set; }

    [Option('b', "skip-build", Required = false, Default = false, HelpText = "Does not run build steps")]
    public bool NoBuild { get; set; }

    [Option('o', "do-publish-only", Required = false, Default = false, HelpText = "Skips all steps and publishes from pre-build artefacts.")]
    public bool PublishOnly { get; set; }

    [Option("do-template-test", Required = false, Default = false, HelpText = "Scaffolds a library from template.axolibrary and builds/tests it.")]
    public bool DoTemplateTest { get; set; }
}