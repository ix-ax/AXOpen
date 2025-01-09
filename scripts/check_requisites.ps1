## Check pre-requisites

# List all installed .NET SDKs
$dotnetSDKs = (dotnet --list-sdks 2>$null)
$dotnet9Installed = $false

foreach ($sdk in $dotnetSDKs) {
    if ($sdk -like "9.0.100*") {
        $dotnet9Installed = $true
    }
}


if (-not $dotnet9Installed) {
    Write-Host ".NET 9.0.100 SDK is not installed." -ForegroundColor Red
} else {
    Write-Host ".NET 9.0.100 SDK detected." -ForegroundColor Green
}

# Check for Visual Studio 2022
$vsWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (Test-Path $vsWhere) {
    $requiredVersionRange = "[17.8.0,18.0)";
    $vsVersion = & $vsWhere -version $requiredVersionRange -products * -property catalog_productDisplayVersion
    if (-not $vsVersion) {
        Write-Host "Visual Studio 2022 is not detected in required version or update. Required version range is $requiredVersionRange" -ForegroundColor Yellow
        Write-Host "VS2022 is optional you can use any editor of your choice like VSCode, Rider, or you can even use AXCode to edit .NET files." -ForegroundColor Yellow
    } else {
        Write-Host "Visual Studio 2022 detected: $vsVersion" -ForegroundColor Green
        Write-Host "VS2022 is optional you can use any editor of your choice like VSCode, Rider, or you can even use AXCode to edit .NET files." -ForegroundColor DarkBlue
    }
} else {
    Write-Host "vswhere tool not found. Unable to determine if Visual Studio 2022 is installed." -ForegroundColor Yellow
    Write-Host "VS2022 is optional you can use any editor of your choice like VSCode, Rider, or you can even use AXCode to edit .NET files." -ForegroundColor Yellow
}

# Check for apax
$isApaxInstalled = $false
$requiredApaxVersion = "3.4.2"
try {
    $apaxVersion = (apax --version).Trim()
    if ($apaxVersion -eq $requiredApaxVersion) {
        Write-Host "Apax $requiredApaxVersion detected." -ForegroundColor Green
        $isApaxInstalled = $true;
    } else {
        Write-Host "Apax version mismatch. Expected $requiredApaxVersion but found $apaxVersion." -ForegroundColor Red
        Write-Host "Run apax self-update $apaxVersion." -ForegroundColor Red
    }
} catch {
    Write-Host "Apax is not installed or not found in PATH. You need to have valid SIMATIC-AX license." -ForegroundColor Red
}


$apaxUrl = "https://console.simatic-ax.siemens.io/"
$accessToApax = $false;
if($isApaxInstalled){
    try {
        # Just check the access by trying to get the feed
        $response = Invoke-RestMethod -Uri $apaxUrl -Method Get
        Write-Host "Feed: $apaxUrl accessible by means of network." -ForegroundColor Green
        $accessToApax = $true;
    }
    catch {
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
} catch {
    Write-Host "Error: Unable to access apax packages. Check your connections, firewall, credentials etc. : $($_.Exception.Message)" -ForegroundColor Red
}

# Define the command to get the version
$command = "axcode --version"

# Define the expected version
$expectedVersion = "1.94.2"

# Execute the command and capture the output
try {
    $version = Invoke-Expression $command
    
    # Compare the retrieved version with the expected version
    if ($version -eq $expectedVersion) {
        Write-Host "The AXCode version matches the expected version: $expectedVersion" -ForegroundColor Green
    } else {
        Write-Host "The AXCode version does not match the expected version: $expectedVersion" -ForegroundColor Red
    }
} catch {
    Write-Host "Error: Unable to determine the AXCode version. Ensure AXCode is correctly installed and accessible from the command line." -ForegroundColor Red
}


$headers = @{
    "Authorization" = "Bearer $userToken"
    "User-Agent"    = "PowerShell"
    "Accept"        = "application/vnd.github.package-preview+json"
}

$feedUrl = "https://nuget.pkg.github.com/ix-ax/index.json"

# Check if the feed is added
$isFeedAlreadyAdded = $false;
try {
    $feeds=$(dotnet nuget list source)

    $isFeedAlreadyAdded = $feeds | Select-String -Pattern $feedUrl

    if ($isFeedAlreadyAdded) {
        Write-Host "The NuGet feed with URL $feedUrl is already added."
    } else {
        Write-Host "The NuGet feed with URL $feedUrl is not added." -ForegroundColor Red
        Write-Host "You will need to add $feedUrl to your nuget sources manually (more information in src/README.md)." -ForegroundColor Red
    }
}
catch {
        Write-Host "Check if the NuGet feed with URL $feedUrl is properly added to your nuget sources." -ForegroundColor Red
}

# Check if the feed is accessible by means of network
$hasFeedAccess = $false;
if($isFeedAlreadyAdded){
    try {
        # Just check the access by trying to get the feed
        $response = Invoke-RestMethod -Uri $feedUrl -Headers $headers -Method Get
        Write-Host "Feed: $feedUrl accessible by means of network." -ForegroundColor Green
        $hasFeedAccess = $true;
    }
    catch {
        Write-Host "Failed to access feed: $feedUrl. Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Try to access it manually, check your connection, firewall setttings, etc. " -ForegroundColor Red
    }
}

$hasFeedAutorization = $false;
if($hasFeedAccess){
    try {     

        # $response = dotnet tool update axsharp.ixc --prerelease
        $status = $?
        if($status -match "^(?i)true$")
        {         
            write-host "Authentification passed successfully while accessing feed $feedurl."  -foregroundcolor green   
            $hasfeedautorization = $true; 
        }
        else
        {
            Write-Host "Authentification error when trying to access the feed $feedUrl. "  -ForegroundColor Red    
        } 
    } 
    catch {     
		    Write-Host "Authentification error when trying to access the feed  $feedUrl : $($_.Exception.Message)"   -ForegroundColor Red    
    }
}

# Define a function to prompt and download
function PromptAndDownload {
    param(
        [string]$message,
        [string]$downloadLink
    )

    $response = Read-Host "$message Would you like to download it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') {        
        Start-Process $downloadLink    
    }
}

# Check .NET SDKs
if (-not $dotnet9Installed) {
    $response = Read-Host ".NET 9.0 SDK is not installed. Would you like to install it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') {        
        winget install Microsoft.DotNet.SDK.9    
    }
}

# Check for Visual Studio 2022
if (-not $vsVersion) {
    PromptAndDownload "Visual Studio 2022 is not detected." "https://visualstudio.microsoft.com/vs/"
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

if(-not ($isFeedAlreadyAdded  -and $hasFeedAccess -and $hasFeedAutorization))
{
$nugetGuide = @"
To manually add the GitHub NuGet feed to your sources:

1. Generate a Personal Access Token on GitHub with 'read:packages', 'write:packages', and 'delete:packages' (if needed) permissions.
2. Open a command prompt or terminal.
3. Use the following command to add the feed to your NuGet sources:
   dotnet nuget add source --username [YOUR_GITHUB_USERNAME] --password [YOUR_PERSONAL_ACCESS_TOKEN]  --store-password-in-clear-text --name gh-packages-ix-ax "https://nuget.pkg.github.com/ix-ax/index.json"
   
   Replace [YOUR_GITHUB_USERNAME] with your actual GitHub username and [YOUR_PERSONAL_ACCESS_TOKEN] with the token you generated.

Note: Treat your personal access token like a password. Keep it secure and do not share it.
"@    
    Write-Host "You need to add the GitHub NuGet feed to your sources manually." $nugetGuide
}

# Function to download VS Build Tools
function Download-VSBuildTools {
    $url = "https://aka.ms/vs/16/release/vs_buildtools.exe"
    $output = "vs_buildtools.exe"
    
    Write-Host "Downloading Visual Studio Build Tools..."
    Invoke-WebRequest -Uri $url -OutFile $output
    
    if (Test-Path $output) {
        Write-Host "Visual Studio Build Tools downloaded successfully."
    } else {
        Write-Host "Failed to download Visual Studio Build Tools."
        exit 1
    }
}

# Function to install VS Build Tools
function Install-VSBuildTools {
    Write-Host "Installing Visual Studio Build Tools..."
    
    #Start-Process -FilePath ".\vs_buildtools.exe --wait --norestart --nocache --passive --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK --add Microsoft.VisualStudio.Component.Windows10SDK.18362" -Wait
    .\vs_buildtools.exe --wait --norestart --nocache --passive --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK --add Microsoft.VisualStudio.Component.Windows10SDK.18362
    Write-Host "Visual Studio Build Tools installation completed."
}

# Expected path from the environment variable
$expectedVCToolsInstallDir = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.29.30133"

# Check if the environment variable exists
$vctoolsDir = [System.Environment]::GetEnvironmentVariable("VCToolsInstallDir", [System.EnvironmentVariableTarget]::Machine)

if ($vctoolsDir -and (Test-Path $vctoolsDir)) {
    # If the environment variable exists and the path is valid
    Write-Host "VCToolsInstallDir is set and the path exists: $vctoolsDir" -foregroundcolor green
} else {
    # If the environment variable doesn't exist or the path is invalid
    Write-Host "VCToolsInstallDir is not set correctly or the path does not exist." -foregroundcolor red

    # Prompt the user to confirm installation
    $userResponse = Read-Host "Would you like to download and install Visual Studio Build Tools? (Y/N)"
    
    if ($userResponse -eq 'Y' -or $userResponse -eq 'y') {
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
        
        if ($finalVCToolsInstallDir -eq $expectedVCToolsInstallDir -and (Test-Path $finalVCToolsInstallDir)) {
            Write-Host "VCToolsInstallDir is now set correctly: $finalVCToolsInstallDir"
        } else {
            Write-Host "Failed to set VCToolsInstallDir environment variable or path."
        }
    } else {
        # If the user declines installation
        Write-Host "Installation aborted by the user."
    }
}
