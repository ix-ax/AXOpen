# Define your arrays: old values and new values
$oldArray = @(
    "Siemens.Simatic.S71500.Hardware.Utilities",
    "ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD",
    "ReadHardwareIOAddress(hardwareIdentifier := TO_WORD",
    "Siemens.Simatic.S71500.MemoryAccess",
    "Siemens.Simatic.S71500.DistributedIO",
    "Siemens.Simatic.DistributedIO.ReadData(TO_WORD",
    "Siemens.Simatic.DistributedIO.WriteData(TO_WORD"
)

$newArray = @(
    "Siemens.Simatic.Hardware.Utilities",
    "ReadHardwareIOAddress(hardwareID := ",
    "ReadHardwareIOAddress(hardwareID := ",
    "Siemens.Simatic.MemoryAccess",
    "Siemens.Simatic.DistributedIO",
    "Siemens.Simatic.DistributedIO.ReadData(",
    "Siemens.Simatic.DistributedIO.WriteData("
)

# Safety check â€“ arrays must be the same length
if ($oldArray.Count -ne $newArray.Count) {
    throw "oldArray and newArray must have the same number of elements."
}

# Process all *.st files in current folder and subfolders
Get-ChildItem -Path . -Recurse -Filter '*.st' -File | ForEach-Object {
    $filePath = $_.FullName
    Write-Host "Processing $filePath"

    # Read entire file as one string
    $content = Get-Content -LiteralPath $filePath -Raw

    # Keep original content to detect changes
    $original = $content

    # Perform replacements
    for ($i = 0; $i -lt $oldArray.Count; $i++) {
        $old = $oldArray[$i]
        $new = $newArray[$i]

        if (![string]::IsNullOrEmpty($old)) {
            $content = $content.Replace($old, $new)
        }
    }

    # Write back only if changed
    if ($content -ne $original) {
        Write-Host " → Changes detected. Updating file."
        Set-Content -LiteralPath $filePath -Value $content
    } else {
        Write-Host " → No changes. File: $filePath left untouched."
    }
}