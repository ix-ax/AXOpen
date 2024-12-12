param 
(
     [Parameter(Mandatory=$true)]
    [string]$IssueTitle, 
     [Parameter(Mandatory=$true)]
    [string]$IssueBody 
)

$issue = gh issue create --assignee "@me" --title "$IssueTitle" --body "$IssueBody" 

if ($issue -match ".*/(\d+)$") {
    $issueID = $matches[1] 
    Write-Output "The issue ID is: $issueID"
    .\create_issue_branch.ps1 -IssueId $issueID
} else {
    Write-Output "No numeric ID found for this issue."
}


