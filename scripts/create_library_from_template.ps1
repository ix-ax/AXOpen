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

$_inxton_apaxlibname_csproj = "inxton_axopen_" + ($_outputDirectory -replace "\.", "_") + ".csproj" 
$_app_apaxappname_csproj = "app_axopen_" + ($_outputDirectory -replace "\.", "_") + ".csproj" 

write-host "Creating new library template in folder src\$_outputDirectory with name $_projectNamespace" 
write-host "inxton_apaxlibname_csproj name: $_inxton_apaxlibname_csproj" 
write-host "app_apaxappname_csproj name: $_app_apaxappname_csproj" 
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


dotnet new axolibrary -o $_outputDirectory --projname $_projectNamespace --inxton_apaxlibname_csproj $_inxton_apaxlibname_csproj --app_apaxappname_csproj $_app_apaxappname_csproj --force


if (Test-Path $_outputDirectory) {
    Set-Location $_outputDirectory
}

#Rename items
$item = ".\app\ix\app_apaxappname.csproj"
Rename-Item -Path $item -NewName $_app_apaxappname_csproj -Force -ErrorAction Ignore
$item = ".\src\"+ $_projectNamespace + "\inxton_apaxlibname.csproj"
Rename-Item -Path $item -NewName $_inxton_apaxlibname_csproj -Force -ErrorAction Ignore

$item = ".\src\"+ $_projectNamespace + "\inxton_apaxlibname.csproj.Backup.tmp"
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