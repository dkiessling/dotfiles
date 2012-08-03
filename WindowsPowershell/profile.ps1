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

Set-PSDebug -Strict
$ErrorActionPreference = "stop"

$powershellPath = [Environment]::GetFolderPath("Personal") + "/WindowsPowershell"
. (Resolve-Path "$powershellPath/hgutils.ps1")
. (Resolve-Path "$powershellPath/gitutils.ps1")

set-alias ll Get-ChildItem
set-alias fortune "$powershellPath/fortune.ps1"
fortune

remove-item alias:ls
set-alias ls Get-ChildItemColor

function Get-ChildItemColor {
    $fore = $Host.UI.RawUI.ForegroundColor

    Invoke-Expression ("Get-ChildItem $args") |
    %{
        if ($_.GetType().Name -eq 'DirectoryInfo') {
            $Host.UI.RawUI.ForegroundColor = 'White'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        } elseif ($_.Name -match '\.(zip|tar|gz|rar)$') {
            $Host.UI.RawUI.ForegroundColor = 'Blue'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        } elseif ($_.Name -match '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$') {
            $Host.UI.RawUI.ForegroundColor = 'Green'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        } elseif ($_.Name -match '\.(txt|cfg|conf|ini|csv|sql|xml|config)$') {
            $Host.UI.RawUI.ForegroundColor = 'Cyan'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        } elseif ($_.Name -match '\.(cs|asax|aspx.cs)$') {
            $Host.UI.RawUI.ForegroundColor = 'Yellow'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        } elseif ($_.Name -match '\.(aspx|spark|master)$') {
            $Host.UI.RawUI.ForegroundColor = 'DarkYellow'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        } elseif ($_.Name -match '\.(sln|csproj)$') {
            $Host.UI.RawUI.ForegroundColor = 'Magenta'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        }
        else {
            $Host.UI.RawUI.ForegroundColor = $fore
            echo $_
        }
    }
}

function get-adminuser() {
   $id = [Security.Principal.WindowsIdentity]::GetCurrent()
   $p = New-Object Security.Principal.WindowsPrincipal($id)
   return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function set-adminBackground() {
    if ( Get-Adminuser ) {
        $chost = [ConsoleColor]::DarkRed;
    } else {
        $chost = $Host.UI.RawUI.BackgroundColor
    }

    $Host.UI.RawUI.BackgroundColor = $chost
}

set-adminbackground

# Define the prompt. Show '~' instead of $HOME
function shorten-path([string] $path) {
   $loc = $path.Replace($HOME, '~')
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2')
}


function get-ips() {
   $ent = [net.dns]::GetHostEntry([net.dns]::GetHostName())
   return $ent.AddressList | ?{ $_.ScopeId -ne 0 } | %{
      [string]$_
   }
}

function prompt {
    $Host.UI.RawUI.WindowTitle = $env:username + '@' + [System.Environment]::MachineName + ' - ' + $pwd 

    write-host($pwd) -nonewline -foregroundcolor DarkGreen

# Mercurial
   if (isCurrentDirectoryMercurialRepository) {
        $status = mercurialStatus
        $currentBranch = mercurialBranchName
        
        Write-Host(' hg [') -nonewline -foregroundcolor Yellow
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

        Write-Host(' git [') -nonewline -foregroundcolor Yellow
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
    
    Write-Host('>') -nonewline -foregroundcolor DarkGreen 
    return " "
}
