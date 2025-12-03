$currentBranch = git branch --show-current
if($currentBranch -ne "dev")
{
    Write-Output "You are not currently on the 'dev' branch."
    Write-Host "You are not currently on the 'dev' branch, but $currentBranch " -ForegroundColor Red
    return -1
}
else
{
    Write-Host "You are currently on the 'dev' branch" -ForegroundColor Green
}
$isClean = -1
$status = git status
foreach ($statusLine in $status ) 
{
    if ($statusLine -eq "nothing to commit, working tree clean") 
    {
        $isClean = 1
        Write-Host "Nothing to commit, working tree clean" -ForegroundColor Green
        break
    }
}
if($isClean -ne 1)
{
    Write-Host "You have some uncommited changes on the 'dev' branch" -ForegroundColor Red
}
return $isClean