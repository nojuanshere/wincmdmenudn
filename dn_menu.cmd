@echo off
:: Configuration
:: Delayed expansion necessary in the For loops
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
:: Menu items: Menu name;Display name;Source;Target
::menu1;Exit;Exit;Exit
::menu1;Adobe Acrobat Reader DC;%_src1%\Non MicroSoft\Adobe Reader;AdobeReader
::menu1;Adobe Acrobat Professional XI;%_src2%\Non MicroSoft\Acrobat Professional\XI;AcrobatPro11

:: Code
:soAppMenu
:: [Re-]initialize the selected item and counter
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
:: Validate choice
if not defined _choice goto :soAppMenu
if %_choice% LSS 0 goto :soAppMenu
if %_choice% GTR %_i% goto :soAppMenu
:: Check for exit
if %_choice%==0 exit /b
:: Re-initialize counter
set /a _i=%_start%
:: Find the selected item and call the :Stg procedure with it's parameters
for /f "usebackq tokens=3-4 delims=;" %%a in (`findstr /b /c:"::menu1" "%~dpnx0"`) do (
	set /a _i+=1
	if !_i!==%_choice% call :Stg "%%~a" "%%~b"
	)
:: Return to the menu
goto soAppMenu
:: Catch exceptions
echo Out of bounds
exit /b 999

:Stg
:: Copy with Robocopy, wait seconds then return to the caller
echo robocopy "%~1" "%_dest%\%~2" /e /r:2 /w:2 /np /tee /log+:"%_dest%\stageonc.txt"
timeout 5
exit /b

:JuanDebug
:: Show info helpful for debuging and return to the caller
echo.%~1
set _
echo.
pause
exit /b
