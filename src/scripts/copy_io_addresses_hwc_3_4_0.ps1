param(
    [Parameter(Position=0)]
    [string]$input_file,

    [Parameter(Position=1)]
    [string]$output_dir,

    [Parameter(Position=2)]
    [string]$output_file_inputs,

    [Parameter(Position=3)]
    [string]$output_file_outputs,

    [Parameter(Position=4)]
    [string]$output_file_structures,

    [Parameter(Position=5)]
    [string]$NAMESPACE
)

Write-Host "input_file: $input_file"
Write-Host "output_dir: $output_dir"
Write-Host "output_file_inputs: $output_file_inputs"
Write-Host "output_file_outputs: $output_file_outputs"
Write-Host "output_file_structures: $output_file_structures"
Write-Host "NAMESPACE: $NAMESPACE"

# Create output directory if it does not exist
if (!(Test-Path -Path $output_dir)) 
{
	New-Item -Path $output_dir -ItemType Directory -Force | Out-Null
}
# Delete the output file for inputs if it exists
if (Test-Path -LiteralPath $output_file_inputs -PathType Leaf) 
{
	Remove-Item -LiteralPath $output_file_inputs -Force -ErrorAction Stop
}
# Delete the output file for outputs if it exists
if (Test-Path -LiteralPath $output_file_outputs -PathType Leaf) 
{
	Remove-Item -LiteralPath $output_file_outputs -Force -ErrorAction Stop
}
# Delete the output file for io structures if it exists
if (Test-Path -LiteralPath $output_file_structures -PathType Leaf) 
{
	Remove-Item -LiteralPath $output_file_structures -Force -ErrorAction Stop
}


# Read all lines
$all = Get-Content -LiteralPath $input_file

# Find VAR_GLOBAL...END_VAR region indices
$startIdx_VarGlobal = $null
$endIdx_VarGlobal   = $null

for ($i = 0; $i -lt $all.Count; $i++) {
    if ($null -eq $startIdx_VarGlobal -and $all[$i] -match '^\s*VAR_GLOBAL\b') {
        $startIdx_VarGlobal = $i
        continue
    }
    if ($null -ne $startIdx_VarGlobal -and $all[$i] -match '^\s*END_VAR\b') {
        $endIdx_VarGlobal = $i
        break
    }
}

if ($null -eq $startIdx_VarGlobal -or $null -eq $endIdx_VarGlobal -or $endIdx_VarGlobal -le $startIdx_VarGlobal) {
    Write-Error "Could not locate a proper VAR_GLOBAL ... END_VAR block in $input_file"
    exit 1
}

# Slice the region (exclusive of the VAR_GLOBAL/END_VAR lines? Keep them out for item parsing)
$varLines = $all[($startIdx_VarGlobal+1) .. ($endIdx_VarGlobal-1)]

# Builders for outputs
$sbIn  = [System.Text.StringBuilder]::new()
[void]$sbIn.AppendLine("NAMESPACE $NAMESPACE")
[void]$sbIn.AppendLine("    TYPE")
[void]$sbIn.AppendLine("        {S7.extern=ReadWrite}")
[void]$sbIn.AppendLine("        {#ix-attr:[Container(Layout.Wrap)]}")
[void]$sbIn.AppendLine("        Inputs : STRUCT")
$sbOut = [System.Text.StringBuilder]::new()
[void]$sbOut.AppendLine("NAMESPACE $NAMESPACE")
[void]$sbOut.AppendLine("    TYPE")
[void]$sbOut.AppendLine("        {S7.extern=ReadWrite}")
[void]$sbOut.AppendLine("        {#ix-attr:[Container(Layout.Wrap)]}")
[void]$sbOut.AppendLine("        Outputs : STRUCT")
$sbStruct = [System.Text.StringBuilder]::new()
[void]$sbStruct.AppendLine("NAMESPACE $NAMESPACE")


# Helpers
function EndsWithSemicolon([string]$line) {
    # semicolon before end or trailing spaces/comments—treat a semicolon anywhere as terminator
    return $line -match ';'
}
$containsInputs = $false
$containsOutputs = $false
# Parse: a declaration may span multiple lines until a semicolon.
# If the *immediate previous* line starts with //, include it above the declaration.
$idx = 0
while ($idx -lt $varLines.Count) {
    $line = $varLines[$idx]

    # Skip blank and comment lines here (but we still need them when they are
    # directly above a declaration; we will look back one line when we start a decl).
    # A declaration starts when we hit a non-empty, non-// line.
    if ($line -match '^\s*$' -or $line -match '^\s*//') {
        $idx++
        continue
    }

    # We are at the first line of a declaration
    $declSb = [System.Text.StringBuilder]::new()

    # If immediate previous line exists and starts with //, include it
    $prevIdx = $idx - 1
    if ($prevIdx -ge 0) {
        $prev = "`t$($varLines[$prevIdx])"
        if ($prev -match '^\s*//') {
            [void]$declSb.AppendLine($prev)
        }
    }

    # Now accumulate declaration lines until we hit a semicolon
    while ($idx -lt $varLines.Count) {
        $line = "`t$($varLines[$idx])"
        [void]$declSb.AppendLine($line)
        if (EndsWithSemicolon $line) {
            $idx++
            break
        }
        $idx++
    }

    $declText = $declSb.ToString()

    if ($declText -match 'AT\s*%I') {
        $normalized = $declText -replace 'AT\s*%I', 'AT %'
        [void]$sbIn.AppendLine($normalized)
        $containsInputs = $true
    }
    elseif ($declText -match 'AT\s*%Q') {
        $normalized = $declText -replace 'AT\s*%Q', 'AT %'
        [void]$sbOut.AppendLine($normalized)
        $containsOutputs = $true
    }
    else {
        # not an input/output item -> ignore (stays out of both files)
    }
}
if ($containsInputs -eq $false) {
        [void]$sbIn.AppendLine("            noInputsFoundInTheHwConfig AT %B0:  BYTE;")
}
if ($containsOutputs -eq $false) {
        [void]$sbOut.AppendLine("            noOutputsFoundInTheHwConfig AT %B0:  BYTE;")
}


# Find first TYPE section
$startIdx_Type = $null

for ($i = $endIdx_VarGlobal; $i -lt $all.Count; $i++) {
    if ($null -eq $startIdx_Type -and $all[$i] -match '^\s*TYPE\b') {
        $startIdx_Type = $i
        break
    }
}

for ($i = $startIdx_Type; $i -lt $all.Count; $i++) {
    [void]$sbStruct.AppendLine("`t$($all[$i])")
    if ($all[$i] -match '^\s*TYPE\b') {
        [void]$sbStruct.AppendLine("        {S7.extern=ReadWrite}")
        [void]$sbStruct.AppendLine("        {#ix-attr:[Container(Layout.Wrap)]}")

    }
}


[void]$sbIn.AppendLine("        END_STRUCT;")
[void]$sbIn.AppendLine("    END_TYPE")
[void]$sbIn.AppendLine("END_NAMESPACE")

[void]$sbOut.AppendLine("        END_STRUCT;")
[void]$sbOut.AppendLine("    END_TYPE")
[void]$sbOut.AppendLine("END_NAMESPACE")

[void]$sbStruct.AppendLine("END_NAMESPACE")

# Write outputs (UTF-8)
New-Item -ItemType File -Path $output_file_inputs  | Out-Null
New-Item -ItemType File -Path $output_file_outputs | Out-Null
New-Item -ItemType File -Path $output_file_structures | Out-Null

Set-Content -LiteralPath $output_file_inputs -Value $sbIn.ToString()  -Encoding UTF8
Set-Content -LiteralPath $output_file_outputs -Value $sbOut.ToString() -Encoding UTF8
Set-Content -LiteralPath $output_file_structures -Value $sbStruct.ToString() -Encoding UTF8

