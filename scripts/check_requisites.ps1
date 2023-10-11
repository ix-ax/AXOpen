## Check pre-requisites

# List all installed .NET SDKs
$dotnetSDKs = (dotnet --list-sdks 2>$null)
$dotnet6Installed = $false
$dotnet7Installed = $false

foreach ($sdk in $dotnetSDKs) {
    if ($sdk -like "6.*") {
        $dotnet6Installed = $true
    }
    if ($sdk -like "7.*") {
        $dotnet7Installed = $true
    }
}

if (-not $dotnet6Installed) {
    Write-Host ".NET 6.0 SDK is not installed." -ForegroundColor Red
} else {
    Write-Host ".NET 6.0 SDK detected." -ForegroundColor Green
}

if (-not $dotnet7Installed) {
    Write-Error ".NET 7.0 SDK is not installed."
} else {
    Write-Host ".NET 7.0 SDK detected." -ForegroundColor Green
}

# Check for Visual Studio 2022
$vsWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (Test-Path $vsWhere) {
    $vsVersion = & $vsWhere -version "[17.0,18.0)" -products * -property catalog_productDisplayVersion
    if (-not $vsVersion) {
        Write-Host "Visual Studio 2022 is not detected." -ForegroundColor Yellow
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
try {
    $apaxVersion = (apax --version).Trim()
    if ($apaxVersion -eq "2.0.0") {
        Write-Host "Apax 2.0.0 detected." -ForegroundColor Green
        $isApaxInstalled = $true;
    } else {
        Write-Host "Apax version mismatch. Expected 2.0.0 but found $apaxVersion." -ForegroundColor Red
        Write-Host "Run apax self-update $apaxVersion." -ForegroundColor Red
    }
} catch {
    Write-Host "Apax is not installed or not found in PATH. You need to have valid SIMATIC-AX license." -ForegroundColor Red
}


$feedUrl = "https://nuget.pkg.github.com/ix-ax/index.json"

$headers = @{
    "Authorization" = "Bearer $userToken"
    "User-Agent"    = "PowerShell"
    "Accept"        = "application/vnd.github.package-preview+json"
}

$hasFeedAccess = $false;
try {
    # Just check the access by trying to get the feed
    $response = Invoke-RestMethod -Uri $feedUrl -Headers $headers -Method Get
    Write-Host "Successfully accessed feed: $feedUrl" -ForegroundColor Green
    $hasFeedAccess = $true;
}
catch {
    Write-Host "Failed to access feed: $feedUrl. Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "You will need to add $feed to your nuget sources manually (more information in src/README.md)." -ForegroundColor Red
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
if (-not $dotnet6Installed) {
    PromptAndDownload ".NET 6.0 SDK is not installed." "https://dotnet.microsoft.com/download/dotnet/6.0"
}
if (-not $dotnet7Installed) {
    PromptAndDownload ".NET 7.0 SDK is not installed." "https://dotnet.microsoft.com/download/dotnet/7.0"
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

if(-not $hasFeedAccess)
{
$nugetGuide = @"
To manually add the GitHub NuGet feed to your sources:

1. Generate a Personal Access Token on GitHub with 'read:packages', 'write:packages', and 'delete:packages' (if needed) permissions.
2. Open a command prompt or terminal.
3. Use the following command to add the feed to your NuGet sources:
   nuget sources Add -Name "GitHub" -Source "$feedUrl" -Username [YOUR_GITHUB_USERNAME] -Password [YOUR_PERSONAL_ACCESS_TOKEN]

Replace [YOUR_GITHUB_USERNAME] with your actual GitHub username and [YOUR_PERSONAL_ACCESS_TOKEN] with the token you generated.

Note: Treat your personal access token like a password. Keep it secure and do not share it.
"@    
    Write-Host "You need to add the GitHub NuGet feed to your sources manually." $nugetGuide
}