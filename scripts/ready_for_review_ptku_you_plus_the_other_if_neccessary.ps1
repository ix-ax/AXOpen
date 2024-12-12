$gitStatus = git status
if($gitStatus -notcontains "nothing to commit, working tree clean")
{
    Write-Output "Working tree is not clean. Commit and push your local changes and run this script again afterwards."

}
