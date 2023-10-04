## Check pre-requisites

# Check for dotnet 7.0
$dotnetVersion = (dotnet --version 2>$null)
if (-not $dotnetVersion -or ($dotnetVersion -lt 7.0)) {
    Write-Error "dotnet 7.0 is not installed or an older version is detected."
} else {
    Write-Output "dotnet 7.0 detected."
}

# Check for Visual Studio 2022
$vsWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (Test-Path $vsWhere) {
    $vsVersion = & $vsWhere -version "[17.0,18.0)" -products * -property catalog_productDisplayVersion
    if (-not $vsVersion) {
        Write-Error "Visual Studio 2022 is not detected."
    } else {
        Write-Output "Visual Studio 2022 detected: $vsVersion"
    }
} else {
    Write-Error "vswhere tool not found. Unable to determine if Visual Studio 2022 is installed."
}

# Check for apax
try {
    apax --version | Out-Null
    Write-Output "Apax detected."
} catch {
    Write-Error "Apax is not installed or not found in PATH."
}

dotnet run --project cake/Build.csproj -- $args
exit $LASTEXITCODE;