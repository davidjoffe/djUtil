@echo off
@echo Small simple helper to convert all .png files in current folder to webp
@echo Assumes cwebp is installed and available in path

@REM setlocal enabledelayedexpansion
@REM 
@REM for /r %%i in (*.png) do (
@REM     set filename=%%~ni
@REM     cwebp -quiet "%%i" -o "!filename!.webp"
@REM )

@echo off

@rem Create local scope for variable names to prevent clashing with other running instances if running in parallel (I think, or somesuch - not 100% sure about this - dj2023-08)
setlocal

setlocal enabledelayedexpansion

rem Set the codepage to UTF-8
chcp 65001


for %%i in (*.png) do (
    set filename=%%~ni
    cwebp -quiet "%%i" -o "!filename!.webp"

	@rem Call helper to try copy and preserve original file timestamps e.g. file created date, modified date etc.
	call copytimestamps.bat "%%i" "!filename!.webp"
)
