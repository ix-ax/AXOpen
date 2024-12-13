$gitStatus = git status
if($gitStatus -notcontains "nothing to commit, working tree clean")
{
    Write-Output "Working tree is not clean. Commit and push your local changes and run this script again afterwards."
}
else
{
    $currentBranch = $(git branch --show-current)
    Write-Output "Working tree is clean. Marking '$currentBranch' as ready fore review"
    $AdditionalReviewers = Read-Host "Please enter the additional reviewers names: i.e.: my_boss_github_name, his_boss_github_name, etc. (upto the galaxy owner)"
    $ReviewComment = Read-Host "Please enter a comment for the reviewers, for empty press enter"
    Write-Output "currentBranch:  $currentBranch"
    Write-Output "AdditionalReviewers:  $AdditionalReviewers"
    $Reviewers = "PTKu,@me" + "," + $AdditionalReviewers
    $ReviewersArray = $Reviewers -split "," | ForEach-Object { $_.Trim() }
    $ReviewersString = $ReviewersArray -join ","
    $Command = "gh pr edit --add-reviewer " + $ReviewersString
    Invoke-Expression $Command
    if ($ReviewComment -ne "") {
        $Command = "gh pr comment -b """ + $ReviewComment + """"
        Invoke-Expression $Command
    }
    gh pr ready
}

