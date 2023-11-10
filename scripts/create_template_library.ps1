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


dotnet new axolibrary -o $OutputDirectory -p $ProjectNamespace


if (Test-Path $OutputDirectory) {
    Set-Location $OutputDirectory
}

Set-Location app
apax install
apax build
dotnet ixc

# axcode .
cd ..
dotnet build this.proj
dotnet slngen this.proj -o this.sln --folders true --launch false
# & 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe' this.sln

write-host "-----------------------------------------------------------" 
write-host "Done" 