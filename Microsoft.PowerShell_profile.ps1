function Write-BranchName () {
    $branch = git rev-parse --abbrev-ref HEAD

    if ($branch -eq "HEAD") {
        # we're probably in detached HEAD state, so print the SHA
        $branch = git rev-parse --short HEAD
        $color = "red"
    }
    else {
        # we're on an actual branch, so print it
        $color = "blue"
    }
    if ([string]::IsNullOrEmpty($branch)) {
        Write-Host " (no branches yet)" -ForegroundColor "yellow"
        return
    }
    Write-Host " (" -ForegroundColor $color -NoNewline
    if (($branch -eq "main") -or ($branch -eq "master")) {
        Write-Host "๐ฉ" -NoNewLine
    }
    elseif ($branch -eq "develop") {
        Write-Host "๐ง" -NoNewLine
    }
    elseif ($branch.Contains("refactor")) {
        Write-Host "โป๏ธ" -NoNewLine
    }
    elseif ($branch.Contains("optimiz")) {
        Write-Host "๐" -NoNewLine
    }
    elseif ($branch.Contains("doc") -or $branch.Contains("README")) {
        Write-Host "๐" -NoNewLine
    }
    elseif ($branch.Contains("bug")) {
        Write-Host "๐" -NoNewLine
    }
    elseif ($branch.Contains("fix")) {
        Write-Host "๐ฉน" -NoNewLine
    }
    elseif ($branch.Contains("add")) {
        Write-Host "โ" -NoNewLine
    }
    elseif ($branch.Contains("test")) {
        Write-Host "๐งช" -NoNewLine
    }
    elseif ($branch.Contains("remove")) {
        Write-Host "๐ฃ" -NoNewLine
    }
    else {
        Write-Host "๐" -NoNewLine
    }
    Write-Host " $branch)" -ForegroundColor $color
}

function Get-Clock-Emoji () {
    $h = (Get-Date).Hour
    $m = (Get-Date).Minute
    $emoji_code = 128336 + ( ( [int]$h + 11 ) % 12 )
    if ( ($m -gt 30) ) {
        $emoji_code += 12
    }
    return [char]::ConvertFromUtf32($emoji_code)
}

function prompt {
    # $stat = if ($?) {"`u{1F60A}"} else {"`u{1F621}"}
    $stat = if ($?) { if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltinRole] "Administrator")) {"๐"} else { "๐" } } else { "`๐ก" }
    $ps = if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltinRole] "Administrator")) { "#" } else { ">" }
    Write-Host "$(Get-Clock-Emoji) " -NoNewline
    Write-Host $(Get-Date -Format HH:mm:ss) -ForegroundColor DarkRed -NoNewline
    if (Test-Path .git) {
        Write-Host " $pwd" -ForegroundColor Green -NoNewline
        Write-BranchName
    }
    else {
        Write-Host " $pwd" -ForegroundColor Green
    }
    Write-Host "$stat" -NoNewLine
    Write-Host $ps -NoNewLine
    return " "
}

$message = if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltinRole] "Administrator")) {
    "๐ < sudo๏พ๏พ๏พ๏ฝฐ๏ฝพ๏พ๏พ๏ฝถ๏ฝฒ!"
}
else {
    "๐ < ๏ฝบ๏พ๏พ๏พ๏พ"
}
Write-Host $message

# Global Alias
Set-Alias wget Invoke-WebRequest
Set-Alias grep Select-String

# Set MSVC environment variables
& 'C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/Common7/Tools/Launch-VsDevShell.ps1' -Arch amd64 -HostArch amd64 > nul