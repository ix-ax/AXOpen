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

$item = ".\template.axolibrary\app\.apax"
Remove-Item $item -r -force -ErrorAction Ignore
$item = ".\template.axolibrary\ctrl\.apax"
Remove-Item $item -r -force -ErrorAction Ignore
$item = ".\template.axolibrary\app\apax-lock.json"
Remove-Item $item -r -force -ErrorAction Ignore
$item = ".\template.axolibrary\ctrl\apax-lock.json"
Remove-Item $item -r -force -ErrorAction Ignore


dotnet new axolibrary -o $_outputDirectory -p $_projectNamespace

if (Test-Path $_outputDirectory) {
    Set-Location $_outputDirectory
}

#Rename items
$item_old = ".\app\ix\app_apaxappname.csproj"
$item_new = "app_" + $_projectNamespace.ToLower().Replace(".","_") + ".csproj"
Rename-Item -Path $item_old -NewName $item_new -Force -ErrorAction Ignore
$item_old = ".\src\"+ $_projectNamespace + "\inxton_apaxlibname.csproj"
$item_new = "inxton_"+ $_projectNamespace.ToLower().Replace(".","_") + ".csproj"
Rename-Item -Path $item_old -NewName $item_new -Force -ErrorAction Ignore

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