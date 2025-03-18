param 
(
     [Parameter(Mandatory=$true)]
    $LibraryFolder
)

$_outputDirectory = $LibraryFolder.ToLower()

# Format the project namespace and ensure dots are preserved
$_namespaceParts = $_outputDirectory -split '\.'
$_formattedParts = $_namespaceParts | ForEach-Object {
    if ($_.Length -gt 0) {
        $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower()
    }
}
$_projectNamespace = "AXOpen." + ($_formattedParts -join '.')

write-host "Creating new library template in folder src\$_outputDirectory with name $_projectNamespace" 
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


dotnet new axolibrary -o $_outputDirectory -p $_projectNamespace

if (Test-Path $_outputDirectory) {
    Set-Location $_outputDirectory
}

#Remove source items
$item = ".\app\ix\app_apaxappname.csproj"
Remove-Item $item -r -force -ErrorAction Ignore
$item = ".\src\"+ $_projectNamespace + "\inxton_apaxlibname.csproj"
Remove-Item $item -r -force -ErrorAction Ignore
$item = ".\app\apax-lock.json"
Remove-Item $item -r -force -ErrorAction Ignore
$item = ".\ctrl\apax-lock.json"
Remove-Item $item -r -force -ErrorAction Ignore

Set-Location app
apax clean
apax install --catalog
apax install
apax build
dotnet ixc

# axcode .
cd ..
dotnet build this.proj
dotnet slngen this.proj -o this.sln --folders true --launch false
# & 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe' this.sln

$dest = $_outputDirectory + ".code-workspace" 
Copy-Item -Path "..\template.axolibrary\template.axolibrary.code-workspace"  -Destination $dest
$dest = $_outputDirectory + ".sln" 
Copy-Item -Path "this.sln"  -Destination $dest



write-host "-----------------------------------------------------------" 
write-host "Done" 