@rem Small helper bat file to copy all the file timestamps from one file to another (i.e. actual created date, and last modified, which can become lost or corrupt sometimes when copying or converting files) - dj
@rem This is a small wrapper .bat to a powershell script that actually does the job
@rem dj2023
@rem -------------------------------------------

@rem Add this 'setlocal disabledelayedexpansion' here because otherwise if passed in filenames or foldernames with exclamations they don't work properly  - dj2023-08
setlocal disabledelayedexpansion
@rem @echo parameters %*

@set djScriptFolder=%~dp0
@echo djScriptFolder=%djScriptFolder%
@rem pause

@echo powershell -ExecutionPolicy Unrestricted -File "%djScriptFolder%\copytimestamps.ps1" -srcfile %1 -destfile %2
powershell -ExecutionPolicy Unrestricted -File "%djScriptFolder%\copytimestamps.ps1" -srcfile %1 -destfile %2
endlocal
@rem pause
