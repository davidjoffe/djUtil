# djUtil
Small simple helper utility scripts to help batch convert images or videos etc.

Includes e.g. small simple helper scripts to losslessly batch convert all .png files in a folder to JPEG XL (.jxl) (https://github.com/libjxl/libjxl), or vice versa, with attempted preservation of metadata and file timestamps (.jxl files may be much smaller than same .png, and if using lossless there is no loss of data, though be careful if you have important .png metadata e.g. exif tags).

## Instructions

* Add this folder to your Windows system path
* Then stand in any folder with a command prompt and call either 'all2jxl' or 'djconvall_png2jxl'
* NB: The default option is to convert LOSSLESS, which will produce file sizes somewhat smaller than the original PNG (with zero loss at all of image information), but if you want much better file size reduction (and don't mind some loss), you can specify the lossiness distance value as a setting or parameter when calling (1.0 is a good 'rule of thumb' value where you may get around 10:1 file size reduction with relatively negligible image quality loss for most purposes, but tweak settings depending on your purpose)
* NB: The default 'effort' option is set for maximum compression but highest CPU usage and slow compression time (9) - if you want to speed up the process, either change the djEFFORT setting in the script, or pass it in as second parameter, with values lower than 9. Note that the process will then take quicker, but you won't get the most optimal image compression/quality anymore.
* Optionally pass in lossiness conversion distance value if desired
* Optionally you may also pass in the 'effort' as a second parameter (default is 9, which is longest CPU usage for best compression, use lower values to speed up process if you don't need perfection)
* So e.g. calling 'all2jxl 0.95' will have very visually good images with some loss, but still good compression. Calling e.g. 'all2jxl 2.0' you may start to see some loss, which depending on your perfection level and usage/application may be tolerable)

* NOTE: This does not delete the original PNG files, so you can re-run the process with different values and compare the results
  
