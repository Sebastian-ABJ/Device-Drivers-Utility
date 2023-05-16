cls
@pushd %~dp0
@echo	--------------------------------------------------------------------------
@echo	--------------------------------------------------------------------------
@echo	---        		   Device Drivers Utility		       ---
@echo	---          		  	(Ver. 2.0.2)           	       	       ---
@echo	--------------------------------------------------------------------------
@echo	--------------------------------------------------------------------------
@echo	---   This software is licensed under the Mozilla Public License 2.0   ---
@echo	--------------------------------------------------------------------------
@echo.
@echo off

:: Get Administrator Rights
set _Args=%*
if "%~1" NEQ "" (
  set _Args=%_Args:"=%
)
fltmc 1>nul 2>nul || (
  cd /d "%~dp0"
  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0"" ""%_Args%""", "", "runas", 1 > "%temp%\GetAdmin.vbs"
  "%temp%\GetAdmin.vbs"
  del /f /q "%temp%\GetAdmin.vbs" 1>nul 2>nul
  exit
)

:begin
wmic logicaldisk get name,volumename,filesystem

set /p destVolInput=Please specify the OLD OS volume letter: 
set destVol=%destVolInput:~0,1%
CALL :UpCase destVol

@echo.
set /p confirm=Confirm drivers will be installed on %destVol%: (Y/N) 

if NOT %confirm% == Y (
	if NOT %confirm% == y goto begin
) 

:export
@echo -------------------------------------------------------------------------------
@echo Beginning export process.
timeout /nobreak 1 > NUL
@echo Creating destination folder at %cd%\Drivers\
timeout /nobreak 1 > NUL
if exist %cd%\Drivers (
	@echo.
	@echo Removing existing drivers. This process may take a few minutes...
	rmdir /s /q %cd%\Drivers > nul
	@echo Done!
)
if exist %cd%\Drivers (
	goto :eof
)

mkdir %cd%\Drivers

@echo Destination folder created.
timeout /nobreak 1 > NUL

@echo. 
@echo Exporting drivers...

DISM /online /export-driver /destination:%cd%\Drivers
@echo.

@echo Export complete!

:import
@echo -------------------------------------------------------------------------------
@echo Beginning import process.
@echo.
timeout /nobreak 1 > NUL

@echo Installing drivers from %cd%\Drivers...
timeout /nobreak 1 > NUL

DISM /Image:%destVol%:\ /Add-Driver /Driver:%cd%\Drivers /Recurse
@echo.

@echo Installation complete!
@echo -------------------------------------------------------------------------------


goto end

:UpCase
if not defined %~1 exit /b
for %%a in ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z" "ä=Ä" "ö=Ö" "ü=Ü") do (
call set %~1=%%%~1:%%~a%%
)
goto :eof

:end
@echo -------------------------------------------------------------------------------
@echo.
@echo Drivers imported from current OS to target OS! System is ready to clone.
set /p reboot=Press Enter to shut down.
shutdown /s -t 0
	
