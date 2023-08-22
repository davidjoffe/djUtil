@echo Small helper bat file to copy all the file timestamps from one file to another (i.e. actual created date, and last modified, which can become lost or corrupt sometimes when copying or converting files) - dj
@echo This is a small wrapper .bat to a powershell script that actually does the job

@set djScriptFolder=%~dp0
@echo djScriptFolder=%djScriptFolder%

powershell -ExecutionPolicy Unrestricted -File "%djScriptFolder%\copytimestamps.ps1" -srcfile %1 -destfile %2

