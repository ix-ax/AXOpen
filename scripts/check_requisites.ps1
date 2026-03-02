## Check pre-requisites
# Definition of the requisities and locations
####################################################################################
#                                       NODE                                       #
####################################################################################
$nodeRequiredVersion = "23.7.0"
####################################################################################
#                        MICROSOFT VISUAL C++ REDISTRIBUTABLE                      #
####################################################################################
$VCpRequiredVersion = "14.38.33135.0"
$VcpRegPath    = 'HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64'
$VcpUrl        = 'https://aka.ms/vs/17/release/vc_redist.x64.exe'
####################################################################################
#                                         GIT                                      #
####################################################################################
$gitRequiredVersion = "2.44.0"
####################################################################################
#                                       DOT NET                                    #
####################################################################################
$dotNetInstallationScriptLocation = "https://dot.net/v1/dotnet-install.ps1"
$dotNetSDKRequiredVersion = "10.0.100"
$dotNetDesktopRuntimeRequiredVersion = "8.0.22"
####################################################################################
#                                       AX CODE                                    # 
####################################################################################
$axCodeRequiredVersion = "1.94.2"
$axCodeDownloadUrl = "https://console.simatic-ax.siemens.io/downloads"
####################################################################################
#                                       APAX AX                                    #
####################################################################################
$apaxRequiredVersion = "4.1.1"
$apaxUrl = "https://console.simatic-ax.siemens.io/"
####################################################################################
#                                 APAX LOGIN INXTON                                #
####################################################################################
$inxtonRegistryUrl = "https://npm.pkg.github.com/"
$nugetFeedUrl = "https://nuget.pkg.github.com/inxton/index.json"
####################################################################################
#                             VISUAL STUDIO BUILD TOOLS                            #
####################################################################################
$vsBuildToolInstallationURL = "https://aka.ms/vs/16/release/vs_buildtools.exe"
$vsBuildToolInstallCommand = ".\vs_buildtools.exe --wait --norestart --nocache --passive --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK --add Microsoft.VisualStudio.Component.Windows10SDK.19041"
$vsBuildToolRequiredVersion = "16.11.36631.11"
$expectedVCToolsInstallDir = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.29.30133"
####################################################################################
#                                   VISUAL STUDIO                                  #
####################################################################################
$visualStudioRequiredVersionRange = "[17.8.0,19.0)";
$vsWhereLocation = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
########################################################################################################################################################################
#                            VERSION CHECKERS/HELPERS                              #
####################################################################################
# Function to check if the actual version is equal to required version 
function MajorMinorBuildRevisionEqual {
    param
    (
        [Parameter(Mandatory)][string]$Item,
        [Parameter(Mandatory)][string]$ActualVersion,
        [Parameter(Mandatory)][string]$RequiredVersion,
        [switch]$Silent
    )

    $retval = $false 

    $Actual = [version]$ActualVersion
    $Required = [version]$RequiredVersion

    if ($Actual -eq $Required) 
    {
        $retval = $true 
        if(-not $Silent)
        {
            Write-Host "The actual version of the $Item ($ActualVersion) is equal to required ($RequiredVersion)." -ForegroundColor Green 
        }

    } 
    elseif(-not $Silent) 
    { 
        Write-Host "The actual version of the $Item ($ActualVersion) is different to required ($RequiredVersion)." -ForegroundColor Red 
    } 
    return $retval
}
# Function to check if the actual version is equal or higher then required version 
function MajorMinorBuildRevisionEqualOrHigher {
    param
    (
        [Parameter(Mandatory)][string]$Item,
        [Parameter(Mandatory)][string]$ActualVersion,
        [Parameter(Mandatory)][string]$RequiredVersion,
        [switch]$Silent
    )

    $retval = $false 

    $Actual = [version]$ActualVersion
    $Required = [version]$RequiredVersion

    if ($Actual -ge $Required) 
    {
        $retval = $true 
        if(-not $Silent)
        {
            Write-Host "The actual version of the $Item ($ActualVersion) is equal or higher then required ($RequiredVersion)." -ForegroundColor Green 
        } 
    }
    elseif(-not $Silent)
    { 
        Write-Host "The actual version of the $Item ($ActualVersion) is lower then required ($RequiredVersion)." -ForegroundColor Red 
    } 
    return $retval
}
# Function to check if the major and minor version is equal and build and revision version is equal or higher
function MajorMinorEqualBuildRevisionEqualOrHigher {
    param
    (
        [Parameter(Mandatory)][string]$Item,
        [Parameter(Mandatory)][string]$ActualVersion,
        [Parameter(Mandatory)][string]$RequiredVersion,
        [switch]$Silent
    )

    $retval = $false 

    $Actual = [version]$ActualVersion
    $Required = [version]$RequiredVersion

    if ($Actual.Major -eq $Required.Major -and $Actual.Minor -eq $Required.Minor -and $Actual.Build -ge $Required.Build -and $Actual.Revision -ge $Required.Revision ) 
    {
        $retval = $true 
        if(-not $Silent)
        {
            Write-Host "The actual version of the $Item ($ActualVersion) fits the required one ($RequiredVersion)."  -ForegroundColor Green 
        }
    } 
    elseif(-not $Silent) 
    { 
        Write-Host "The actual version of the $Item ($ActualVersion) does not fit the required ($RequiredVersion)." -ForegroundColor Red 
    } 
    return $retval
}
# Function to check if the major minor and build version is equal and revision version is equal or higher
function MajorMinorBuildEqualRevisionEqualOrHigher {
    param
    (
        [Parameter(Mandatory)][string]$Item,
        [Parameter(Mandatory)][string]$ActualVersion,
        [Parameter(Mandatory)][string]$RequiredVersion,
        [switch]$Silent
    )

    $retval = $false 

    $Actual = [version]$ActualVersion
    $Required = [version]$RequiredVersion

    if ($Actual.Major -eq $Required.Major -and $Actual.Minor -eq $Required.Minor -and $Actual.Build -eq $Required.Build -and $Actual.Revision -ge $Required.Revision ) 
    {
        $retval = $true 
        if(-not $Silent)
        {
            Write-Host "The actual version of the $Item ($ActualVersion) fits the required one ($RequiredVersion)."  -ForegroundColor Green 
        }
    } 
    elseif(-not $Silent) 
    { 
        Write-Host "The actual version of the $Item ($ActualVersion) does not fit the required ($RequiredVersion)." -ForegroundColor Red 
    } 
    return $retval
}
function Refresh-Path {
    $machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $user    = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machine;$user"
}
Refresh-Path
####################################################################################
#                                      WINGET                                      #
####################################################################################
$winget = Get-Command winget -ErrorAction SilentlyContinue
if (-not $winget) {
    Write-Host "winget is not available on this system." -ForegroundColor Red
    $wingetGuide = @"
        To install winget:
            1. Proceed to: https://learn.microsoft.com/en-us/windows/package-manager/winget/.
            2. Follow the on-site instructions to download and install winget.
"@
    Write-Host $wingetGuide -ForegroundColor Yellow
    exit 1
}
####################################################################################
#                                     NODE.JS                                      #
####################################################################################
# Function to check if required version of Node.js is installed
function VerifyNode {
    param
    (
        [Parameter(Mandatory)][string]$RequiredVersion
    )

    $retval = $false 
    # Allow Major.Minor, Major.Minor.Patch, or extended build versions (e.g. 16.11.36631.11)
    if ($RequiredVersion -notmatch '^\d+\.\d+(\.\d+){0,2}$') {
        Write-Host "RequiredVersion must be 'Major.Minor' (e.g. 8.0), 'Major.Minor.Patch' (e.g. 8.0.2), or extended (e.g. 16.11.36631.11)." -ForegroundColor Red
        return $retval
        exit 1
    }

    try
    {
        $nodeVersion = (node -v).TrimStart('v')
        if(MajorMinorBuildRevisionEqualOrHigher -Item "Node.js" -ActualVersion $nodeVersion -RequiredVersion $RequiredVersion)
        {
            $retval = $true
        }
    }
    catch
    {
        Write-Host "Node.js is not installed or not found in PATH." -ForegroundColor Red
        $retval = $false
        return $retval
    }
    return $retval
}

# Function to download and install Node.js
function InstallNode{
    param([Parameter(Mandatory)][string]$RequiredVersion)
    Write-Host "Installing Node.js LTS via winget..."

    $packageId = "OpenJS.NodeJS.LTS"

    winget install `
        --id $packageId `
        --exact `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements
    
    $env:Path = "$env:ProgramFiles\nodejs;$env:Path"

    # Verify
    $nodeVersion = (node -v).Trim()
    if(-not $nodeVersion)
    {
        Write-Host "Error installing Node.js." -ForegroundColor Red
        exit 1
    }
    else
    {
        Write-Host "Node.js succefully installed." -ForegroundColor Green
    }
    node -v
}

# Check Node
if (-not (VerifyNode -RequiredVersion $nodeRequiredVersion)) 
{
    $response = Read-Host "Node.js $nodeRequiredVersion is not installed. Would you like to install it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') { 
        InstallNode -RequiredVersion $nodeRequiredVersion
    }
}
####################################################################################
#                        MICROSOFT VISUAL C++ REDISTRIBUTABLE                      #
####################################################################################
# Function to check if required version of Microsoft Visual C++ Redistributable is installed
function VerifyVcp {
    param
    (
        [Parameter(Mandatory)][string]$RequiredVersion
    )

    $retval = $false 
    # Allow Major.Minor, Major.Minor.Patch, or extended build versions (e.g. 16.11.36631.11)
    if ($RequiredVersion -notmatch '^\d+\.\d+(\.\d+){0,2}$') {
        Write-Host "RequiredVersion must be 'Major.Minor' (e.g. 8.0), 'Major.Minor.Patch' (e.g. 8.0.2), or extended (e.g. 16.11.36631.11)." -ForegroundColor Red
        return $retval
        exit 1
    }

    $vc = Get-ItemProperty $VcpRegPath -ErrorAction SilentlyContinue
    $actualVersion = $vc.Version.TrimStart('v')

    if ($vc -and $vc.Installed -eq 1 -and (MajorMinorBuildRevisionEqualOrHigher -Item "VC++ Redistributable" -ActualVersion $actualVersion -RequiredVersion $RequiredVersion)) 
    {
        $retval = $true
    } 

    if ($retval) 
    { 
        Write-Host "VC++ Redistributable $RequiredVersion detected." -ForegroundColor Green 
    } 
    else 
    { 
        Write-Host "VC++ Redistributable $RequiredVersion is not installed." -ForegroundColor Red 
    } 
    return $retval
}

# Function to download and install Microsoft Visual C++ Redistributable
function InstallVcp{
    param([Parameter(Mandatory)][string]$RequiredVersion)

    $installer  = "$env:TEMP\vc_redist.x64.exe"

    Write-Host "Downloading VC++ Redistributable..."
    Invoke-WebRequest $VcpUrl -OutFile $installer

    Write-Host "Installing VC++ Redistributable..."
    Start-Process $installer -ArgumentList '/install /quiet /norestart' -Wait

    Start-Sleep -Seconds 5

    if (-not (VerifyVcp -RequiredVersion $RequiredVersion)) {
        Write-Host "Error installing VC++ Redistributable ." -ForegroundColor Red
        exit 1
    }
    Write-Host "VC++ Redistributable $RequiredVersion installed successfully." -ForegroundColor Green
}

# Check VerifyVcp Visual C++ Redistributable
if (-not (VerifyVcp -RequiredVersion $VCpRequiredVersion)) 
{
    $response = Read-Host "Microsoft Visual C++ Redistributable $VCpRequiredVersion is not installed. Would you like to install it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') { 
        InstallVcp -RequiredVersion $VCpRequiredVersion
    }
}
####################################################################################
#                                       GIT                                        #
####################################################################################
# Function to check if required version of Git is installed
function VerifyGit {
    param
    (
        [Parameter(Mandatory)][string]$RequiredVersion
    )

    $retval = $false 
    # Allow Major.Minor, Major.Minor.Patch, or extended build versions (e.g. 16.11.36631.11)
    if ($RequiredVersion -notmatch '^\d+\.\d+(\.\d+){0,2}$') {
        Write-Host "RequiredVersion must be 'Major.Minor' (e.g. 8.0), 'Major.Minor.Patch' (e.g. 8.0.2), or extended (e.g. 16.11.36631.11)." -ForegroundColor Red
        return $retval
        exit 1
    }

    try
    {
        $actualVersion = git --version | Select-String -Pattern '([0-9]+\.[0-9]+\.[0-9]+)' | ForEach-Object { $_.Matches[0].Value }
        if(MajorMinorBuildRevisionEqualOrHigher -Item "Git" -ActualVersion $actualVersion -RequiredVersion $RequiredVersion)
        {
            $retval = $true
        }
    }
    catch
    {
        Write-Host "Git is not installed." -ForegroundColor Red
        $retval = $false
        return $retval
    }
    return $retval
}

# Function to download and install Git
function InstallGit{
    param([Parameter(Mandatory)][string]$RequiredVersion)
    Write-Host "Installing Git via winget..."

    $packageId = "Git.Git"

    winget install `
        --id $packageId `
        --exact `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements
    

    Start-Sleep -Seconds 10

    Refresh-Path

    if (-not (VerifyGit -RequiredVersion $RequiredVersion)) {
        Write-Host "Error installing Git." -ForegroundColor Red
        exit 1
    }
    Write-Host "Git $RequiredVersion installed successfully." -ForegroundColor Green


}

# Check Git
if (-not (VerifyGit -RequiredVersion $gitRequiredVersion)) 
{
    $response = Read-Host "Git $gitRequiredVersion is not installed. Would you like to install it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') { 
        InstallGit -RequiredVersion $gitRequiredVersion
    }
}
####################################################################################
#                                    DOT NET SDK                                   #
####################################################################################
# Function to check if required version of dotnet SDK is installed
function VerifyDotNetSDK {
    param
    (
        [Parameter(Mandatory)][string]$RequiredVersion
    )

    $retval = $false 
    # Allow Major.Minor, Major.Minor.Patch, or extended build versions (e.g. 16.11.36631.11)
    if ($RequiredVersion -notmatch '^\d+\.\d+(\.\d+){0,2}$') {
        Write-Host "RequiredVersion must be 'Major.Minor' (e.g. 8.0), 'Major.Minor.Patch' (e.g. 8.0.2), or extended (e.g. 16.11.36631.11)." -ForegroundColor Red
        return $retval
        exit 1
    }

    $dotnetDir = Join-Path $env:ProgramFiles "dotnet"
    $dotnetExe = Join-Path $dotnetDir "dotnet.exe"

    if (-not (Test-Path -LiteralPath $dotnetDir)) 
    {
        Write-Host "Directory $dotnetDir not found." -ForegroundColor Red
        $retval = $false
        return $retval
        exit 0
    }

    if (-not (Test-Path -LiteralPath $dotnetExe)) 
    {
        Write-Host "dotnet.exe not found at '$dotnetExe' (PATH may not be updated yet)." -ForegroundColor Red
        $retval = $false
        return $retval
        exit 0
    }

	$existingUserPath = [Environment]::GetEnvironmentVariable("PATH", "User") 
	if ($existingUserPath -notlike "*$dotnetDir*") 
       {
		$newUserPath = "$dotnetDir;$existingUserPath"
		[Environment]::SetEnvironmentVariable("PATH", $newUserPath, "User")
        Refresh-Path
	}
    $dotnetSDKs = & dotnet --list-sdks 2>$null
    foreach ($sdk in $dotnetSDKs) 
    {
        if ($sdk -match "^$([regex]::Escape($RequiredVersion))\s") {
            $retval = $true
            break
        }
    }
    if ($retval) 
    { 
        Write-Host ".NET $RequiredVersion SDK detected." -ForegroundColor Green 
    } 
    else 
    { 
        Write-Host ".NET $RequiredVersion SDK is not installed." -ForegroundColor Red 
    } 
    return $retval
}

# Function to download and install dotnet SDK
function InstallDotNetSDK {
    param([Parameter(Mandatory)][string]$RequiredVersion)

    $dotnetInstall = "dotnet-install.ps1"
    $installDir = Join-Path $env:ProgramFiles "dotnet"

    try {
        Write-Host "Downloading $dotnetInstall..."
        Write-Host "        The installer will request to run as administrator. Expect a prompt." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $dotNetInstallationScriptLocation -OutFile $dotnetInstall

        if (-not (Test-Path -LiteralPath $dotnetInstall)) {
            Write-Host "Failed to download $dotnetInstall." -ForegroundColor Red
            exit 1
        }

        $scriptPath = Join-Path $PSScriptRoot $dotnetInstall
        Write-Host "Installing .NET SDK $RequiredVersion to $installDir"

        $arguments = @(
            "-NoProfile"
            "-ExecutionPolicy Bypass"
            "-File `"$scriptPath`""
            "-Version `"$RequiredVersion`""
            "-InstallDir `"$installDir`""
            "-NoPath"   # we'll set PATH ourselves in this session (reliable)
        )

        $proc = Start-Process powershell.exe -ArgumentList ($arguments -join ' ')  -Verb RunAs -Wait -PassThru
        if ($proc.ExitCode -ne 0) {
            Write-Host "dotnet-install.ps1 failed with exit code $($proc.ExitCode)" -ForegroundColor Red
            exit 1
        }
        # Make dotnet available in *this* PowerShell session:
        $env:DOTNET_ROOT = $installDir
        if ($env:PATH -notlike "*$installDir*") 
        {
            $env:PATH = "$installDir;$env:PATH"
        }
        # Persist PATH for the current user (future shells)
		$existingUserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
		if ($existingUserPath -notlike "*$installDir*") 
        {
			$newUserPath = "$installDir;$existingUserPath"
			[Environment]::SetEnvironmentVariable("PATH", $newUserPath, "User")
		}
        $dotnetInstalled = VerifyDotNetSDK -RequiredVersion $RequiredVersion 
        if (-not $dotnetInstalled) {
            Write-Host "Error installing dotnet (or dotnet not visible in this session)." -ForegroundColor Red
            exit 1
        }
        Write-Host ".NET SDK $RequiredVersion installed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error installing dotnet: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
    finally {
        # cleanup silently
        Remove-Item -Path (Join-Path $PSScriptRoot $dotnetInstall) -Force -ErrorAction SilentlyContinue
    }
}

# Check .NET SDK
if (-not (VerifyDotNetSDK -RequiredVersion $dotNetSDKRequiredVersion)) 
{
    $response = Read-Host ".NET $dotNetSDKRequiredVersion SDK is not installed. Would you like to install it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') { 
        InstallDotNetSDK -RequiredVersion $dotNetSDKRequiredVersion
    }
}
####################################################################################
#                             DOT NET DESKTOP RUNTIME                              #
####################################################################################
# Function to check if required version of dotnet desktop runtime is installed
function VerifyDotNetDesktopRuntime {
    param
    (
        [Parameter(Mandatory)][string]$RequiredVersion,  
        [Parameter(Mandatory)][ValidateSet("x86","x64")][string]$Architecture
    )
    $retval = $false 
    # Allow Major.Minor, Major.Minor.Patch, or extended build versions (e.g. 16.11.36631.11)
    if ($RequiredVersion -notmatch '^\d+\.\d+(\.\d+){0,2}$') {
        Write-Host "RequiredVersion must be 'Major.Minor' (e.g. 8.0), 'Major.Minor.Patch' (e.g. 8.0.2), or extended (e.g. 16.11.36631.11)." -ForegroundColor Red
        return $retval
        exit 1
    }
    $dotnetDir = if ($Architecture -eq "x86") 
    {
        Join-Path ${env:ProgramFiles(x86)} "dotnet"
    } 
    else 
    {
        Join-Path $env:ProgramFiles "dotnet"
    }
    $dotnetExe = Join-Path $dotnetDir "dotnet.exe"

    if (-not (Test-Path -LiteralPath $dotnetDir)) 
    {
        Write-Host "Directory $dotnetDir not found." -ForegroundColor Red
        $retval = $false
        return $retval
        exit 0
    }

    if (-not (Test-Path -LiteralPath $dotnetExe)) 
    {
        Write-Host "dotnet.exe not found at '$dotnetExe' (PATH may not be updated yet)." -ForegroundColor Red
        $retval = $false
        return $retval
        exit 0
    }
    if ($Architecture -eq "x64") 
    {
	    $existingUserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
	    if ($existingUserPath -notlike "*$dotnetDir*") 
           {
		    $newUserPath = "$dotnetDir;$existingUserPath"
		    [Environment]::SetEnvironmentVariable("PATH", $newUserPath, "User")
            Refresh-Path
	    }
    }
    if ($Architecture -eq "x86") 
    {
        $runtimes = & $dotnetExe --list-runtimes 2>$null
    } 
    else 
    {
        $runtimes = & dotnet --list-runtimes 2>$null
    }
    

    # Extract versions like 8.0.1, 8.0.12, etc.
    $versions = foreach ($line in $runtimes) 
    {
        if ($line -match '^Microsoft\.WindowsDesktop\.App\s+([\d\.]+)\s') 
        {
            [version]$matches[1]
        }
    }
    foreach ($version in $versions) {
        if (MajorMinorEqualBuildRevisionEqualOrHigher -Item "DOT NET DESKTOP RUNTIME" -ActualVersion $version -RequiredVersion $RequiredVersion -Silent) 
        {
            $retval = $true
            break
        }
    }

    if ($retval) 
    { 
        Write-Host ".NET $dotNetDesktopRuntimeRequiredVersion runtime $Architecture detected." -ForegroundColor Green 
    } 
    else 
    { 
        Write-Host ".NET $dotNetDesktopRuntimeRequiredVersion runtime $Architecture is not installed." -ForegroundColor Red 
    } 
    return $retval
}

# Function to download and install dotnet desktop runtime
function InstallDotNetDesktopRuntime {
    param
    (
        [Parameter(Mandatory)][string]$RequiredVersion,  
        [Parameter(Mandatory)][ValidateSet("x86","x64")][string]$Architecture
    )
    $retval = $false 
    # Allow Major.Minor, Major.Minor.Patch, or extended build versions (e.g. 16.11.36631.11)
    if ($RequiredVersion -notmatch '^\d+\.\d+(\.\d+){0,2}$') {
        Write-Host "RequiredVersion must be 'Major.Minor' (e.g. 8.0), 'Major.Minor.Patch' (e.g. 8.0.2), or extended (e.g. 16.11.36631.11)." -ForegroundColor Red
        return $retval
        exit 1
    }

    $channel = ($RequiredVersion -split '\.')[0..1] -join '.'

    $url = "https://aka.ms/dotnet/$channel/windowsdesktop-runtime-win-$Architecture.exe"
    $installer = Join-Path $env:TEMP "dotnet-desktop-runtime-$channel-$Architecture.exe"

    Write-Host "Downloading .NET Desktop Runtime $channel ($Architecture)..."
    Write-Host "        The installer will request to run as administrator. Expect a prompt." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $url -OutFile $installer -UseBasicParsing

    Write-Host "Installing .NET Desktop Runtime $channel ($Architecture)..."
    $proc = Start-Process -FilePath $installer -ArgumentList "/install /quiet /norestart" -Verb RunAs -Wait -PassThru

    if ($proc.ExitCode -ne 0) 
    {
        Write-Host ".NET Desktop Runtime $channel ($Architecture) installation failed with exit code $($proc.ExitCode)." -ForegroundColor Red
        return $retval
        exit 1
    }

    # Verify post-install
    if (-not (VerifyDotNetDesktopRuntime -RequiredVersion $RequiredVersion -Architecture $Architecture)) 
    {
        Write-Host "Installation completed but verification failed for .NET Desktop Runtime $RequiredVersion ($Architecture)." -ForegroundColor Red
        return $retval
        exit 1
    }

    Write-Host ".NET Desktop Runtime $RequiredVersion ($Architecture) installed successfully." -ForegroundColor Green
}

# Check .NET desktop runtime x86
if (-not (VerifyDotNetDesktopRuntime -RequiredVersion $dotNetDesktopRuntimeRequiredVersion -Architecture x86)) 
{
    $response = Read-Host ".NET $dotNetDesktopRuntimeRequiredVersion runtime x86 is not installed. Would you like to install it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') 
    { 
        InstallDotNetDesktopRuntime -RequiredVersion $dotNetDesktopRuntimeRequiredVersion -Architecture x86
    }
}
# Check .NET desktop runtime x64
if (-not (VerifyDotNetDesktopRuntime -RequiredVersion $dotNetDesktopRuntimeRequiredVersion -Architecture x64)) 
{
    $response = Read-Host ".NET $dotNetDesktopRuntimeRequiredVersion runtime x64 is not installed. Would you like to install it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') 
    { 
        InstallDotNetDesktopRuntime -RequiredVersion $dotNetDesktopRuntimeRequiredVersion -Architecture x64
    }
}

####################################################################################
#                                       AX CODE                                    #
####################################################################################

# Define the command to get the version
$command = "axcode --version"
# Execute the command and capture the output
try 
{
    $version = Invoke-Expression $command
    $ActualVersion = $version.Item(0)
    # Compare the retrieved version with the expected version
    if (-not (MajorMinorBuildRevisionEqualOrHigher -Item "AX Code" -ActualVersion $ActualVersion -RequiredVersion $axCodeRequiredVersion))
    {
        Write-Host "The AXCode version does not match the expected version: $axCodeRequiredVersion. It's highly recommended to update it." -ForegroundColor Red
    }
} 
catch 
{
    Write-Host "Error: Unable to determine the AXCode version. Ensure AXCode is correctly installed and accessible from the command line." -ForegroundColor Red
    $axCodeGuide = @"
        1. Ensure that you have a valid SIMATIC AX license.
        2. Verify that you have access to $axCodeDownloadUrl.
        3. Download AX Code for Windows from $axCodeDownloadUrl.
        4. Install AX Code for Windows.
        5. Restart your computer.
        6. Run this script again.
"@    
    Write-Host "To install the AXCode:" -ForegroundColor Yellow
    Write-Host $axCodeGuide -ForegroundColor Yellow
    exit 1
}

####################################################################################
#                                 APAX INSTALATION                                 #
####################################################################################
$isApaxInstalled = $false
try 
{
    $apaxVersion = (apax --version).Trim()
    # Compare the retrieved version with the expected version
    if ((MajorMinorBuildRevisionEqualOrHigher -Item "APAX" -ActualVersion $apaxVersion -RequiredVersion $apaxRequiredVersion))
    {
        $isApaxInstalled = $true
    }
    else
    {
        Write-Host "The APAX version does not match the expected version: $apaxRequiredVersion. It's highly recommended to update it." -ForegroundColor Red
    }
} 
catch 
{
    Write-Host "Apax is not installed or not found in PATH. You need to have valid SIMATIC-AX license." -ForegroundColor Red
    try
    {
        $nodeVersion = (node -v).Trim()
    }
    catch
    {
        Write-Host "Node.js is not installed or not found in PATH." -ForegroundColor Red
        Write-Host "Installing Node.js LTS via winget..."

        $packageId = "OpenJS.NodeJS.LTS"

        $winget = Get-Command winget -ErrorAction SilentlyContinue
        if (-not $winget) {
             Write-Host "winget is not available on this system." -ForegroundColor Red
             exit 1
        }

        winget install `
            --id $packageId `
            --exact `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements
        
        $env:Path = "$env:ProgramFiles\nodejs;$env:Path"

        # Verify
        node -v
        npm -v

    }
}

# Check for Apax - Assuming there's a direct link for Apax
# (Note: You might want to guide users more specifically since Apax's installation might not be as straightforward as opening a URL.)
if (-not $isApaxInstalled) {
    $apaxGuide = @"
To download Apax:
    1. Proceed to: $axCodeDownloadUrl in your browser.
    2. Log in with your credentials.
    3. Follow the on-site instructions to download and install Apax.
"@
    Write-Host "Apax is not installed or not found in PATH. You need to have a valid SIMATIC-AX license." -ForegroundColor Yellow
    Write-Host $apaxGuide -ForegroundColor Yellow
}


####################################################################################
#                                 APAX LOGIN AX                                    #
####################################################################################
$accessToApax = $false;
if($isApaxInstalled)
{
    try 
    {
        # Just check the access by trying to get the feed
        $response = Invoke-RestMethod -Uri $apaxUrl -Method Get
        Write-Host "Feed: $apaxUrl accessible by means of network." -ForegroundColor Green
        $accessToApax = $true;
    }
    catch 
    {
        Write-Host "Failed to access feed: $apaxUrl. Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Try to access it manually, check your connection, firewall setttings, etc. " -ForegroundColor Red
    }
}

# Check for apax
$isApaxAccessible = $false
try {
    $command = "apax info --ax-scopes"
    $resp = cmd /c $command  '2>&1'
    Write-Host "resp $resp"  -ForegroundColor Yellow    
    if($resp[2].ToString().Contains("No access to the Simatic-AX registry"))
    {         
        Write-Host "Unable to access apax packages."  -ForegroundColor Red 
        Write-Host "$errorOutput"  -ForegroundColor Red 
        $apaxGuide = @"
            1. Check your connections, firewall, credentials etc.
            2. Proceed to: $apaxUrl in your browser aand verify that it is accessible.
            3. Log in with your credentials.
            4. In the AX code environment run 'apax login' command.
            5. Choose the 'AX (for Apax packages and IDE extensions)'
            6. Log in with your credentials.
            7. Run this script again.
"@    
        Write-Host $apaxGuide -ForegroundColor Yellow   
        exit 1   
    }
    else
    {
        Write-Host "Apax packages are accessible." -ForegroundColor Green   
        $isApaxAccessible = $true; 
    } 
} 
catch 
{
    Write-Host "Error: Unable to access apax packages. Check your connections, firewall, credentials etc. : $($_.Exception.Message)" -ForegroundColor Red
    exit 1   
}

####################################################################################
#                                 APAX LOGIN INXTON                                #
####################################################################################

# Check the access to the external @inxton registry
$jsonData = Get-Content -Raw -Path "$env:USERPROFILE\.apax\auth.json" | ConvertFrom-Json


# Check if the registry exists and extract values
if ($jsonData.PSObject.Properties.Name -contains $inxtonRegistryUrl) 
{
    $registryToken = $jsonData.$inxtonRegistryUrl.registryToken
    $userName = $jsonData.$inxtonRegistryUrl.userName

    $jsonFile = $env:USERPROFILE
    $maskedPath = $jsonFile -replace '\\[^\\]+$', '\<current_user_name>\.apax\auth.json'

    if ($registryToken.Length -gt 6) 
    {
        $maskedToken = $registryToken.Substring(0,5) + ("*" * ($registryToken.Length - 6)) + $registryToken[-1]
    }else 
    {
        $maskedToken = "*" * $registryToken.Length 
    }

    if ($userName.Length -gt 2) 
    {
        $maskedUserName = $userName.Substring(0,1) + ("*" * ($userName.Length - 2)) + $userName[-1]
    }else 
    {
        $maskedUserName  = "*" * $userName.Length  
    }

    Write-Host "Registry $inxtonRegistryUrl found in $maskedPath!" -ForegroundColor Green
    Write-Host "Registry Token: $maskedToken" -ForegroundColor Green
    Write-Host "User Name: $maskedUserName" -ForegroundColor Green
}else 
{
    Write-Host "Registry '$inxtonRegistryUrl' not found in $maskedPath." -ForegroundColor Red
    $registryGuide = @"
        1. Generate a Personal Access Token on GitHub with 'read:packages' permissions (at least).
        2. In AX code environment run 'apax login' command.
        3. Choose the 'Custom NPM registry'
        4. Enter the registry URL: $inxtonRegistryUrl 
        5. Enter your username
        6. Enter your personal access token
        7. Run this script again.
Note: Treat your personal access token like a password. Keep it secure and do not share it.
"@    
    Write-Host "You need to provide apax login to external registry." -ForegroundColor Yellow
    Write-Host $registryGuide  -ForegroundColor Yellow
    exit 1
}


$headers = @{
    "Authorization" = "Bearer $userToken"
    "User-Agent"    = "PowerShell"
    "Accept"        = "application/vnd.github.package-preview+json"
}

# Check if the feed is added
$isFeedAlreadyAdded = $false;
try 
{
    $feeds=$(dotnet nuget list source)

    $isFeedAlreadyAdded = $feeds | Select-String -Pattern $nugetFeedUrl

    if ($isFeedAlreadyAdded) 
    {
        Write-Host "The NuGet feed with URL $nugetFeedUrl is already added." -ForegroundColor Green
    } 
    else 
    {
        Write-Host "The NuGet feed with URL $nugetFeedUrl is not added." -ForegroundColor Red
        Write-Host "You will need to add $nugetFeedUrl to your nuget sources manually (more information in src/README.md)." -ForegroundColor Red
    }
}
catch 
{
        Write-Host "Check if the NuGet feed with URL $nugetFeedUrl is properly added to your nuget sources." -ForegroundColor Red
}

# Check if the feed is accessible by means of network
$hasFeedAccess = $false;
if($isFeedAlreadyAdded)
{
    try 
    {
        # Just check the access by trying to get the feed
        $response = Invoke-RestMethod -Uri $nugetFeedUrl -Headers $headers -Method Get
        Write-Host "Feed: $nugetFeedUrl accessible by means of network." -ForegroundColor Green
        $hasFeedAccess = $true;
    }
    catch 
    {
        Write-Host "Failed to access feed: $nugetFeedUrl. Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Try to access it manually, check your connection, firewall setttings, etc. " -ForegroundColor Red
    }
}

$hasFeedAutorization = $false;
if($hasFeedAccess)
{
    try 
    {     

        # $response = dotnet tool update axsharp.ixc --prerelease
        $status = $?
        if($status -match "^(?i)true$")
        {         
            write-host "Authentification passed successfully while accessing feed $nugetFeedUrl."  -foregroundcolor green   
            $hasfeedautorization = $true; 
        }
        else
        {
            Write-Host "Authentification error when trying to access the feed $nugetFeedUrl. "  -ForegroundColor Red    
        } 
    } 
    catch 
    {     
		    Write-Host "Authentification error when trying to access the feed  $nugetFeedUrl : $($_.Exception.Message)"   -ForegroundColor Red    
    }
}


if(-not ($isFeedAlreadyAdded  -and $hasFeedAccess -and $hasFeedAutorization))
{
$nugetGuide = @"
        To manually add the GitHub NuGet feed to your sources:

        1. Generate a Personal Access Token on GitHub with 'read:packages', 'write:packages', and 'delete:packages' (if needed) permissions.
        2. Open a command prompt or terminal.
        3. Use the following command to add the feed to your NuGet sources:
           dotnet nuget add source --username [YOUR_GITHUB_USERNAME] --password [YOUR_PERSONAL_ACCESS_TOKEN]  --store-password-in-clear-text --name gh-packages-inxton $nugetFeedUrl
   
           Replace [YOUR_GITHUB_USERNAME] with your actual GitHub username and [YOUR_PERSONAL_ACCESS_TOKEN] with the token you generated.

        Note: Treat your personal access token like a password. Keep it secure and do not share it.
"@    
    Write-Host "You need to add the GitHub NuGet feed to your sources manually." -ForegroundColor Yellow
    Write-Host $nugetGuide -ForegroundColor Yellow
    exit 0
}

####################################################################################
#                             VISUAL STUDIO BUILD TOOLS                            #
####################################################################################
# Check if VS Build Tools is installed 
function Verify-VSBuildTools 
{
    param
    (
        [Parameter(Mandatory)][string]$RequiredVersion
    )
    $retval = $false 
    # Allow Major.Minor, Major.Minor.Patch, or extended build versions (e.g. 16.11.36631.11)
    if ($RequiredVersion -notmatch '^\d+\.\d+(\.\d+){0,2}$') {
        Write-Host "RequiredVersion must be 'Major.Minor' (e.g. 8.0), 'Major.Minor.Patch' (e.g. 8.0.2), or extended (e.g. 16.11.36631.11)." -ForegroundColor Red
        return $retval
        exit 1
    }
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

    if (-not (Test-Path $vswhere)) {
        Write-Host "vswhere.exe not found. Visual Studio Installer is missing." -ForegroundColor Red
        return $retval
        exit 1
    }

    $vsBuildToolsPath = & $vswhere  -products Microsoft.VisualStudio.Product.BuildTools -property installationPath

    if ($vsBuildToolsPath) 
    {
        Write-Host "Visual Studio Build Tools already installed at: $vsBuildToolsPath"  -ForegroundColor Green
        $vsBuildToolsVersion = & $vswhere  -products Microsoft.VisualStudio.Product.BuildTools -property installationVersion
        $retval = MajorMinorEqualBuildRevisionEqualOrHigher -Item "Visual Studio Build Tools" -ActualVersion $vsBuildToolsVersion -RequiredVersion $RequiredVersion
    }
    # Check if the VSBuildTools default installation path exists
    if (Test-Path $expectedVCToolsInstallDir) 
    {
        Write-Host "VSBuildTools default installation path exists: $expectedVCToolsInstallDir" -ForegroundColor Green
    } 
    else
    {
        Write-Host "VSBuildTools default installation path could not be found: $expectedVCToolsInstallDir" -ForegroundColor Red
        $retval = $false
        return $retval
        exit 1   
    } 
    return $retval
}

# Function to install VS Build Tools
function Install-VSBuildTools 
{
    Write-Host "VS Build Tools not found. Installing..."

    $outFile = [System.IO.Path]::GetFileName($vsBuildToolInstallationURL)

    try
    {
        Invoke-WebRequest -Uri $vsBuildToolInstallationURL -OutFile $outFile -UseBasicParsing
        Invoke-Expression $vsBuildToolInstallCommand 
        # Check if the VSBuildTools default installation path exists
        if (Test-Path $expectedVCToolsInstallDir) 
        {
            Write-Host "VSBuildTools default installation path exists: $expectedVCToolsInstallDir" -ForegroundColor Green
        } 
        else
        {
            Write-Host "VSBuildTools default installation path could not be found: $expectedVCToolsInstallDir" -ForegroundColor Red
            exit 1   
        } 
        try
        {
            # Set the environment variable after installation
            [System.Environment]::SetEnvironmentVariable("VCToolsInstallDir", $expectedVCToolsInstallDir, [System.EnvironmentVariableTarget]::User)
        }
        catch
        {
            Write-Host "Failed to set VCToolsInstallDir environment variable or path. You will need to set it manually." -ForegroundColor Red
            Write-Host "VCToolsInstallDir = $expectedVCToolsInstallDir" -ForegroundColor Red
            exit 1
        }
    }
    catch
    {
        Write-Host "VS Build Tools installation finished with an error."  -ForegroundColor Red
        exit 1
    }
    exit 0
}

# Check if VSBuildTools is installed
if (-not (Verify-VSBuildTools -RequiredVersion $vsBuildToolRequiredVersion)) 
{
    $response = Read-Host "VSBuildTools $vsBuildToolRequiredVersion is not installed. Would you like to install it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') 
    { 
        Install-VSBuildTools  -RequiredVersion $vsBuildToolRequiredVersion
    }
}

# Check if VCToolsInstallDir env var is set 
function Verify-VCToolsInstallDirEnvVar 
{
    param
    (
        [Parameter(Mandatory)][string]$RequiredValue
    )
    $retval = $false 
    
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

    if (-not (Test-Path $vswhere)) {
        Write-Host "vswhere.exe not found. Visual Studio Installer is missing." -ForegroundColor Red
        return $retval
        exit 1
    }

    $vsBuildToolsPath = & $vswhere  -products Microsoft.VisualStudio.Product.BuildTools -property installationPath

    if ($vsBuildToolsPath) 
    {
        Write-Host "Visual Studio Build Tools already installed at: $vsBuildToolsPath"  -ForegroundColor Green
    }
    # Check if the VSBuildTools default installation path exists
    if (Test-Path $RequiredValue) 
    {
        Write-Host "VSBuildTools default installation path exists: $RequiredValue" -ForegroundColor Green
    } 
    else
    {
        Write-Host "VSBuildTools default installation path could not be found: $RequiredValue" -ForegroundColor Red
        $retval = $false
        return $retval
        exit 1   
    } 
    # Check if the environment variable exists
    $vctoolsDir = [System.Environment]::GetEnvironmentVariable("VCToolsInstallDir", [System.EnvironmentVariableTarget]::User)

    if ($vctoolsDir -and $vctoolsDir -eq $RequiredValue) 
    {
        Write-Host "VCToolsInstallDir is set to: $vctoolsDir" -ForegroundColor Green
        $retval = $true
    } 
    else
    {
        Write-Host "VCToolsInstallDir is not set correctly."  -ForegroundColor Red
        $retval = $false
        return $retval
    } 
    return $retval
}

# Function to set VS Build Tools env var
function Set-VCToolsInstallDirEnvVar 
{
    param
    (
        [Parameter(Mandatory)][string]$RequiredValue
    )

    try
    {
        # Set the environment variable after installation
        [System.Environment]::SetEnvironmentVariable("VCToolsInstallDir", $RequiredValue, [System.EnvironmentVariableTarget]::User)
    }
    catch
    {
        Write-Host "Failed to set VCToolsInstallDir environment variable or path. You will need to set it manually." -ForegroundColor Red
        Write-Host "VCToolsInstallDir = $RequiredValue" -ForegroundColor Red
        exit 1
    }
}

# Check if VSBuildTools is installed
if (-not (Verify-VCToolsInstallDirEnvVar -RequiredValue $expectedVCToolsInstallDir)) 
{
    $response = Read-Host "VCToolsInstallDir environement variable is not properly set to: $expectedVCToolsInstallDir for the current user. Would you like to set it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') 
    { 
        Set-VCToolsInstallDirEnvVar  -RequiredValue $expectedVCToolsInstallDir
    }
}

####################################################################################
#                                   VISUAL STUDIO                                  #
####################################################################################
# Check for Visual Studio 
if (Test-Path $vsWhereLocation) 
{
    $vsVersion = & $vsWhereLocation -version $visualStudioRequiredVersionRange -products * -property catalog_productDisplayVersion
    if (-not $vsVersion) 
    {
        Write-Host "Visual Studio is not detected in required version or update. Required version range is $visualStudioRequiredVersionRange" -ForegroundColor Yellow
        Write-Host "Visual Studio is optional you can use any editor of your choice like VSCode, Rider, or you can even use AXCode to edit .NET files." -ForegroundColor Yellow
    } 
    else 
    {
        Write-Host "Visual Studio detected: $vsVersion" -ForegroundColor Green
        Write-Host "Visual Studio is optional you can use any editor of your choice like VSCode, Rider, or you can even use AXCode to edit .NET files." -ForegroundColor DarkBlue
    }
} 
else 
{
    Write-Host "vswhere tool not found. Unable to determine if Visual Studio is installed." -ForegroundColor Yellow
    Write-Host "Visual Studio is optional you can use any editor of your choice like VSCode, Rider, or you can even use AXCode to edit .NET files." -ForegroundColor Yellow
}

# Define a function to prompt and download
function PromptAndDownload {
    param(
        [string]$message,
        [string]$downloadLink
    )

    $response = Read-Host "$message Would you like to download it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') 
    {        
        Start-Process $downloadLink    
    }
}

# Check for Visual Studio
if (-not $vsVersion) {
    PromptAndDownload "Visual Studio is not detected." "https://visualstudio.microsoft.com/vs/"
}

