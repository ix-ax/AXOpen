param (
    [int]$IssueId ,
    [bool]$doNotCheckOldColumnName = 0
)

gh issue list --assignee "@me" --state "open"
$issues = gh issue list --state "open" --assignee "@me" --json number,title | ConvertFrom-Json
$issueIDs = $issues | ForEach-Object { $_.number }

if (-not $IssueId) 
{
    $IssueId = Read-Host "Please enter an ID value of the issue"
}


if ([int]::TryParse($IssueId, [ref]$null)) 
{
    # Check if any of the open issue IDs assigned to @me is equal to entered value
    if ($issueIDs -contains [int]$IssueId) 
    {
        # Get selected issue id ,issue title and issue label
        $selectedIssue = $issues | Where-Object { $_.number -eq [int]$IssueId }
        $selectedIssueNumber = $selectedIssue.number
        $selectedIssueTitle = $selectedIssue.title
        $currentLabels = $selectedIssue.labels | ForEach-Object { $_.name }
        # Checkout dev
        Write-Output "Checkout to dev"
        git checkout dev
        $currentBranch = git branch --show-current
        if($currentBranch -eq "dev")
        {
            # Get remote changes, if any
            git pull
            # Create branch for the selected issue
            Write-Output "Creating branch for the issue number: '$selectedIssueNumber', title: '$selectedIssueTitle'"
            gh issue develop $IssueId --base dev --checkout
            # Add all changes 
            git add .
            # Commit all changes 
            git commit --allow-empty -m "Create draft PR for #$selectedIssueNumber"
            # Write changes to remote            
            Write-Output "Pushing the branch to remote"
            git push -u origin $(git branch --show-current)
            # Create draft PR
            Write-Output "Creating a draft pull request into 'dev'"
            gh pr create --base dev --head $(git branch --show-current) --title "$selectedIssueTitle" --body "closes #$selectedIssueNumber" --draft
            # Sync
            git push 
            Write-Output "Sync local and remote branches"
            git pull origin $(git branch --show-current)
            git push 
            # Get the current script directory
            $scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
            # Construct the full path to _change_stateScriptPath.ps1
            $_change_stateScriptPath = Join-Path -Path $scriptDir -ChildPath "_change_state.ps1"
            # Call _change_state.ps1 with the parameters IssueId, oldColumnName, newColumnName,doNotCheckOldColumnName, repoOwner, repoName, projectName
            & $_change_stateScriptPath -IssueId $issueID -oldColumnName "Ready" -newColumnName "In progress" -doNotCheckOldColumnName $doNotCheckOldColumnName -repoOwner "Inxton" -repoName "AXOpen" -projectName "simatic-ax"
        } 
        else 
        {
            Write-Output "Unable to checkout to dev"
            Write-Output "Commit your local changes, sync your local 'dev' branch with th remote and start this script again."
            exit 1
        }
    } 
    else {
        Write-Output "Error: The issue ID '$IssueId' does not exist in the list of open issues."
        exit 1
    }
} else {
    Write-Output "Error: The value '$IssueId' is not a valid numeric value."
    exit 1
}