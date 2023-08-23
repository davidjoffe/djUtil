# djUtil
Small simple helper utility scripts to help batch convert images or videos etc.

Includes e.g. small simple helper scripts to losslessly batch convert all .png files in a folder to JPEG XL (.jxl) (https://github.com/libjxl), or vice versa, with attempted preservation of metadata and file timestamps (.jxl files may be much smaller than same .png, and if using lossless there is no loss of data, though be careful if you have important .png metadata e.g. exif tags)

