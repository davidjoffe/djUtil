@set djScriptFolder=%~dp0
@echo djScriptFolder=%djScriptFolder%

echo %1 > all2jxl_log.txt
@call "%djScriptFolder%\djconvall_png2jxl.bat" %1
