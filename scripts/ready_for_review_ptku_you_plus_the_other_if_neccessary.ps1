$gitStatus = git status
if($gitStatus -ne "nothing to commit, working tree clean")
{
    Write-Output "Working tree not clean. Commit and push your local changes and then run this script again."

}
