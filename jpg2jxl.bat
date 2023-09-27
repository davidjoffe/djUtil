@rem Set the codepage to UTF-8
@chcp 65001
@rem Create local scope for variable names to prevent clashing with other running instances if running in parallel (I think, or somesuch - not 100% sure about this - dj2023-08)
@setlocal

@set djScriptFolder=%~dp0
@echo djScriptFolder=%djScriptFolder%

@echo %1 %2 > jpg2jxl_log.txt
@call "%djScriptFolder%\djconvall_jpg2jxl.bat" %1 %2
