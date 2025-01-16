$gitStatus = git status
if($gitStatus -notcontains "nothing to commit, working tree clean")
{
    Write-Output "Working tree is not clean. Commit and push your local changes and run this script again afterwards."
}
else
{
    # Get current branch name
    $currentBranch = $(git branch --show-current)
    Write-Output "Working tree is clean. Marking '$currentBranch' as ready fore review"
    # Get the list of pull requests
    $pullRequests = gh pr list --state open --json number,headRefName | ConvertFrom-Json
    if (-not $pullRequests) {
        Write-Error "No open pull requests found or an error occurred while retrieving them."
        exit 1
    }
    # Find the pull request matching the current branch
    $pullRequest = $pullRequests | Where-Object { $_.headRefName -eq $currentBranch }
    if (-not $pullRequest) 
    {
        Write-Output "No pull request found for the current branch ($currentBranch)."
        exit 1
    }
    $pullRequestNumber = $pullRequest.number
    Write-Output "Pull Request Number: $($pullRequestNumber)"
    # Assign it to me
    gh pr edit $pullRequestNumber --add-assignee "@me"
    Write-Host "Please enter the additional reviewers names: i.e.: my_boss_github_name, his_boss_github_name, etc. (upto the galaxy owner)"
    Write-Host "If environment variable 'GH_REVIEWERS' exists, these names will be added, otherwise these names will be used as the only reviewers"
    $AdditionalReviewers = Read-Host "For empty press enter."
    $ReviewComment = Read-Host "Please enter a comment for the reviewers, for empty press enter"
    Write-Output "currentBranch:  $currentBranch"
    Write-Output "AdditionalReviewers:  $AdditionalReviewers"
    if ($Env:GH_REVIEWERS -ne $null) 
    {
        $Reviewers = $Env:GH_REVIEWERS + "," + $AdditionalReviewers
    } 
    else 
    {
        $Reviewers = $AdditionalReviewers
    }
    $ReviewersArray = $Reviewers -split "," | ForEach-Object { $_.Trim() }
    $ReviewersString = $ReviewersArray -join ","
    $Command = "gh pr edit --add-reviewer " + $ReviewersString
    Invoke-Expression $Command
    if ($ReviewComment -ne "") {
        $Command = "gh pr comment $pullRequestNumber -b """ + $ReviewComment + """"
        Invoke-Expression $Command
    }
    gh pr ready $pullRequestNumber
}

