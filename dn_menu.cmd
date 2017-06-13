@echo off
setlocal enableextensions enabledelayedexpansion

::  Some source folders
set _src1=\\one\Share
set _src2=\\two\Share
:: A destination folder
set _dest=C:\temp
:: Start point for counting. Must be the same for all counts.
set _start=-1
:: Create the destination folder
if not exist "%_dest%" md "%_dest%"

:soAppMenu
:: [Re-]initialize the selected item and menu count
set _choice=
set /a _i=%_start%

cls && echo Test for a menu with dynamic numbering.
echo. && echo Choose from the following: && echo.
:: Generate the menu
for /f "usebackq tokens=2 delims=;" %%A in (`findstr /b /c:"::menu1" "%~dpnx0"`) do (
	set /a _i+=1
	echo.!_i! %%~A
	)
echo.
:: Prompt for selection from the menu
set /p _choice=Please enter the number for your selection^:^ 
if not defined _choice goto :soAppMenu
if %_choice%==0 exit /b
if %_choice% LSS 0 goto :soAppMenu
if %_choice% GTR %_i% goto :soAppMenu
set /a _n=%_start%
for /f "usebackq tokens=3-4 delims=;" %%a in (`findstr /b /c:"::menu1" "%~dpnx0"`) do (
	set /a _n+=1
	if !_n!==%_choice% call :Stg "%%~a" "%%~b"
	)
goto soAppMenu
echo Out of bounds
exit /b 99999

:Stg
echo robocopy "%~1" "%_dest%\%~2" /e /r:2 /w:2 /np /tee /log+:"%_dest%\stageonc.txt"
call :JuanDebug "During :Stg procedure"
exit /b

:JuanDebug
echo.%~1
echo.
set _
echo.
pause

:: Menu items. 1 added so that multiple menus may be used in the same script
::menu1;Exit;Exit;Exit
::menu1;Adobe Acrobat Reader DC;%_src1%\Non MicroSoft\Adobe Reader;AdobeReader
::menu1;Adobe Acrobat Professional XI;%_src2%\Non MicroSoft\Acrobat Professional\XI;AcrobatPro11
