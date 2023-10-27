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
    Write-Error ".NET 6.0 SDK is not installed."
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
        Write-Error "Visual Studio 2022 is not detected."
    } else {
        Write-Host "Visual Studio 2022 detected: $vsVersion" -ForegroundColor Green
    }
} else {
    Write-Error "vswhere tool not found. Unable to determine if Visual Studio 2022 is installed."
}

# Check for apax
try {
    $apaxVersion = (apax --version).Trim()
    if ($apaxVersion -eq "2.0.0") {
        Write-Host "Apax 2.0.0 detected." -ForegroundColor Green
    } else {
        Write-Error "Apax version mismatch. Expected 2.0.0 but found $apaxVersion."
        Write-Error "Run apax self-update $apaxVersion."
    }
} catch {
    Write-Error "Apax is not installed or not found in PATH. You need to have valid SIMATIC-AX license."
}


$feedUrl = "https://nuget.pkg.github.com/ix-ax/index.json"

$headers = @{
    "Authorization" = "Bearer $userToken"
    "User-Agent"    = "PowerShell"
    "Accept"        = "application/vnd.github.package-preview+json"
}


try {
    # Just check the access by trying to get the feed
    $response = Invoke-RestMethod -Uri $feedUrl -Headers $headers -Method Get
    Write-Host "Successfully accessed feed: $feedUrl" -ForegroundColor Green
}
catch {
    Write-Host "Failed to access feed: $feedUrl. Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "You will need to add $feed to your nuget sources manually (more information in src/README.md)." -ForegroundColor Red
}
