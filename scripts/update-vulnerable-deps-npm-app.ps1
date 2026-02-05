#!/usr/bin/env pwsh
<#
.SYNOPSIS
Updates vulnerable npm dependencies in all directories matching the pattern **/app/ix-blazor/

.DESCRIPTION
This script finds all directories matching the pattern **/app/ix-blazor/ and runs npm audit fix
to automatically fix identified vulnerabilities.

.PARAMETER DryRun
If specified, only shows what would be done without making actual changes.

.PARAMETER Force
If specified, bypasses confirmation prompts.

.EXAMPLE
./update-vulnerable-deps.ps1
./update-vulnerable-deps.ps1 -DryRun
./update-vulnerable-deps.ps1 -Force
#>

param(
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Get the script's directory
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Find all directories matching **/app/ix-blazor/
Write-Host "Searching for directories matching pattern '**/app/ix-blazor/'..." -ForegroundColor Cyan

$targetDirs = @()
$appDirs = Get-ChildItem -Path $scriptRoot -Recurse -Filter "app" -Directory -ErrorAction SilentlyContinue

foreach ($appDir in $appDirs) {
    $ixBlazerPath = Join-Path -Path $appDir.FullName -ChildPath "ix-blazor"
    
    if (Test-Path -Path $ixBlazerPath -PathType Container) {
        $packageJsonPath = Join-Path -Path $ixBlazerPath -ChildPath "package.json"
        
        if (Test-Path -Path $packageJsonPath -PathType Leaf) {
            $targetDirs += @{
                Path = $ixBlazerPath
                PackageJson = $packageJsonPath
            }
        }
    }
}

if ($targetDirs.Count -eq 0) {
    Write-Host "No directories matching '**/app/ix-blazor/' with package.json found." -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($targetDirs.Count) directory/directories to process:" -ForegroundColor Green
foreach ($dir in $targetDirs) {
    Write-Host "  - $($dir.Path)" -ForegroundColor Gray
}

if (-not $Force) {
    Write-Host ""
    $confirmation = Read-Host "Continue with npm audit fix? (Y/n)"
    if ($confirmation -and $confirmation.ToLower() -ne 'y') {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Process each directory
$successCount = 0
$failureCount = 0

foreach ($dir in $targetDirs) {
    $dirPath = $dir.Path
    Write-Host ""
    Write-Host "Processing: $dirPath" -ForegroundColor Cyan
    
    try {
        Push-Location -Path $dirPath
        
        # Check if node_modules exists, install if not
        if (-not (Test-Path -Path "node_modules" -PathType Container)) {
            Write-Host "  Installing dependencies..." -ForegroundColor Gray
            if ($DryRun) {
                Write-Host "  [DRY RUN] Would run: npm install" -ForegroundColor Yellow
            }
            else {
                npm install
                if ($LASTEXITCODE -ne 0) {
                    Write-Host "  Failed to install dependencies" -ForegroundColor Red
                    $failureCount++
                    Pop-Location
                    continue
                }
            }
        }
        
        # Run npm audit to show vulnerabilities
        Write-Host "  Running npm audit..." -ForegroundColor Gray
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would run: npm audit fix" -ForegroundColor Yellow
            npm audit
        }
        else {
            npm audit fix
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Warning: npm audit fix completed with exit code $($LASTEXITCODE)" -ForegroundColor Yellow
            }
            else {
                Write-Host "  Successfully updated vulnerable dependencies" -ForegroundColor Green
                $successCount++
            }
        }
        
        Pop-Location
    }
    catch {
        Write-Host "  Error processing directory: $_" -ForegroundColor Red
        $failureCount++
        Pop-Location
    }
}

# Summary
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Processed: $($targetDirs.Count)" -ForegroundColor Gray
Write-Host "  Successful: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failureCount" -ForegroundColor $(if ($failureCount -gt 0) { "Red" } else { "Green" })
Write-Host "================================" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "[DRY RUN] No changes were made." -ForegroundColor Yellow
}

exit $(if ($failureCount -gt 0) { 1 } else { 0 })
