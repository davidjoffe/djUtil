param([string]$srcfile="", [string]$destfile="")

Write-Host "SrcFile: $srcfile"
Write-Host "DestFile: $destfile"

$djTmpDate=(Get-ChildItem $srcfile).CreationTime
Write-Host "CreationTime: $djTmpDate"
(Get-Item $destfile).CreationTime=$djTmpDate;

$djTmpDate=(Get-ChildItem $srcfile).lastaccesstime;
(Get-Item $destfile).lastaccesstime=$djTmpDate;

$djTmpDate=(Get-ChildItem $srcfile).lastwritetime;
(Get-Item $destfile).lastwritetime=$djTmpDate;
