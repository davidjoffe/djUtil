param([string]$srcfile="", [string]$destfile="")

Write-Host "copytimestamps SrcFile: $srcfile"
Write-Host "copytimestamps DestFile: $destfile"

$djTmpDate=(Get-ChildItem $srcfile).CreationTime
Write-Host "CreationTime: $djTmpDate"
(Get-Item $destfile).CreationTime=$djTmpDate;

$djTmpDate=(Get-ChildItem $srcfile).lastaccesstime;
(Get-Item $destfile).lastaccesstime=$djTmpDate;

$djTmpDate=(Get-ChildItem $srcfile).lastwritetime;
(Get-Item $destfile).lastwritetime=$djTmpDate;
