param 
(
     [Parameter(Mandatory=$true)]
    $OutputDirectory, 
     [Parameter(Mandatory=$true)]
    $ProjectNamespace
)
write-host "Creating new library template in folder src\$OutputDirectory with name $ProjectNamespace" 
write-host "-----------------------------------------------------------" 
if (Test-Path ".\src") {
    Set-Location .\src
}
if (Test-Path "..\src") {
    Set-Location ..\src
}

dotnet new install .\template.axolibrary\ --force

$FolderNameApp = ".\template.axolibrary\app\.apax"
$FolderNameCtrl = ".\template.axolibrary\ctrl\.apax"
Remove-Item $FolderNameApp -r -force -ErrorAction Ignore
Remove-Item $FolderNameCtrl -r -force -ErrorAction Ignore


dotnet new axolibrary -o $OutputDirectory --projname $ProjectNamespace

# Delete files starting with 'tmp_*_' in the root output folder
Get-ChildItem -Path "$OutputDirectory\" -File -Filter "tmp_*_.*" | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Output "Deleted $($_.FullName)"
}

if (Test-Path $OutputDirectory) {
    Set-Location $OutputDirectory
}

cd app
apax build

cd ..

axcode .

dotnet slngen this.proj -o this.sln --folders true --launch false
& 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe' this.sln


write-host "-----------------------------------------------------------" 
write-host "Done" 