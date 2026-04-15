#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Builds all libraries in the order specified in build-order.txt

.DESCRIPTION
    This script reads the build-order.txt file and executes apax clean, apax install, 
    and apax build commands for each library path in the specified order.
    Lines prefixed with '#' are treated as comments and ignored.

.PARAMETER BuildOrderFile
    Path to the build-order.txt file. Defaults to "axopen/src/build-order.txt"

.PARAMETER SkipClean
    Skip the apax clean command

.PARAMETER SkipInstall
    Skip the apax install command

.PARAMETER SkipBuild
    Skip the apax build command

.PARAMETER Verbose
    Show detailed output from apax commands

.EXAMPLE
    .\build-libraries.ps1
    Builds all libraries using the default build-order.txt file

.EXAMPLE
    .\build-libraries.ps1 -BuildOrderFile "custom-build-order.txt"
    Builds libraries using a custom build order file

.EXAMPLE
    .\build-libraries.ps1 -SkipClean
    Builds all libraries but skips the clean step

.EXAMPLE
    .\build-libraries.ps1 -Verbose
    Builds all libraries with detailed command output
#>

param(
    [string]$BuildOrderFile = "build-order.txt",
    [switch]$SkipClean,
    [switch]$SkipInstall,
    [switch]$SkipBuild,
    [switch]$Verbose
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to execute apax command
function Invoke-ApaxCommand {
    param(
        [string]$Command,
        [string]$WorkingDirectory,
        [string]$Description
    )
    
    Write-ColorOutput "`n[$Description] Executing: apax $Command" "Yellow"
    Write-ColorOutput "Working Directory: $WorkingDirectory" "Gray"
    
    # Store current location
    $originalLocation = Get-Location
    
    try {
        # Change to the working directory
        Set-Location $WorkingDirectory
        
        # Execute the apax command and capture all output
        if ($Verbose) {
            Write-ColorOutput "`n--- Command Output ---" "Cyan"
        }
        $result = & apax $Command 2>&1
        $exitCode = $LASTEXITCODE
        
        # Display the output if verbose mode is enabled
        if ($Verbose -and $result) {
            foreach ($line in $result) {
                Write-ColorOutput $line "White"
            }
        }
        if ($Verbose) {
            Write-ColorOutput "--- End Output ---`n" "Cyan"
        }
        
        if ($exitCode -eq 0) {
            Write-ColorOutput "[SUCCESS] $Description completed successfully" "Green"
            return $true
        } else {
            Write-ColorOutput "[ERROR] $Description failed with exit code $exitCode" "Red"
            # Always show error output, even in non-verbose mode
            if ($result -and -not $Verbose) {
                Write-ColorOutput "Error details:" "Red"
                foreach ($line in $result) {
                    Write-ColorOutput "  $line" "Red"
                }
            }
            return $false
        }
    }
    catch {
        Write-ColorOutput "[ERROR] Failed to execute apax $Command : $($_.Exception.Message)" "Red"
        return $false
    }
    finally {
        # Restore original location
        Set-Location $originalLocation
    }
}

# Main script execution
Write-ColorOutput "=== AXOpen Libraries Build Script ===" "Cyan"
Write-ColorOutput "Build Order File: $BuildOrderFile" "White"
Write-ColorOutput "Skip Clean: $SkipClean" "White"
Write-ColorOutput "Skip Install: $SkipInstall" "White"
Write-ColorOutput "Skip Build: $SkipBuild" "White"
Write-ColorOutput "Verbose Output: $Verbose" "White"

# Check if build-order.txt file exists
if (-not (Test-Path $BuildOrderFile)) {
    Write-ColorOutput "[ERROR] Build order file not found: $BuildOrderFile" "Red"
    exit 1
}

# Read the build order file
Write-ColorOutput "`nReading build order from: $BuildOrderFile" "Yellow"
$libraryPaths = Get-Content $BuildOrderFile | Where-Object { 
    $line = $_.Trim()
    $line -ne "" -and -not $line.StartsWith("#")
}

if ($libraryPaths.Count -eq 0) {
    Write-ColorOutput "[ERROR] No library paths found in build order file" "Red"
    exit 1
}

Write-ColorOutput "Found $($libraryPaths.Count) libraries to build" "Green"

# Track overall success
$overallSuccess = $true
$failedLibraries = @()

# Process each library path
foreach ($libraryPath in $libraryPaths) {
    $libraryPath = $libraryPath.Trim()
    
    # Skip empty lines
    if ([string]::IsNullOrWhiteSpace($libraryPath)) {
        continue
    }
    
    Write-ColorOutput "`n==========================================" "Cyan"
    Write-ColorOutput "Processing: $libraryPath" "Cyan"
    Write-ColorOutput "==========================================" "Cyan"
    
    # Check if the library directory exists
    if (-not (Test-Path $libraryPath)) {
        Write-ColorOutput "[WARNING] Library directory not found: $libraryPath" "Yellow"
        $failedLibraries += "$libraryPath (Directory not found)"
        $overallSuccess = $false
        continue
    }
    
    $librarySuccess = $true
    
    # Execute apax clean
    if (-not $SkipClean) {
        if (-not (Invoke-ApaxCommand -Command "clean" -WorkingDirectory $libraryPath -Description "Clean")) {
            $librarySuccess = $false
        }
    } else {
        Write-ColorOutput "[SKIPPED] Clean step" "Gray"
    }
    
    # Execute apax install
    if (-not $SkipInstall -and $librarySuccess) {
        if (-not (Invoke-ApaxCommand -Command "install" -WorkingDirectory $libraryPath -Description "Install")) {
            $librarySuccess = $false
        }
    } else {
        Write-ColorOutput "[SKIPPED] Install step" "Gray"
    }
    
    # Execute apax build
    if (-not $SkipBuild -and $librarySuccess) {
        if (-not (Invoke-ApaxCommand -Command "build" -WorkingDirectory $libraryPath -Description "Build")) {
            $librarySuccess = $false
        }
    } else {
        Write-ColorOutput "[SKIPPED] Build step" "Gray"
    }
    
    # Update overall success status
    if (-not $librarySuccess) {
        $overallSuccess = $false
        $failedLibraries += $libraryPath
    }
}

# Final summary
Write-ColorOutput "`n==========================================" "Cyan"
Write-ColorOutput "BUILD SUMMARY" "Cyan"
Write-ColorOutput "==========================================" "Cyan"

if ($overallSuccess) {
    Write-ColorOutput "`n[SUCCESS] All libraries built successfully!" "Green"
} else {
    Write-ColorOutput "`n[FAILURE] Some libraries failed to build:" "Red"
    foreach ($failedLib in $failedLibraries) {
        Write-ColorOutput "  - $failedLib" "Red"
    }
}

Write-ColorOutput "`nBuild script completed." "White"
exit $(if ($overallSuccess) { 0 } else { 1 }) 