@echo off
@rem dj2023-08 helper to convert all .png files in current folder to jxl
@rem NB this whole thing is meant to be lossless, so e.g. should preserve round-robin all image data, metadata and original file timestamps
@rem (In theory this should work recursively also on folders, though use with caution - dj2023-08)

@rem TODOs:
@rem Note this stuff doesn't seem to properly copy e.g. Stable Diffusion 'Parameter' exif tags etc. - todo, see if there are exiftool flags we can use to force it, or try use other software eg ImageMagic

rem Set the codepage to UTF-8
chcp 65001

@rem Create local scope for variable names to prevent clashing with other running instances if running in parallel (I think, or somesuch - not 100% sure about this - dj2023-08)
setlocal

@rem setlocal enabledelayedexpansion

@rem set djMETADATA=y
@echo djMETADATA setting controls whether or not to try transfer metadata from PNG to JXL. Requires exiftool
set djMETADATA=y
@echo djMETADATA_TEXT setting controls whether or not to save a copy of the PNG metadata to an extra .txt file during conversion alongside the created .jxl file and original png file. Requires exiftool
set djMETADATA_TEXT=n
@echo djMETADATA_JSON setting controls whether or not to save a copy of the PNG metadata to an extra .json file during conversion alongside the created .jxl file and original png file. Requires exiftool
set djMETADATA_JSON=y
set djNO_OVERWRITE_IFEXISTS=y

@rem If 'y' makes the output extension .png.jxl (in case you want to know later it came from that original png), otherwise just .jxl
set djAPPENDEXTENSION=n
set djLISTFIRST=n

@rem cjxl -e effort. By default maximum effort for best file size, lower this value for faster conversion
@rem 9 means spend most time/CPU to get smallest file
set djEFFORT=9
@rem set djDISTANCE=1
@rem cjxl -d distance. A distance of 0 means LOSSLESS compression
@rem If a parameter has been passed in to this script make it the lossiness distance value -d for cjxl
if "%1"=="" (
	set djDISTANCE=0
) else (
	set djDISTANCE=%1
)
if "%2"=="" (
	set djEFFORT=9
) else (
	set djEFFORT=%2
)
@rem cjxl "--num_threads=N     Number of worker threads (-1 == use machine default, 0 == do not use multithreading)"
set djNUMTHREADS=-1

rem Get the current directory
set curdir=%cd%

@echo ----------------------------------
@echo SETTINGS:
@echo djMETADATA=%djMETADATA%
@echo djMETADATA_TEXT=%djMETADATA_TEXT%
@echo djMETADATA_JSON=%djMETADATA_JSON%
@echo djNO_OVERWRITE_IFEXISTS=%djNO_OVERWRITE_IFEXISTS%
@echo djDISTANCE=%djDISTANCE%
@echo djEFFORT=%djEFFORT%
@echo djNUMTHREADS=%djNUMTHREADS%
@echo FOLDER: %curdir%
@echo ----------------------------------
@rem pause

@echo off
@rem setlocal  enabledelayedexpansion
@rem endlocal

@echo --------------- show list of files to do
if "%djLISTFIRST%"=="y" (
for /r %%f in (*.png) do (
	@rem echo echooooooo %%f 
	@rem Weird kludges to work around exclamation issues, H/T https://stackoverflow.com/questions/36336518/issue-with-special-characters-in-path-exclamation-point-carrot-etc-using - dj2023-08
	set FILENAME=%%f
	setlocal enabledelayedexpansion
    for %%I in ("!FILENAME!") do endlocal & set djINFILE=%%~I
	if "%djAPPENDEXTENSION%"=="y" (
		setlocal enabledelayedexpansion
		for %%I in ("!FILENAME!") do endlocal & set djOUTFILE=%%~dpI%%~nI.png.jxl
	) else (
		setlocal enabledelayedexpansion
		for %%I in ("!FILENAME!") do endlocal & set djOUTFILE=%%~dpI%%~nI.jxl
	)
	@rem call set /P djOUTFILE_MINUS_EXTENSION=%%~dpf%%~nf<NUL & echo;
	setlocal enabledelayedexpansion
    @rem for %%I in ("!FILENAME!") do endlocal & set djOUTFILE_MINUS_EXTENSION=%%~dpI%%~nI& echo(___%%I
	for %%I in ("!FILENAME!") do endlocal & set djOUTFILE_MINUS_EXTENSION=%%~dpI%%~nI

	setlocal  enabledelayedexpansion
	echo CONVERT: "!djINFILE!"
	echo TO FILE: "!djOUTFILE!"
	endlocal
)
)
@rem pause



rem Get a list of all PNG files in the current directory
for /r %%f in (*.png) do (
	@rem Note this filename may have spaces in so when we use it we put quotes around it
	@rem set djOUTFILE=%%~dpf%%~nf.png.jxl
	@rem OLD WAY set djINFILE=%%f
	@rem OLD WAY set djOUTFILE_MINUS_EXTENSION=%%~dpf%%~nf
	@rem Full path and filename
	@rem OLD WAY set djOUTFILE=%%~dpf%%~nf.jxl

	@rem Weird kludges to work around exclamation issues, H/T https://stackoverflow.com/questions/36336518/issue-with-special-characters-in-path-exclamation-point-carrot-etc-using - dj2023-08
	set FILENAME=%%f
	setlocal enabledelayedexpansion
    for %%I in ("!FILENAME!") do endlocal & set djINFILE=%%~I

	if "%djAPPENDEXTENSION%"=="y" (
		setlocal enabledelayedexpansion
		for %%I in ("!FILENAME!") do endlocal & set djOUTFILE=%%~dpI%%~nI.png.jxl
	) else (
		setlocal enabledelayedexpansion
		for %%I in ("!FILENAME!") do endlocal & set djOUTFILE=%%~dpI%%~nI.jxl
	)

	@rem call set /P djOUTFILE_MINUS_EXTENSION=%%~dpf%%~nf<NUL & echo;
	setlocal enabledelayedexpansion
	for %%I in ("!FILENAME!") do endlocal & set djOUTFILE_MINUS_EXTENSION=%%~dpI%%~nI
    @rem for %%I in ("!FILENAME!") do endlocal & set djOUTFILE_MINUS_EXTENSION=%%~dpI%%~nI& echo(___%%I



	setlocal enabledelayedexpansion

	rem Echo the filename
	@echo ---------------
	@echo ---------------
	@echo CONVERTING "!djINFILE!" to "!djOUTFILE!" distance !djDISTANCE! effort !djEFFORT! threads !djNUMTHREADS!
	@rem @echo LOG filename only %%~nf, pathonly "%%~dpf", target "!djOUTFILE!"
	
    rem Check for zero-byte input file and warn user
    if %%~zf==0 (
        echo WARNING: EMPTY INPUT FILE WITH 0 BYTES SIZE "!djINFILE!"
    )



	rem Don't re-do if file already exists (but only if setting it set, this allow restart if stopped halfway)
	if "!djNO_OVERWRITE_IFEXISTS!"=="y" (
		IF EXIST "!djOUTFILE!" (
			echo SKIPPING EXISTING FILE "!djOUTFILE!"
		) ELSE (
			rem Convert the PNG file to a JXL file with maximum effort by default 
			cjxl -d !djDISTANCE! -e !djEFFORT! --num_threads=!djNUMTHREADS!    "!djINFILE!" "!djOUTFILE!"
		)
	) ELSE (
		rem Convert the PNG file to a JXL file with maximum effort by default
		cjxl -d !djDISTANCE! -e !djEFFORT! --num_threads=!djNUMTHREADS!   "!djINFILE!" "!djOUTFILE!"
	)
	rem Keep the EXIF data in the JXL file
	rem and support utf8 filename
	@rem cjxl --set-option=exif=keep --set-option=utf8=1 "!djINFILE!.jxl"

	@rem Check if file was created and try warn user if something went wrong
	IF NOT EXIST "!djOUTFILE!" (
		echo ERROR: OUTPUT FILE NOT CREATED: !djOUTFILE! from !djINFILE!
	)

	@rem dj2023-08 NOTE this stuff doesn't seem to properly copy e.g. Stable Diffusion 'Parameter' exif tags etc.
	@rem exiftool -tagsFromFile "%%i" -all:all "%%i.jxl"
	@rem exiftool -overwrite_original_in_place -delete_original -r "%%i.jxl	
	
	@echo DO METADATA !djMETADATA!
	if "!djMETADATA!"=="y" (
		@echo Copying metadata for: !djINFILE!
		exiftool -tagsFromFile "!djINFILE!" -all:all "!djOUTFILE!"

		@rem exiftool -overwrite_original_in_place -delete_original -r "!djINFILE!_metadata.jxl"

		@rem Alternative attempt to use ImageMagick to copy the metadata 
		@rem convert "!djINFILE!" -set exif:all "!djOUTFILE!"
	)
	@rem -b for binary data (e.g. Mac screenshots have binary data)
	if "!djMETADATA_TEXT!"=="y" (
		@echo Trying to save metadata to "!djOUTFILE_MINUS_EXTENSION!__pngmetadata.txt"
		exiftool -all -b -s "!djINFILE!" > "!djOUTFILE_MINUS_EXTENSION!__pngmetadata.txt"
	)
	if "!djMETADATA_JSON!"=="y" (
		@echo Trying to save metadata to "!djOUTFILE_MINUS_EXTENSION!__pngmetadata.json"
		exiftool -all -b -s -j "!djINFILE!" > "!djOUTFILE_MINUS_EXTENSION!__pngmetadata.json"
	)


	@rem Call my helper to copy and preserve original file timestamps e.g. create date
	call copytimestamps.bat "!djINFILE!" "!djOUTFILE!"
	if "!djMETADATA!"=="y" (
		if "!djMETADATA_TEXT!"=="y" (
			@echo Copy timestamps to "!djOUTFILE_MINUS_EXTENSION!__pngmetadata.txt"
			call copytimestamps.bat "!djINFILE!" "!djOUTFILE_MINUS_EXTENSION!__pngmetadata.txt"
		)
		if "!djMETADATA_JSON!"=="y" (
			@echo Copy timestamps to "!djOUTFILE_MINUS_EXTENSION!__pngmetadata.json"
			call copytimestamps.bat "!djINFILE!" "!djOUTFILE_MINUS_EXTENSION!__pngmetadata.json"
		)
	)

	@echo Done "!djINFILE!" to "!djOUTFILE!"
	@echo ---------------------------------------------------------
	endlocal
)

echo DONE %curdir%
