# Define 
$axopenRepoDir = "..\"
$plcSimVirtualMemoryCardLocation = "..\..\plcsim"    
$sourceDir = "..\..\source"              
$resultDir = "..\..\app_test_results"
$plcName =  "plc_line"
$plcIpAddress =  "10.10.10.120"
$defaultFramework = "net9.0"
$defaultConfiguration = "Debug"
$defaultDotnetTimeout = 60
$restrictedAppNames = @("apax.traversal")

# Returns all apax yaml files with type 'app' inside the folder
function Get-AppTypeYamlFiles {
    param (
        [string]$repoPath
    )

    # Initialize collection
    $matchingFiles = @()

    # Check if the path exists
    if (-Not (Test-Path -Path $repoPath)) {
        Write-Error "The provided repository path does not exist: $repoPath"
        return $null
    }

    # Search for 'apax.yml' files
    Get-ChildItem -Path $repoPath -Recurse -Filter "apax.yml" -File | ForEach-Object {
        $filePath = $_.FullName

        # Read the YAML file content
        $yamlContent = Get-Content -Path $filePath

        # Extract the 'type' value
        $typeLine = $yamlContent | Where-Object { $_ -match '^type:\s*["'']?(.+?)["'']?$' }
        if ($typeLine) {
            $typeValue = $Matches[1]
            if ($typeValue -eq "app") {

                # Extract the 'name' value
                $nameLine = $yamlContent | Where-Object { $_ -match '^name:\s*["'']?(.+?)["'']?$' }
                $nameValue = if ($nameLine) { $Matches[1] } else { "Unnamed" }

                # Store the result as a custom object 
                $matchingFiles += [PSCustomObject]@{
                    FilePath = $filePath
                    AppName  = $nameValue
                }

            }
        } else {
            Write-Warning "The 'type' key was not found in file: $filePath"
        }
    }

    # Summary
    return $matchingFiles
}

# Returns all apax yaml files with type 'app' inside the folder excluding restricted
function Get-AppTypeYamlFilesExcludingRestricted {
    param (
        [string]$repoPath
    )

    # Initialize collection
    $matchingFiles = @()

    # Check if the path exists
    if (-Not (Test-Path -Path $repoPath)) {
        Write-Error "The provided repository path does not exist: $repoPath"
        return $null
    }

    # Search for 'apax.yml' files
    Get-ChildItem -Path $repoPath -Recurse -Filter "apax.yml" -File | ForEach-Object {
        $filePath = $_.FullName

        # Read the YAML file content
        $yamlContent = Get-Content -Path $filePath

        # Extract the 'type' value
        $typeLine = $yamlContent | Where-Object { $_ -match '^type:\s*["'']?(.+?)["'']?$' }
        if ($typeLine) {
            $typeValue = $Matches[1]
            if ($typeValue -eq "app") {

                # Extract the 'name' value
                $nameLine = $yamlContent | Where-Object { $_ -match '^name:\s*["'']?(.+?)["'']?$' }
                $nameValue = if ($nameLine) { $Matches[1] } else { "Unnamed" }

                # Store the result as a custom object only if $nameValue is not in the restrictedAppNames array
                if ($nameValue -notin $restrictedAppNames) {
                    $matchingFiles += [PSCustomObject]@{
                        FilePath = $filePath
                        AppName  = $nameValue
                    }
                }

            }
        } else {
            Write-Warning "The 'type' key was not found in file: $filePath"
        }
    }

    # Summary
    return $matchingFiles
}

# Initialiaze the PlcSim instance with the 'fresh' content
function InitializePlcSimInstance {
    param (
        [string]$memoryCardPath,
        [string]$instanceName
    )

    # Check if the path for the virtual memory card exists
    if (-Not (Test-Path -Path $memoryCardPath)) 
    {
        Write-Error "The provided path for the virtual memory card does not exist: $memoryCardPath"
        return $null
    }

    # Check if the instance name is not empty
    if (-Not ($instanceName)) 
    {
        Write-Error "The provided instance name is empty."
        return $null
    }

    #  Check if the instance folder already exists
    $instancePath = Join-Path -Path $memoryCardPath -ChildPath $instanceName
    if (Test-Path -Path $instancePath) 
    {
        Write-Output "The instance path $instancePath already exists. It needs to be cleaned before."
        # Find and delete all files and subfolders recursively
        DeleteAllFilesAndFolders -folder $instancePath
    }
    else
    {
        # Create the directory for the plcsim instance
        New-Item -Path $instancePath -ItemType Directory | Out-Null
        Write-Output "Directory:  $instancePath has been created."
    }

    # Copy files recursively with overwrite
    try 
    {
        $plcSimSourceDir = Join-Path -Path $sourceDir -ChildPath "plcsim"
        Copy-Item -Path "$plcSimSourceDir\*" -Destination $instancePath -Recurse -Force
        Write-Output "All files copied successfully from $plcSimSourceDir to $instancePath."
    }
    catch {
        Write-Error "An error occurred while copying files: $_"
    }
}

# Overwrite the necessary security files
function OverwriteSecurityFiles {
    param (
        [string]$appYamlFile,
        [string]$plcName
    )
    # Check if the application folder is not empty
    if (-Not ($appYamlFile)) 
    {
        Write-Error "The provided yaml of the application is empty."
        return $null
    }

    # Check if the application file exists
    if (-Not (Test-Path -Path $appYamlFile)) 
    {
        Write-Error "The provided application file  does not exist: $appYamlFile"
        return $null
    }

    # Check if the application folder exists
    $appFolder = Split-Path -Path $appYamlFile -Parent
    if (-Not (Test-Path -Path $appFolder)) 
    {
        Write-Error "The provided path for the application does not exist: $appFolder"
        return $null
    }

    # Check if the plc name is not empty
    if (-Not ($plcName)) 
    {
        Write-Error "The provided plc name is empty."
        return $null
    }


    #  Check if the certification folder already exists
    $appCertFolder = Join-Path -Path $appFolder -ChildPath "certs"
    if (Test-Path -Path $appCertFolder) 
    {
        Write-Output "The application certification folder $appCertFolder already exists. It needs to be cleaned before."
        # Find and delete all files and subfolders recursively
        DeleteAllFilesAndFolders -folder $appCertFolder
    }
    else
    {
        # Create the directory for the certification files
        New-Item -Path $appCertFolder -ItemType Directory | Out-Null
        Write-Output "Directory:  $appCertFolder has been created."
    }

    # Create the subdirectory for the certification files
    $appCertSubFolder = Join-Path -Path $appCertFolder -ChildPath $plcName
    New-Item -Path $appCertSubFolder -ItemType Directory | Out-Null
    Write-Output "Directory:  $appCertSubFolder has been created."

    # Copy certification file
    $sourceDir = Join-Path -Path $startDir -ChildPath "source"
    $plcSourceCertificateFile  = $plcName + ".cer"
    $plcSourceCertificate = Join-Path -Path $sourceDir -ChildPath $plcSourceCertificateFile
    if (Test-Path -Path $plcSourceCertificate)
    {
        # Copy the file to the destination directory
        try {
            Copy-Item -Path $plcSourceCertificate -Destination $appCertSubFolder -Force
            Write-Output "Certification file  '$plcSourceCertificateFile'  successfully copied to: $appCertSubFolder"
        }
        catch {
            Write-Error "Failed to copy the file: $_"
        }
    }
    else 
    {
        Write-Warning "File '$plcSourceCertificateFile' does not exist in the script's directory: $sourceDir"
    }

    #  Check if the hwc folder already exists
    $appHwcFolder = Join-Path -Path $appFolder -ChildPath "hwc"
    if (-not (Test-Path -Path $appHwcFolder)) 
    {
        Write-Error "The application hwc folder $appCertFolder does not exist."
        return $null
    }

    #  Check if the hwc.gen folder already exists
    $appHwcGenFolder = Join-Path -Path $appHwcFolder -ChildPath  "hwc.gen"
    if (Test-Path -Path $appHwcGenFolder) 
    {
        Write-Output "The application hwc.gen folder $appHwcGenFolder already exists. It needs to be cleaned before."
        # Find and delete all files and subfolders recursively
        DeleteAllFilesAndFolders -folder $appHwcGenFolder
    }
    else
    {
        # Create the directory for the security configuration file
        New-Item -Path $appHwcGenFolder -ItemType Directory | Out-Null
        Write-Output "Directory:  $appHwcGenFolder has been created."
    }

    # Copy certification file
    $sourceDir = Join-Path -Path $startDir -ChildPath "source"
    $securityConfigFile  = $plcName + ".SecurityConfiguration.json"
    $securityConfig = Join-Path -Path $sourceDir -ChildPath $securityConfigFile
    if (Test-Path -Path $securityConfig)
    {
        # Copy the file to the destination directory
        try {
            Copy-Item -Path $securityConfig -Destination $appHwcGenFolder -Force
            Write-Output "Security configuration file  '$securityConfigFile'  successfully copied to: $appHwcGenFolder"
        }
        catch {
            Write-Error "Failed to copy the file: $_"
        }
    }
    else 
    {
        Write-Warning "File '$securityConfigFile' does not exist in the script's directory: $sourceDir"
    }
}

# Delete all files and folders recursively
function DeleteAllFilesAndFolders {
    param (
        [string]$folder
    )
    # Check if the folder is not empty
    if (-Not ($folder)) 
    {
        Write-Error "The provided folder is empty."
        return $null
    }

    # Check if the folder exists
    if (-Not (Test-Path -Path $folder)) 
    {
        Write-Error "The provided folder does not exist: $folder"
        return $null
    }


    # Delete all files and folders inside the target directory
    try 
    {
        Get-ChildItem -Path $folder -Recurse -Force | Remove-Item -Recurse -Force
        Write-Output "All files and folders have been deleted from: $folder"
    }
    catch 
    {
        Write-Warning "Failed to delete some items: $_"
    }
}

# Run command and handle the exception and error
function Run-Command {
    param (
        [string]$Command
    )

    # Initialize result object
    $result = [PSCustomObject]@{
        Success = $false
        ExitCode = $null
        Output = @()
        Error = $null
    }

    try {
        # Execute the command and capture the output
        $CommandOutput = Invoke-Expression "$Command 2>&1" | ForEach-Object {
            # Write each line to the console immediately
            Write-Output $_
            # Add it to the result output
            $_
        }

        $result.Output = $CommandOutput

        # Check the exit code
        if ($LASTEXITCODE -eq 0) {
            $result.Success = $true
            $result.ExitCode = $LASTEXITCODE
        } else {
            $result.ExitCode = $LASTEXITCODE
            $result.Error = "Command finished with an error. Exit code: $LASTEXITCODE"
        }
    } catch {
        # Handle exceptions
        $result.Error = "An exception occurred: $($_.Exception.Message)"
        Write-Error $result.Error
    }

    return $result
}

# Returns blazor csproj files from the current folder lower
function Get-BlazorCsprojFiles {
    param (
        [string]$SearchPath = (Get-Location).Path
    )

    # Define the search pattern
    $searchPattern = "*blazor*.csproj"

    # Find files matching the criteria
    $matchingFiles = Get-ChildItem -Path $SearchPath -Recurse -File -Filter $searchPattern

    # Return the collection of matching files
    return $matchingFiles
}

# Start the dotnet tool and return result
function Start-DotNetTool {
    param (
        [string]$ProjectName,
        [string]$Arguments = ""
    )

    if (-Not (Test-Path -Path $ProjectName)) 
    {
        Write-Error "The project path does not exist: $ProjectName"
        return $null
    }

    try 
    {
        # Start the project using dotnet run
        Write-Output "Starting the project: $ProjectName"
        # Temporary files for output and error redirection
        $stdOutFile = [System.IO.Path]::GetTempFileName()
        $stdErrFile = [System.IO.Path]::GetTempFileName()

        $process = Start-Process -FilePath "dotnet" -ArgumentList "run --project $ProjectName $Arguments" -NoNewWindow -PassThru -RedirectStandardOutput  $stdOutFile -RedirectStandardError $stdErrFile
        $process.WaitForExit();

        # Read output and error streams
        $output = Get-Content $stdOutFile
        $errorOutput = Get-Content $stdErrFile

        # Check the exit code
        if ($process.ExitCode -eq 0) 
        {
            Write-Output "Command completed successfully."
            Write-Output $output
            return $true
        } 
        else 
        {
            Write-Error "Command failed with exit code: $($process.ExitCode)"
            Write-Error $errorOutput
            return $false
        }
    } 
    catch 
    {
        # Handle any exceptions
        Write-Error "An exception occurred: $_"
        return $false
    }
    finally 
    {
        # Cleanup temporary files
        Remove-Item -Path $stdOutFile, $stdErrFile -Force
    }
}

# Start the dotnet project and return result
function Start-DotNetProject {
    param (
        [string]$ProjectName,
        [string]$Framework = "net9.0",
        [string]$Configuration = "Debug",
        [int]$dotnetTimeout = 60
    )

    if (-Not (Test-Path -Path $ProjectName)) 
    {
        Write-Error "The project path does not exist: $ProjectName"
        return $null
    }

    try 
    {
        # Start the project using dotnet run
        Write-Output "Starting the project: $ProjectName"
        # Temporary files for output and error redirection
        $stdOutFile = [System.IO.Path]::GetTempFileName()
        $stdErrFile = [System.IO.Path]::GetTempFileName()

        $process = Start-Process -FilePath "dotnet" -ArgumentList "run --project $ProjectName -c $Configuration --framework $Framework" -NoNewWindow -PassThru -RedirectStandardOutput  $stdOutFile -RedirectStandardError $stdErrFile

        # Wait for the project to start or timeout
        Start-Sleep -Seconds $dotnetTimeout # Adjust based on expected startup time

        # Check if the process is running
        if (!$process.HasExited) 
        {
            Write-Output "Project started successfully."
            # Return success message or output
            # Read output and error streams
            $output = Get-Content $stdOutFile
            Write-Output $output

            # Stop the project
            Write-Output "Stopping the project: $ProjectName"
            Stop-Process -Id $process.Id -Force

            return $true
        } 
        else 
        {
            Write-Error "Project failed to start. Check for errors."
            # Read output and error streams
            $errorOutput = Get-Content $stdErrFile
            Write-Output $errorOutput
            Stop-Process -Id $process.Id -Force #???
            return $false
        }
    } 
    catch 
    {
        # Handle any exceptions
        Write-Error "An exception occurred: $_"
        return $false
    }
    finally 
    {
        # Cleanup temporary files
        Remove-Item -Path $stdOutFile, $stdErrFile -Force
    }
}

# Build and load PLC
function BuildAndLoadPlc {
    param (
        [string]$appYamlFile,
        [string]$appName
    )
    # Check if the application folder is not empty
    if (-Not ($appYamlFile)) 
    {
        Write-Error "The provided yaml of the application is empty."
        return $null
    }

    # Check if the application file exists
    if (-Not (Test-Path -Path $appYamlFile)) 
    {
        Write-Error "The provided application file  does not exist: $appYamlFile"
        return $null
    }
    # Check if the app name is not empty
    if (-Not ($appName)) 
    {
        Write-Error "The provided application name is empty."
        return $null
    }

    # Check if the application folder exists
    $appFolder = Split-Path -Path $appYamlFile -Parent
    if (-Not (Test-Path -Path $appFolder)) 
    {
        Write-Error "The provided path for the application does not exist: $appFolder"
        return $null
    }
    cd $appFolder
    # apax install
    $result = run-command -command "apax install"
    $result.output | foreach-object { write-output $_ }
    # apax plcsim
    $plcSimProjPath = [System.IO.Path]::GetFullPath((Join-Path -Path $appFolder -ChildPath "..\..\tools\src\PlcSimAdvancedStarter\PlcSimAdvancedStarterTool\PlcSimAdvancedStarterTool.csproj"))
    $result = Start-DotNetTool -ProjectName $plcSimProjPath -Arguments "-- startplcsim -x $appName -n $plcName -t $plcIpAddress" 
    $result.output | foreach-object { write-output $_ }
    # apax hwu
    $result = Run-Command -Command "apax hwu"
    $result.Output | ForEach-Object { Write-Output $_ }
    if ($($result.Success) -match "True") 
    {
	    $textToWrite = ",OK"	
    } 
    else 
    {
	    $textToWrite = ",NOK"	
    }
    Write-Result -TextToWrite $textToWrite -LogFilePath $logFilePath -AppendToSameLine
    # apax swfd
    $result = Run-Command -Command "apax swfd"
    $result.Output | ForEach-Object { Write-Output $_ }
    if ($($result.Success) -match "True") 
    {
	    $textToWrite = ",OK"	
    } 
    else 
    {
	    $textToWrite = ",NOK"	
    }
    Write-Result -TextToWrite $textToWrite -LogFilePath $logFilePath -AppendToSameLine
}

# Build and start HMI
function BuildAndStartHmi {
    param (
        [string]$appYamlFile,
        [string]$appName
    )
    # Check if the application folder is not empty
    if (-Not ($appYamlFile)) 
    {
        Write-Error "The provided yaml of the application is empty."
        return $null
    }

    # Check if the application file exists
    if (-Not (Test-Path -Path $appYamlFile)) 
    {
        Write-Error "The provided application file  does not exist: $appYamlFile"
        return $null
    }
    # Check if the app name is not empty
    if (-Not ($appName)) 
    {
        Write-Error "The provided application name is empty."
        return $null
    }

    # Check if the application folder exists
    $appFolder = Split-Path -Path $appYamlFile -Parent
    if (-Not (Test-Path -Path $appFolder)) 
    {
        Write-Error "The provided path for the application does not exist: $appFolder"
        return $null
    }
    cd $appFolder
    # recreate solution file
    cd ..
    .\slngen.ps1
    # clean solution 
    $result = dotnet clean this.sln -c Debug
    # build solution 
    $result = dotnet build this.sln -c Debug
    if ($result -match "\s*0 Error\(s\)") 
    {
	    $textToWrite = ",OK"	
    } 
    else 
    {
	    $textToWrite = ",NOK"	
    }
    Write-Result -TextToWrite $textToWrite -LogFilePath $logFilePath -AppendToSameLine
    # get blazor projects
    cd $appFolder
    $blazorFiles = Get-BlazorCsprojFiles
    if ($blazorFiles) 
    {
        Write-Output "Files containing 'blazor' in the filename and ending with '.csproj':"
        $blazorFiles | ForEach-Object { $_.FullName }
        foreach ($blazorFile in $blazorFiles) 
        {
            # Filter out libraries
            $csprojContent = Get-Content -Path $blazorFile.FullName -Raw

            if (-not ($csprojContent -match '<PackageId>'))
            {
                $result = Start-DotNetProject -ProjectName $blazorFile.FullName -Framework $defaultFramework -Configuration $defaultConfiguration -dotnetTimeout $defaultDotnetTimeout 
                if ($result -match "True$") 
                {
	                $textToWrite = ",OK"	
                } 
                else 
                {
	                $textToWrite = ",NOK"	
                }
                $result.output | foreach-object { write-output $_ }
                Write-Result -TextToWrite $textToWrite -LogFilePath $logFilePath -AppendToSameLine
            }
        }
    } 
    else 
    {
        Write-Output "No files containing 'blazor' in the filename and ending with '.csproj' were found."
    }

    cd $startDir
}

# Function to create the log file
function CreateFile 
{
    param (
        [string]$DirectoryPath = (Get-Location).Path, # Directory where the file will be created
        [string]$FileNamePrefix = "test_result"       # Prefix for the file name
    )

    # Get the current timestamp
    $timestamp = (Get-Date -Format "yyyyMMdd_HHmmss")

    # Define the full file name with the directory
    $fileName = "{0}_{1}.csv" -f $FileNamePrefix, $timestamp

    $absolutePath = Join-Path -Path $DirectoryPath -ChildPath $fileName

    try 
    {
        # Create the file
        New-Item -Path $absolutePath -ItemType File -Force | Out-Null
        Write-Output "File '$absolutePath' created successfully."
        return @{
            Success = $true
            FilePath = $absolutePath
        }
    } 
    catch 
    {
        Write-Error "An error occurred while creating the file: $_"
        return @{
            Success = $false
            FilePath = $null
        }
    }
}

# Function to write to the log file
function Write-Result 
{
    param (
        [string]$TextToWrite,         # Text to write to the log file
        [string]$LogFilePath,         # Absolute path to the log file
        [switch]$AppendToSameLine    # Flag to append text to the same line
    )

    # Check if the log file exists
    if (-Not (Test-Path -Path $LogFilePath)) {
        Write-Error "The specified log file does not exist: $LogFilePath"
        return
    }

    try 
    {
        if ($AppendToSameLine) 
        {
            # Append to the same line without a newline
            [System.IO.File]::AppendAllText($LogFilePath, $TextToWrite)
        } 
        else 
        {
            # Append text with a newline
            Add-Content -Path $LogFilePath -Value $TextToWrite
        }

        Write-Output "Text successfully written to file '$LogFilePath'."
        Write-Output "File content:"
        Get-Content -Path $LogFilePath
    } 
    catch 
    {
        Write-Error "An error occurred while writing to the file: $_"
    }
}

# Function to kill process
function Kill-Process 
{
    param (
        [string]$ProcessName         # Name of the process to kill
    )

    $processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue

    # Check if any processes were found
    if ($processes) {
        # Iterate through the processes and terminate them
        foreach ($process in $processes) {
            try {
                # Attempt to kill the process
                Stop-Process -Id $process.Id -Force -ErrorAction Stop
                Write-Output "Successfully terminated process: $($process.Name) (ID: $($process.Id))"
            } catch {
                Write-Error "Failed to terminate process: $($process.Name) (ID: $($process.Id)) - $_"
            }
        }
    } else {
        Write-Output "No processes named $ProcessName were found."
    }
}

$startDir=  $PSScriptRoot
# Check if axopen repository is already cloned
#if (-Not (Test-Path -Path $axopenRepoDir)) {
#    git clone -b dev https://github.com/ix-ax/AXOpen.git axopen
#    Write-Host "AXOpen repository cloned."
#    # Build axopen if it was just cloned 
#    cd $axopenRepoDir
#    .\build.ps1
#    cd ..
#} 
#else {
#    cd $axopenRepoDir
#    git checkout dev
#    git pull
#    .\build.ps1
#    cd ..
#    Write-Host "AXOpen repository already exists. Skipping cloning."
#}
###### Get all apax yaml files with type: 'app' excluding restricted
$repoPath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath $axopenRepoDir)
$appYamls = Get-AppTypeYamlFilesExcludingRestricted -repoPath $repoPath
if ($appYamls) 
{
    $resultPath =  Join-Path -Path $startDir -ChildPath $resultDir
    if (-Not (Test-Path -Path $resultPath)) 
    {
        New-Item -ItemType Directory -Path $resultPath -Force | Out-Null
    }

    $createResult = CreateFile -DirectoryPath $resultPath -FileNamePrefix "test_result"

    if ($createResult.Success) {
        $logFilePath = $createResult.FilePath
        Write-Result -TextToWrite "AppName,PlcHw,PlcSw,DotnetBuild,DotnetRun"  -LogFilePath $logFilePath 
        Write-Output "Files with 'type: app':"
        foreach ($appYaml in $appYamls) 
        {
            if($($appYaml.FilePath) -and $($appYaml.AppName))
            {
                # Display the file details
                Write-Output "File Path: $($appYaml.FilePath)"
                Write-Output "App Name: $($appYaml.AppName)"
                Write-Result -TextToWrite " " -LogFilePath $logFilePath 
                Write-Result -TextToWrite "$($appYaml.AppName)" -LogFilePath $logFilePath -AppendToSameLine
                ####### Initialize plcsim instance with default 'fresh' content
                #InitializePlcSimInstance -memoryCardPath $plcSimVirtualMemoryCardLocation -instanceName $($appYaml.AppName)
                ####### Overrite security files
                #OverwriteSecurityFiles -appYamlFile $($appYaml.FilePath) -plcName $plcName
                ####### Build and load PLC
                #BuildAndLoadPlc -appYamlFile $($appYaml.FilePath) -appName $($appYaml.AppName) -logFilePath $logFilePath 
                ####### Build and start HMI
                #BuildAndStartHmi -appYamlFile $($appYaml.FilePath) -appName $($appYaml.AppName) -logFilePath $logFilePath 
            }
        }

    } 
    else 
    {
        Write-Error "Failed to create the log file."
    }
    Kill-Process -ProcessName "Siemens.Simatic.PlcSim.Advanced.UserInterface"
#    Write-Error "I am just curious how this error message impact github action status."
    Write-Output "I am just curious how this error message impact github action status."
} 
else 
{
    Write-Output "No apax yaml files with 'type: app' were found. "
}

