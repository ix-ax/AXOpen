param (
    [string]$stringConstant =  '10.222.' 
)
$namePattern = "*.yml"
$allYamls = Get-ChildItem -Path $PSScriptRoot -Recurse -File -Filter $namePattern
$allYamlsCount = 0
$matchedYamlsCount = 0
Get-ChildItem -Path $PSScriptRoot -Recurse -File -Filter $namePattern | ForEach-Object {
    $allYamlsCount = $allYamlsCount + 1
    $filePath = $_.FullName
    $fileContent = Get-Content -Path $filePath -Raw
    if ($fileContent -match $stringConstant) 
    {
        Invoke-Item -Path $filePath
        Write-Output "Matching file: " + $filePath
    }
}
