@rem dj2023-08 helper to convert all .png files in current folder to jxl
@rem NB this whole thing is meant to be lossless, so e.g. should preserve round-robin all image data, metadata and original file timestamps
@rem (In theory this should work recursively also on folders, though use with caution - dj2023-08)
@echo off

setlocal enabledelayedexpansion

@rem set djMETADATA=y
set djMETADATA=y
set djMETADATA_TEXT=n
set djMETADATA_JSON=y
set djNO_OVERWRITE_IFEXISTS=y

@rem cjxl -e effort. By default maximum effort for best file size, lower this value for faster conversion
set djEFFORT=9
@rem set djDISTANCE=1
@rem cjxl -d distance. A distance of 0 means LOSSLESS compression
@rem If a parameter has been passed in to this script make it the lossiness distance value -d for cjxl
if "%1"=="" (
	set djDISTANCE=0
) else (
	set djDISTANCE=%1
)

rem Set the codepage to UTF-8
chcp 65001

rem Get the current directory
set curdir=%cd%

rem Get a list of all PNG files in the current directory
for /r %%f in (*.png) do (
	@rem Append filename to .png so we 
	@rem Note this filename may have spaces in so when we use it we put quotes around it
	@rem set djOUTFILE=%%~dpf%%~nf.png.jxl
	set djINFILE=%%f
	@rem Full path and filename
	set djOUTFILE=%%~dpf%%~nf.jxl

	rem Echo the filename
	@echo 
	@echo ---------------
	@echo CONVERTING !djINFILE! distance !djDISTANCE! to "%%~nf.jxl" ...
	@echo LOG filename only %%~nf, pathonly "%%~dpf", target "!djOUTFILE!"
	
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
			cjxl -d !djDISTANCE! -e !djEFFORT!   "!djINFILE!" "!djOUTFILE!"
		)
	) ELSE (
		rem Convert the PNG file to a JXL file with maximum effort by default
		cjxl -d !djDISTANCE! -e !djEFFORT!   "!djINFILE!" "!djOUTFILE!"
	)
	rem Keep the EXIF data in the JXL file
	rem and support utf8 filename
	@rem cjxl --set-option=exif=keep --set-option=utf8=1 "!djINFILE!.jxl"

	@rem Check if file was created and try warn user if something went wrong
	IF NOT EXIST "!djOUTFILE!" (
		echo ERROR: OUTPUT FILE NOT CREATED: !djOUTFILE! (from !djINFILE!)
	)



	@rem -e compression effort, 9 means spend most time/CPU to get smallest file



	@rem exiftool -tagsFromFile "%%i" -all:all "%%i.jxl"
	@rem exiftool -overwrite_original_in_place -delete_original -r "%%i.jxl	
	
	if "%djMETADATA%"=="y" (
		@echo Copying metadata for: !djINFILE!
		exiftool -tagsFromFile "!djINFILE!" -all:all "!djOUTFILE!"
		@rem -b for binary data (e.g. Mac screenshots have binary data)
		if "%djMETADATA_TEXT%"=="y" (
			exiftool -all -b -s "!djINFILE!" > "%%~dpf%%~nf_metadata.txt"
		)
		if "%djMETADATA_JSON%"=="y" (
			exiftool -all -b -s -j "!djINFILE!" > "%%~dpf%%~nf_metadata.json"
		)

		@rem exiftool -overwrite_original_in_place -delete_original -r "!djINFILE!_metadata.jxl"

		@rem Alternative attempt to use ImageMagick to copy the metadata 
		@rem convert "!djINFILE!" -set exif:all "!djOUTFILE!"
	)

	@rem Call my helper to copy and preserve original file timestamps e.g. create date
	call copytimestamps.bat "!djINFILE!" "!djOUTFILE!"
	if "!djMETADATA!"=="y" (
		if "!djMETADATA_TEXT!"=="y" (
			call copytimestamps.bat "!djINFILE!" "%%~dpf%%~nf_metadata.txt"
		)
		if "!djMETADATA_JSON!"=="y" (
			call copytimestamps.bat "!djINFILE!" "%%~dpf%%~nf_metadata.json"
		)
	)

	@echo Done "!djINFILE!" to "!djOUTFILE!"
	@rem exiftool
	@echo ---------------------------------------------------------
)

echo Done! !curdir!
