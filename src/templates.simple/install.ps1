
function OpenSolutionWithVS2022 {
    param(
        [Parameter(Mandatory=$true)]
        [string]$solutionPath
    )

    # Validate if the solution path exists
    if (-not (Test-Path $solutionPath)) {
        Write-Error "The provided solution path does not exist: $solutionPath"
        return
    }

    # Define the possible paths for each edition of Visual Studio 2022
    $enterprisePath = "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe"
    $professionalPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
    $communityPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"

    # Determine the most advanced edition installed
    $vsPath = $null
    if (Test-Path $enterprisePath) {
        $vsPath = $enterprisePath
    } elseif (Test-Path $professionalPath) {
        $vsPath = $professionalPath
    } elseif (Test-Path $communityPath) {
        $vsPath = $communityPath
    }

    # If we found an edition of VS2022, open the solution with it
    if ($vsPath) {
        & $vsPath $solutionPath
    } else {
        Write-Host "Visual Studio 2022 not found!"
    }
}

dotnet tool restore
dotnet clean this.proj
dotnet build this.proj
dotnet slngen this.proj -o axosimple.sln --folders true --launch false
OpenSolutionWithVS2022 -solutionPath axosimple.sln
Set-Location app
apax install
apax build
axcode .
axcode -g ..\README.md:0






