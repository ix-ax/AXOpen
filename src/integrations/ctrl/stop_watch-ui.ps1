$webPids = gcim win32_process | Where-Object{$_.CommandLine -clike "*localhost:5046*"} | select ProcessId
foreach ($webPid in $webPids)
{
    $pidd = $webPid.ProcessId    
    Get-Process | Where-Object{$_.Id -eq $pidd} | Stop-Process
}
Start-Sleep -Seconds 2
$watchPids =  gcim win32_process | Where-Object{$_.Name -eq "dotnet.exe"} | Where-Object{$_.CommandLine -clike "*watch --project ..\integration.blazor\integration.blazor.csproj"}| select ProcessId
foreach ($watchPid in $watchPids)
{
    $pidd = $watchPid.ProcessId    
    Get-Process | Where-Object{$_.Id -eq $pidd} | Stop-Process
}

