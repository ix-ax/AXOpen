gh issue list --assignee "@me" --state "open"
$issues = gh issue list --state "open" --assignee "@me" --json number,title | ConvertFrom-Json
$issueIDs = $issues | ForEach-Object { $_.number }

$value = Read-Host "Please enter an ID value of the issue."

if ([int]::TryParse($value, [ref]$null)) {
    if ($issueIDs -contains [int]$value) {
        $selectedIssue = $issues | Where-Object { $_.number -eq [int]$value }
        $selectedIssueNumber = $selectedIssue.number
        $selectedIssueTitle = $selectedIssue.title
        Write-Output "Creating branch for the issue number: '$selectedIssueNumber', title: '$selectedIssueTitle'"
        gh issue develop $value --base dev --checkout
        Write-Output "Pushing the branch to remote"
        git push -u origin $(git branch --show-current)
        Write-Output "Creating a draft pull request into 'dev'"
        gh pr create --base dev --head $(git branch --show-current) --title "closes $selectedIssueTitle" --body "closes #$selectedIssueNumber" --draft
        git commit -m "Create draft PR for #$selectedIssueNumber"
        Write-Output "Sync local and remote branches"
        git pull origin $(git branch --show-current)
    } else {
        Write-Output "Error: The issue ID '$value' does not exist in the list of open issues."
        exit 1
    }
} else {
    Write-Output "Error: The value '$value' is not a valid numeric value."
    exit 1
}