# Requires PowerShell 7+ for ConvertFrom-Yaml
# If you don't have it, install with: Install-Module powershell-yaml

Import-Module powershell-yaml -ErrorAction Stop

$root = Get-Location

# 1. Find all ctrl/apax.yml files
$apaxFiles = Get-ChildItem -Path $root -Recurse -Filter apax.yml | Where-Object {
    $_.FullName -match "\\ctrl\\apax\.yml$"
}

Write-Host "Found $($apaxFiles.Count) apax.yml files in ctrl directories:"
foreach ($file in $apaxFiles) {
    Write-Host "  $($file.FullName)"
}


# 2. Build a map: projectName -> ctrlPath, and parse dependencies
$projects = @{}
foreach ($file in $apaxFiles) {
    try {
        $ctrlDir = Split-Path $file.FullName -Parent
        Write-Host "Processing: $($file.FullName)"
        
        $yml = Get-Content $file.FullName -Raw | ConvertFrom-Yaml
        $name = $yml.name
        $deps = @()
        if ($yml.dependencies) {
            $deps = $yml.dependencies.Keys
        }
        
        Write-Host "  Project: $name"
        Write-Host "  Dependencies: $($deps -join ', ')"
        
        $projects[$name] = @{
            Path = $ctrlDir
            Deps = $deps
        }
    }
    catch {
        Write-Host "Error processing $($file.FullName): $_"
    }
}

Write-Host "Total projects found: $($projects.Count)"

# 3. Topological sort
function TopoSort {
    param (
        $projects
    )

    Write-Host "TopoSort called with $($projects.Count) projects"
    
    $script:visited = @{}
    $script:tempMark = @{}
    $script:result = @()

    function Visit {
        param($name)
        Write-Host "  Visiting: $name"
        
        if ($script:tempMark[$name]) {
            throw "Cyclic dependency detected at $name"
        }
       
        if (-not $script:visited[$name]) {
            Write-Host "    Processing: $name"
            $script:tempMark[$name] = $true
            foreach ($dep in $projects[$name].Deps) {
                Write-Host "      Checking dependency: $dep"
                if ($projects.ContainsKey($dep)) {
                    Write-Host "        Found dependency, visiting: $dep"
                    Visit $dep
                } else {
                    Write-Host "        Dependency not found in projects: $dep"
                }
            }
            $script:tempMark[$name] = $false
            $script:visited[$name] = $true
            $script:result += $name
            Write-Host "    Added to result: $name"
        } else {
            Write-Host "    Already visited: $name"
        }
    }

    Write-Host "Starting topological sort..."
    foreach ($name in $projects.Keys) {
        Write-Host "Starting with project: $name"
        Visit $name
    }
    
    Write-Host "TopoSort returning $($script:result.Count) items"
    return $script:result
}


$buildOrder = TopoSort $projects


Write-Host "Build order:"
$buildOrder | ForEach-Object { Write-Host "  $_" }
# 4. Build in order
foreach ($name in $buildOrder) {
    $ctrlPath = $projects[$name].Path
    Write-Host "Building $name in $ctrlPath"
    Set-Location $ctrlPath
    apax clean
    apax install
    apax build
    Set-Location $root
}

Write-Host "All builds completed in dependency order."