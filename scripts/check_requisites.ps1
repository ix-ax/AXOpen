## Check pre-requisites
# Definition of the requisities and locations
$dotNetInstallationScriptLocation = "https://dot.net/v1/dotnet-install.ps1"
$dotNetRequiredVersion = "10.0.100"

$visualStudioRequiredVersionRange = "[17.8.0,18.0)";

$axCodeRequiredVersion = "1.94.2"

$apaxRequiredVersion = "4.1.1"
$apaxUrl = "https://console.simatic-ax.siemens.io/"

$inxtonRegistryUrl = "https://npm.pkg.github.com/"

$nugetFeedUrl = "https://nuget.pkg.github.com/inxton/index.json"


$vsWhereLocation = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$expectedVCToolsInstallDir = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.29.30133"

$vsBuildToolInstallerDownloadLocation = "https://aka.ms/vs/16/release/vs_buildtools.exe"
$vsBuildToolRequiredComponents = "--add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK --add Microsoft.VisualStudio.Component.Windows10SDK.18362"
####################################################################################
#                                       DOT NET                                    #
####################################################################################
# Function to check if required version of dotnet is installed
function VerifyDotNet {
    param(
        [Parameter(Mandatory)][string]$DotNetRequiredVersion,
        [string]$DotNetExePath
    )

    $dotnetInstalled = $false 

    if (-not $DotNetExePath) {
        # default per-user install path
        $DotNetExePath = Join-Path $env:USERPROFILE ".dotnet\dotnet.exe"
    }

    if (-not (Test-Path -LiteralPath $DotNetExePath)) {
        Write-Host "dotnet.exe not found at '$DotNetExePath' (PATH may not be updated yet)." -ForegroundColor Red
        $dotnetInstalled = $false
    }

    $dotnetSDKs = & $DotNetExePath --list-sdks 2>$null
    foreach ($sdk in $dotnetSDKs) {
        if ($sdk -match "^$([regex]::Escape($DotNetRequiredVersion))\s") {
            $dotnetInstalled = $true
            break
        }
    }
    if ($dotnetInstalled) 
    { 
        Write-Host ".NET $dotNetRequiredVersion SDK detected." -ForegroundColor Green 
    } 
    else 
    { 
        Write-Host ".NET $dotNetRequiredVersion SDK is not installed." -ForegroundColor Red 
    } 
    return $dotnetInstalled
}

# Function to download and install dotnet
function InstallDotNet {
    param([Parameter(Mandatory)][string]$DotNetRequiredVersion)

    $dotnetInstall = "dotnet-install.ps1"
    $installDir = Join-Path $env:USERPROFILE ".dotnet"
    $dotnetExe  = Join-Path $installDir "dotnet.exe"

    try {
        Write-Host "Downloading $dotnetInstall..."
        Invoke-WebRequest -Uri $dotNetInstallationScriptLocation -OutFile $dotnetInstall

        if (-not (Test-Path -LiteralPath $dotnetInstall)) {
            Write-Host "Failed to download $dotnetInstall." -ForegroundColor Red
            exit 1
        }

        $scriptPath = Join-Path $PSScriptRoot $dotnetInstall
        Write-Host "Installing .NET SDK $DotNetRequiredVersion to $installDir"

        $arguments = @(
            "-NoProfile"
            "-ExecutionPolicy Bypass"
            "-File `"$scriptPath`""
            "-Version `"$DotNetRequiredVersion`""
            "-InstallDir `"$installDir`""
            "-NoPath"   # we'll set PATH ourselves in this session (reliable)
        )

        $proc = Start-Process powershell.exe -ArgumentList ($arguments -join ' ') -Wait -PassThru
        if ($proc.ExitCode -ne 0) {
            Write-Host "dotnet-install.ps1 failed with exit code $($proc.ExitCode)" -ForegroundColor Red
            exit 1
        }

        # Make dotnet available in *this* PowerShell session:
        $env:DOTNET_ROOT = $installDir
        if ($env:PATH -notlike "*$installDir*") {
            $env:PATH = "$installDir;$env:PATH"
        }

        $dotnetInstalled = VerifyDotNet -DotNetRequiredVersion $DotNetRequiredVersion -DotNetExePath $dotnetExe
        if (-not $dotnetInstalled) {
            Write-Host "Error installing dotnet (or dotnet not visible in this session)." -ForegroundColor Red
            exit 1
        }

        Write-Host ".NET SDK $DotNetRequiredVersion installed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error installing dotnet: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
    finally {
        # cleanup silently
        Remove-Item -Path (Join-Path $PSScriptRoot $dotnetInstall) -Force -ErrorAction SilentlyContinue
		# Persist PATH for the current user (future shells)
		$dotnetDir = Join-Path $env:USERPROFILE ".dotnet"

		$existingUserPath = [Environment]::GetEnvironmentVariable("PATH", "User")

		if ($existingUserPath -notlike "*$dotnetDir*") {
			$newUserPath = "$dotnetDir;$existingUserPath"
			[Environment]::SetEnvironmentVariable("PATH", $newUserPath, "User")
		}
    }
}

$dotnetInstalled = VerifyDotNet -DotNetRequiredVersion $dotNetRequiredVersion

# Check .NET SDKs
if (-not $dotnetInstalled) 
{
    $response = Read-Host ".NET $dotNetRequiredVersion SDK is not installed. Would you like to install it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') { 
        InstallDotNet $dotNetRequiredVersion
    }
}

####################################################################################
#                                       AX CODE                                    #
####################################################################################
# Function to check if the actual version is equal to required version 
function MajorMinorBuildRevisionEqual {
    param(
        [Parameter(Mandatory)][string]$Package,
        [Parameter(Mandatory)][string]$ActualVersion,
        [Parameter(Mandatory)][string]$RequiredVersion
    )

    $retval = $false 

    $Actual = [version]$ActualVersion
    $Required = [version]$RequiredVersion

    if ($Actual -eq $Required) 
    {
        Write-Host "The actual version of the $Package ($ActualVersion) is equal to required ($RequiredVersion)." -ForegroundColor Green 
        $retval = $true 
    } 
    else 
    { 
        Write-Host "The actual version of the $Package ($ActualVersion) is different to required ($RequiredVersion)." -ForegroundColor Red 
    } 
    return $retval
}
# Function to check if the actual version is equal or higher then required version 
function MajorMinorBuildRevisionEqualOrHigher {
    param(
        [Parameter(Mandatory)][string]$Package,
        [Parameter(Mandatory)][string]$ActualVersion,
        [Parameter(Mandatory)][string]$RequiredVersion
    )

    $retval = $false 

    $Actual = [version]$ActualVersion
    $Required = [version]$RequiredVersion

    if ($Actual -ge $Required) 
    {
        Write-Host "The actual version of the $Package ($ActualVersion) is equal or higher then required ($RequiredVersion)." -ForegroundColor Green 
        $retval = $true 
    } 
    else 
    { 
        Write-Host "The actual version of the $Package ($ActualVersion) is lower then required ($RequiredVersion)." -ForegroundColor Red 
    } 
    return $retval
}
# Function to check if the major and minor version  equal or and build and revision version is equal or higher
function MajorMinorEqualBuildRevisionEqualOrHigher {
    param(
        [Parameter(Mandatory)][string]$Package,
        [Parameter(Mandatory)][string]$ActualVersion,
        [Parameter(Mandatory)][string]$RequiredVersion
    )

    $retval = $false 

    $Actual = [version]$ActualVersion
    $Required = [version]$RequiredVersion

    if ($Actual.Major -eq $Required.Major -and $Actual.Minor -eq $Required.Minor  -and $Actual.Build -ge $Required.Build -and $Actual.Revision -ge $Required.Revision ) 
    {
        Write-Host "The actual version of the $Package ($ActualVersion) does fit the required ($RequiredVersion)."  -ForegroundColor Green 
        $retval = $true 
    } 
    else 
    { 
        Write-Host "The actual version of the $Package ($ActualVersion) does not fit the required ($RequiredVersion)." -ForegroundColor Red 
    } 
    return $retval
}

# Define the command to get the version
$command = "axcode --version"
# Execute the command and capture the output
try 
{
    $version = Invoke-Expression $command
    $ActualVersion = $version.Item(0)
    # Compare the retrieved version with the expected version
    if (-not (MajorMinorBuildRevisionEqualOrHigher -Package "AX Code" -ActualVersion $ActualVersion -RequiredVersion $axCodeRequiredVersion))
    {
        Write-Host "The AXCode version does not match the expected version: $axCodeRequiredVersion. It's highly recommended to update it." -ForegroundColor Red
    }
} 
catch 
{
    Write-Host "Error: Unable to determine the AXCode version. Ensure AXCode is correctly installed and accessible from the command line." -ForegroundColor Red
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
    if (-not (MajorMinorBuildRevisionEqualOrHigher -Package "APAX" -ActualVersion $apaxVersion -RequiredVersion $apaxRequiredVersion))
    {
        Write-Host "The APAX version does not match the expected version: $apaxRequiredVersion. It's highly recommended to update it." -ForegroundColor Red
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
            throw "winget is not available on this system."
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
1. Visit https://console.simatic-ax.siemens.io/downloads in your browser.
2. Log in with your credentials.
3. Follow the on-site instructions to download and install Apax.
"@
    Write-Host "Apax is not installed or not found in PATH. You need to have a valid SIMATIC-AX license." $apaxGuide -ForegroundColor Yellow
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
        Write-Host "Unable to access apax packages. Check your connections, firewall, credentials etc."  -ForegroundColor Red    
        Write-Host "$errorOutput"  -ForegroundColor Red    
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
Note: Treat your personal access token like a password. Keep it secure and do not share it.
"@    
    Write-Host "You need to provide apax login to external registry." $registryGuide

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
        Write-Host "The NuGet feed with URL $nugetFeedUrl is already added."
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
    Write-Host "You need to add the GitHub NuGet feed to your sources manually." $nugetGuide
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

exit 0




# Function to download VS Build Tools
function Download-VSBuildTools 
{
    $output = "vs_buildtools.exe"
    
    Write-Host "Downloading Visual Studio Build Tools..."
    Invoke-WebRequest -Uri $vsBuildToolInstallerDownloadLocation -OutFile $output
    
    if (Test-Path $output) 
    {
        Write-Host "Visual Studio Build Tools downloaded successfully."
    } 
    else 
    {
        Write-Host "Failed to download Visual Studio Build Tools."
        exit 1
    }
}

# Function to install VS Build Tools
function Install-VSBuildTools 
{
    Write-Host "Installing Visual Studio Build Tools..."
    
    .\vs_buildtools.exe --wait --norestart --nocache --passive $vsBuildToolRequiredComponents
    Write-Host "Visual Studio Build Tools installation completed."
}

# Check if the environment variable exists
$vctoolsDir = [System.Environment]::GetEnvironmentVariable("VCToolsInstallDir", [System.EnvironmentVariableTarget]::Machine)

if ($vctoolsDir -and (Test-Path $vctoolsDir)) 
{
    # If the environment variable exists and the path is valid
    Write-Host "VCToolsInstallDir is set and the path exists: $vctoolsDir" -foregroundcolor green
} 
else 
{
    # If the environment variable doesn't exist or the path is invalid
    Write-Host "VCToolsInstallDir is not set correctly or the path does not exist." -foregroundcolor red

    # Prompt the user to confirm installation
    $userResponse = Read-Host "Would you like to download and install Visual Studio Build Tools? (Y/N)"
    
    if ($userResponse -eq 'Y' -or $userResponse -eq 'y') 
    {
        # If the user confirms, download and install Visual Studio Build Tools
        Download-VSBuildTools
        Install-VSBuildTools

        try
        {
            # Set the environment variable after installation
            [System.Environment]::SetEnvironmentVariable("VCToolsInstallDir", $expectedVCToolsInstallDir, [System.EnvironmentVariableTarget]::Machine)
        }
        catch
        {
            Write-Host "Failed to set VCToolsInstallDir environment variable or path. You will need to set it manually." -foregroundcolor red
            Write-Host "VCToolsInstallDir = $expectedVCToolsInstallDir" -foregroundcolor red
        }
        # Verify that the environment variable and path are now correct
        $finalVCToolsInstallDir = [System.Environment]::GetEnvironmentVariable("VCToolsInstallDir", [System.EnvironmentVariableTarget]::Machine)
        
        if ($finalVCToolsInstallDir -eq $expectedVCToolsInstallDir -and (Test-Path $finalVCToolsInstallDir)) 
        {
            Write-Host "VCToolsInstallDir is now set correctly: $finalVCToolsInstallDir"
        } 
        else 
        {
            Write-Host "Failed to set VCToolsInstallDir environment variable or path."
        }
    } 
    else 
    {
        # If the user declines installation
        Write-Host "Installation aborted by the user."
    }
}
