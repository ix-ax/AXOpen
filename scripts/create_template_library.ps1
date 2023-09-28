param ($o, $p)
write-host "Creating new library template in folder src\$o with name $p" 
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


dotnet new axolibrary -o $o -p $p
write-host "-----------------------------------------------------------" 
write-host "Done" 