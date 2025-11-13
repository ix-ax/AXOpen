param (
    [string]$newVersion = '0.0.20'
)

$namePattern = "apax.yml"
$allYamls = Get-ChildItem -Path $PSScriptRoot -Recurse -File -Filter $namePattern
$allYamlsCount = 0
$matchedYamlsCount = 0

foreach ($file in $allYamls) {
    $allYamlsCount++
    $filePath = $file.FullName
    $fileContent = Get-Content -Path $filePath -Raw

    # Define the regex pattern
    $pattern = '("@inxton/ax\.catalog":\s*)([0-9]+\.[0-9]+\.[0-9]+)'

    if ($fileContent -match $pattern) {
        $matchedYamlsCount++

        # Prepare the replacement string with proper escaping
        $replacement = '${1}' + $newVersion

        # Perform regex replacement correctly
        $updatedContent = [regex]::Replace($fileContent, $pattern, $replacement)

        # Save the modified file
        Set-Content -Path $filePath -Value $updatedContent -Encoding UTF8

        Write-Output "Updated file: $filePath"
    }
}

Write-Output "Processed $allYamlsCount file(s). Updated $matchedYamlsCount file(s)."
