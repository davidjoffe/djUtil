@rem dj2023-08 helper to 'undo' png2jxl and re-convert jxl files back to PNG (with metadata) in case we go back to some other format in future as it's not clear jxl will remain important (though I suspect it should)
@rem NB this whole thing is meant to be lossless, so e.g. should preserve round-robin all image data, metadata and original file timestamps

@echo off

rem Set the codepage to UTF-8
chcp 65001

rem Get the current directory
set curdir=%cd%

rem Get a list of all JXL files in the current directory
set /a count=0
for /r %%f in (*.jxl) do (

	rem Echo the filename
	echo Converting %%f...

	rem Increment the counter
	set /a count+=1

	rem Decompress the JXL file to a PNG file
	@echo djxl "%%f" "%%~nf.png"
	djxl "%%f" "%%~nf.png"

	rem Optimize the PNG file with optipng
	optipng -quiet -o7 "%%~nf.png"

	rem Load the metadata from the JSON file (that we generated previously with exiftool when creating the JXL, if it's there - if not, it's not a train smash) into the PNG file
	exiftool -tagsfromfile "%%~nf_metadata.json" "%%~nf.png"

	@rem call copytimestamps.bat "%%f" "%%~nf.png"
	@echo call copytimestamps.bat "%%f" "%%~nf.png"
	call copytimestamps.bat "%%f" "%%~nf.png"
)

echo Done!
echo A total of %count% files were converted.
