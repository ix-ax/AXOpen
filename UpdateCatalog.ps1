# Define your arrays: old values and new values
$oldArray = @(
    "Siemens.Simatic.S71500.Hardware.Utilities",
    "ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD",
    "OLD_TEXT_3"
)

$newArray = @(
    "Siemens.Simatic.Hardware.Utilities",
    "ReadHardwareIOAddress(hardwareID := ",
    "NEW_TEXT_3"
)

# Safety check – arrays must be the same length
if ($oldArray.Count -ne $newArray.Count) {
    throw "oldArray and newArray must have the same number of elements."
}

# Process all *.st files in current folder and subfolders
Get-ChildItem -Path . -Recurse -Filter '*.st' -File | ForEach-Object {
    $filePath = $_.FullName
    Write-Host "Processing $filePath"

    # Read entire file as one string
    $content = Get-Content -LiteralPath $filePath -Raw

    # Replace each old substring with the corresponding new substring
    for ($i = 0; $i -lt $oldArray.Count; $i++) {
        $old = $oldArray[$i]
        $new = $newArray[$i]

        if (![string]::IsNullOrEmpty($old)) {
            $content = $content.Replace($old, $new)  # literal, not regex
        }
    }

    # Write modified content back to file
    Set-Content -LiteralPath $filePath -Value $content
}
