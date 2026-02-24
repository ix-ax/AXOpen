param 
(
    [string]$IssueTitle, 
    [string]$IssueBody 
)

# Get the current script directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
# Construct the full path to _is_on_dev_nothing_to_commit.ps1
$_is_on_dev_nothing_to_commit = Join-Path -Path $scriptDir -ChildPath "_is_on_dev_nothing_to_commit.ps1"

# Call _is_on_dev_nothing_to_commit.ps1 
$is_on_dev_nothing_to_commit = & $_is_on_dev_nothing_to_commit

if($is_on_dev_nothing_to_commit -ne 1)
{
    Write-Host "You are not currently on the 'dev' branch, or you have some uncommited changes " -ForegroundColor Red
    Write-Host "Commit your local changes, sync your local 'dev' branch with the remote and start this script again." -ForegroundColor Red
    exit 1
}

if (-not $IssueTitle) 
{
    $IssueTitle = Read-Host "Please enter an issue title."
}
if (-not $IssueBody) 
{
    $IssueBody = Read-Host "Please enter an issue body."
}


if (-not $IssueTitle) 
{
    Write-Output "Issue title cannot be an empty string!"
    exit 1
}
if (-not $IssueBody) 
{
    $IssueBody = " "
}


$issue = gh issue create --assignee "@me" --title "$IssueTitle" --body "$IssueBody" --project simatic-ax

if ($issue -match ".*/(\d+)$") {
    $issueID = $matches[1] 
    Write-Output "The issue ID is: $issueID"
    # Get the current script directory
    $scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

    # Construct the full path to _create_issue_branch.ps1
    $_create_issue_branchScriptPath = Join-Path -Path $scriptDir -ChildPath "_create_issue_branch.ps1"

    # Call _create_issue_branch.ps1 with the parameter IssueId and doNotCheckOldColumnName
    & $_create_issue_branchScriptPath -IssueId $issueID -doNotCheckOldColumnName $True
} else {
    Write-Output "No numeric ID found for this issue."
}


