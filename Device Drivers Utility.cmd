cls
@pushd %~dp0
@echo	--------------------------------------------------------------------------
@echo	--------------------------------------------------------------------------
@echo	---        		   	Drivers Helper			      ---
@echo	---          		  	(Ver. 1.6)           	      	 ---
@echo	---    			   Made by Sebastian Jones     		     ---
@echo	--------------------------------------------------------------------------
@echo	--------------------------------------------------------------------------
@echo.
@echo.
@echo off

:isAdmin
fsutil dirty query %systemdrive% >nul
if %errorlevel% == 0 goto :NextStep
@echo	You must run this tool as an Administrator. Press any key to exit...
pause > nul
exit

:NextStep
@echo.
@echo Are you exporting or importing drivers?
@echo 1. Exporting
@echo 2. Importing
set /p choice=Enter a selection: 

if NOT %choice% == 1 ( 
	if NOT %choice% == 2 goto :NextStep
)

if %choice% == 1 goto :export
if %choice% == 2 goto :import

:export
@echo -------------------------------------------------------------------------------
@echo Beginning export process.
timeout /nobreak 1 > NUL
@echo Creating %cd%Drivers\ ...
timeout /nobreak 1 > NUL
@echo.
if exist %cd%Drivers (
	@echo Existing Drivers folder found on USB. Would you like to remove?
	rmdir /s %cd%Drivers
	@echo.
	@echo Deleting existing drivers. This may take a few minutes...
)
if exist %cd%Drivers (
	goto :eof
)


mkdir %cd%Drivers

@echo Destination folder created.
timeout /nobreak 1 > NUL
@echo. 
@echo Exporting drivers...

DISM /online /export-driver /destination:%cd%Drivers

timeout /nobreak 1 > NUL
@echo -------------------------------------------------------------------------------
@echo.
@echo Export process completed. See above log for details.
set /p reboot=Press Enter to shut down.
shutdown /s -t 0
goto :end


:import
@echo -------------------------------------------------------------------------------
@echo Beginning import process.
@echo After the process is completed, the system will reboot automatically.
@echo.
timeout /nobreak 1 > NUL
set /p destVol=Please specify the TARGET volume drive letter:

CALL :UpCase destVol

@echo.
set /p confirm=Confirm drivers will be installed on %destVol%: (Y/N) 

if NOT %confirm% == Y (
	if NOT %confirm% == y goto begin
) 

@echo.
@echo Installing drivers from %cd%\Drivers...
timeout /nobreak 1 > NUL

DISM /Image:%destVol%:\ /Add-Driver /Driver:%cd%Drivers /Recurse

@echo -------------------------------------------------------------------------------
@echo .
@echo Driver installation process completed. See above log for details.
set /p reboot=Press Enter to reboot.
shutdown /r -t 0

goto :end

:UpCase
if not defined %~1 exit /b
for %%a in ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z" "ä=Ä" "ö=Ö" "ü=Ü") do (
call set %~1=%%%~1:%%~a%%
)
goto :eof


:end
@echo -------------------------------------------------------------------------------
pause
	
