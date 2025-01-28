
# Get the current script directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$parentDir = Resolve-Path -Path "$scriptDir\.."

# Combine the absolute path with a relative path
$catalogRelPath = "src\ax.catalog"
$catalogAbsPath = Join-Path -Path $ParentDir -ChildPath $catalogRelPath

# Check if the folder exists
if (Test-Path -Path $catalogAbsPath)
 {
    # Get all .tgz files in the folder
    $Files = Get-ChildItem -Path $catalogAbsPath -Filter "*.tgz"

    # Check if any .tgz files were found
    if ($Files) 
    {
        # Loop through each file and delete it
        foreach ($File in $Files) 
        {
            try 
            {
                Remove-Item -Path $File.FullName -Force
                Write-Host "Deleted: $($File.FullName)" -ForegroundColor Green
            } 
            catch 
            {
                Write-Host "Failed to delete: $($File.FullName) - $_" -ForegroundColor Red
            }
        }
    } 
    else 
    {
        Write-Host "No .tgz files found in the folder $catalogAbsPath." -ForegroundColor Yellow
    }

    # Change dir to catalog path
    cd $catalogAbsPath

    # Pack the catalog
    $packError = apax pack --key $env:APAX_KEY 1>$null 2>&1  # Capture errors only

    if (-not $packError) 
    {
        Write-Host "Catalog packed succesfully" -ForegroundColor Green
    } 
    else 
    {
        Write-Host "Failed to pack catalog" -ForegroundColor Red
        Write-Host "Error: $packError" -ForegroundColor Red
        exit 1
    }


    # Get all .tgz files in the folder, there should be just one, currently generated
    $Files = Get-ChildItem -Path $catalogAbsPath -Filter "*.tgz"
    if($Files.Count -ne 1)
    {
        Write-Host "Error: Several *.tgz files found in the directory $catalogAbsPath." -ForegroundColor Red
    }
    else
    {
        $catalogFileName = $Files[0].Name

        Write-Host "Catalog file name: $catalogFileName." -ForegroundColor Yellow


        # Publish the catalog
        #$publishError = apax publish --package $catalogFileName --registry https://npm.pkg.github.com 1>$null 2>&1  # Capture errors only

        $publishError = apax publish --package $catalogFileName --registry https://npm.pkg.github.com *> $null 2>&1  # Capture both standard and error output, discarding it
        if (-not $publishError) 
        {
            Write-Host "Catalog published succesfully" -ForegroundColor Green
        } 
        else 
        {
            Write-Host "Failed to publish catalog" -ForegroundColor Red
            Write-Host "Error: $publishError" -ForegroundColor Red
        }
    }
    Remove-Item -Path $File[0].FullName -Force

} 
else 
{
    Write-Host "The specified folder does not exist: $catalogAbsPath" -ForegroundColor Red
}
cd $scriptDir