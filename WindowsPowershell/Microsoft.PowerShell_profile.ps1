# This config was created using powershell-prompt-for-mercurial for Mercurial integration
# and my-ideal-powershell-prompt-with-git-integration for Git integration
#
# Mercurial
# You can clone it by 
# hg clone https://xajler@bitbucket.org/xajler/powershell-prompt-for-mercurial/
# And find source here:
# http://bitbucket.org/xajler/powershell-prompt-for-mercurial/src/
#
# Git
# http://markembling.info/2009/09/my-ideal-powershell-prompt-with-git-integration

$hgPath = [Environment]::GetFolderPath("Personal") + "/WindowsPowershell/hgutils.ps1"
$gitPath = [Environment]::GetFolderPath("Personal") + "/WindowsPowershell/gitutils.ps1"
. (Resolve-Path $hgPath)
. (Resolve-Path $gitPath)

function prompt {
	$Host.UI.RawUi.WindowTitle = $env:username + '@' + [System.Environment]::MachineName + ' ' + $pwd 
    Write-Host($pwd) -nonewline -foregroundcolor Green       
    
# Mercurial
   if (isCurrentDirectoryMercurialRepository) {
        $status = mercurialStatus
        $currentBranch = mercurialBranchName
        
        Write-Host(' [') -nonewline -foregroundcolor Yellow
        Write-Host($currentBranch) -nonewline -foregroundcolor Cyan
        Write-Host(' A' + $status["added"]) -nonewline -foregroundcolor Green 
        Write-Host(' M' + $status["modified"]) -nonewline -foregroundcolor Yellow
        Write-Host(' D' + $status["deleted"]) -nonewline -foregroundcolor Cyan
        Write-Host(' !' + $status["missing"]) -nonewline -foregroundcolor Magenta
        if ($status["untracked"] -ne $FALSE) {
            Write-Host(' ?' + $status["untracked"]) -nonewline -foregroundcolor Red
        }
        
        Write-Host(']') -nonewline -foregroundcolor Yellow 
    }    

# Git
    if (isCurrentDirectoryGitRepository) {
        $status = gitStatus
        $currentBranch = gitBranchName

        Write-Host(' [') -nonewline -foregroundcolor Yellow
        if ($status["ahead"] -eq $FALSE) {
            Write-Host($currentBranch) -nonewline -foregroundcolor Cyan
        } else {
            Write-Host($currentBranch) -nonewline -foregroundcolor Red
        }
        Write-Host(' A' + $status["added"]) -nonewline -foregroundcolor Green
        Write-Host(' M' + $status["modified"]) -nonewline -foregroundcolor Yellow
        Write-Host(' D' + $status["deleted"]) -nonewline -foregroundcolor Cyan
        if ($status["untracked"] -ne $FALSE) {
            Write-Host(' ?' + $status["untracked"]) -nonewline -foregroundcolor Red
        }

        Write-Host(']') -nonewline -foregroundcolor Yellow
    }
    
	Write-Host('>') -nonewline -foregroundcolor Green    
	return " "
}