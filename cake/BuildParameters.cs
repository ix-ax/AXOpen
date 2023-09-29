// Build
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md

using Cake.Common.Tools.DotNet;
using CommandLine;

public class BuildParameters
{
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

    [Option('v', "verbosity", Required = false, Default = DotNetVerbosity.Quiet, HelpText = "Verbosity (default Quiet)")]
    public DotNetVerbosity Verbosity { get; set; }

    [Option('l', "test-level", Required = false, Default = 1, HelpText = "Test level 1 - 3")]
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
}