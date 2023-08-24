@rem dj2023-08 helper to convert all .png flies in current folder to jxl
@rem NB this whole thing is meant to be lossless, so e.g. should preserve round-robin all image data, metadata and original file timestamps
@echo off

@rem set djMETADATA=y
set djMETADATA=y
set djMETADATA_TEXT=n
set djMETADATA_JSON=y
@rem set djDISTANCE=1
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

	rem Echo the filename
	echo Converting "%%f" distance %djDISTANCE% to "%%~nf.jxl" ...
	@echo filename only %%~nf

	rem Keep the EXIF data in the JXL file
	rem and support utf8 filename
	@rem cjxl --set-option=exif=keep --set-option=utf8=1 "%%f.jxl"

	rem Convert the PNG file to a JXL file with lossless compression and maximum effort
	@rem cjxl -d 0 -e 9 %%f %%f.jxl

	rem Convert the PNG file to a JXL file with lossless compression and maximum effort, keeping the EXIF data
	@rem cjxl -d 0 -e 9 --set-option=exif=keep --set-option=utf8=1   "%%f" "%%f.jxl"
	@rem cjxl -d 0 -e 1   "%%f" "%%f.jxl" --set-option=exif=copy
	@rem -e compression effort, 9 means spend most time/CPU to get smallest file
	cjxl -d %djDISTANCE% -e 9   "%%f" "%%~nf.jxl" 
	
	@rem exiftool -tagsFromFile "%%i" -all:all "%%i.jxl"
	@rem exiftool -overwrite_original_in_place -delete_original -r "%%i.jxl	
	
	if "%djMETADATA%"=="y" (
		@echo Copying metadata for: %%f
		exiftool -tagsFromFile "%%f" -all:all "%%~nf.jxl"
		@rem -b for binary data (e.g. Mac screenshots have binary data)
		if "%djMETADATA_TEXT%"=="y" (
			exiftool -all -b -s "%%f" > "%%~nf_metadata.txt"
		)
		if "%djMETADATA_JSON%"=="y" (
			exiftool -all -b -s -j "%%f" > "%%~nf_metadata.json"
		)

		@rem exiftool -overwrite_original_in_place -delete_original -r "%%f_metadata.jxl"
		@rem Use ImageMagick to copy the metadata 
		@rem convert "%%f" -set exif:all "%%f.jxl"
	)

	@rem Call my helper to copy and preserve original file timestamps e.g. create date
	call copytimestamps.bat "%%f" "%%~nf.jxl"
	if "%djMETADATA%"=="y" (
		if "%djMETADATA_TEXT%"=="y" (
			call copytimestamps.bat "%%f" "%%~nf_metadata.txt"
		)
		if "%djMETADATA_JSON%"=="y" (
			call copytimestamps.bat "%%f" "%%~nf_metadata.json"
		)
	)
	
	@echo Done %%f
	@rem exiftool
	@echo ---------------------------------------------------------
)

echo Done! %curdir%
