@echo off
cls
cd /d "%~dp0"
title Sonic Unleashed Mod Toolbox 1.4
set is_empty=true
set is_edat=false
for %%f in (#files\*.*) do (
set is_empty=false
)


if /i %is_empty% neq false (
echo ERROR
echo ---------------
echo No files detected!
echo Please place your files in the "#files" folder...
echo.
pause
exit
)

:begg
for %%f in (#files\*.edat) do (
set is_edat=true
)

cls
echo SELECT OPTION
echo ---------------------
echo 1 - Encrypt to EDAT (PS3 ONLY)
echo 2 - Decrypt from EDAT (PS3 ONLY)
echo 3 - Decompress AR file
echo 4 - Extract AR file
echo 5 - Pack AR file
echo.
set /p option=Type the number of the mode you want to use and press ENTER:
if "%option%" EQU "" goto begg
if /i %option% NEQ 1 if %option% NEQ 2 if /i %option% NEQ 3 if /i %option% NEQ 4 if /i %option% NEQ 5 goto begg
if %option% EQU 1 (goto begin)
if %option% EQU 2 (goto decrypt)
if %option% EQU 3 (goto decompressar)
if %option% EQU 4 (goto extractarfile)
if %option% EQU 5 (goto packar)

:begin
cls
echo ENCRYPT (PS3 ONLY)
echo.
echo SELECT REGION
echo NOTE: Type "b" to go back to the main menu
echo ---------------------
echo Europe (NPEB) or US (NPUB)?
echo 1 - Europe
echo 2 - US
echo.
set /p region=Type the number of your region and press ENTER:
if "%region%" EQU "" goto begin
if /i %region% NEQ 1 if %region% NEQ 2 if /i %region% NEQ b goto begin
if %region% EQU 1 (set region=NPEB01347)
if %region% EQU 2 (set region=NPUB31204)
if /i %region% EQU b (goto begg)

del /s /q .\edat_rebuilder\edat\
timeout /t 1 /nobreak >nul
md .\edat_rebuilder\edat\
xcopy /s /y #files .\edat_rebuilder\edat >nul
xcopy /y files\ZzZz.ZzZz .\edat_rebuilder\edat >nul
del /s /q .\edat_rebuilder\edat\Sound
rd /s /q #output\EncryptedModFiles\

cls
echo ENCRYPTING...
echo ----------------------------------------------
echo The encryption process has started...
echo.
echo Please wait until it's finished. The conversion
echo process will resume automatically.
cd edat_rebuilder
if /i %region% EQU NPEB01347 (codeEU.vbs)
if /i %region% EQU NPUB31204 (codeUS.vbs)
:check_end
if exist edat\ZzZz.ZzZz.edat (
timeout /t 1 /nobreak
) else (goto check_end)



cd..
del /s /q files\%region%\USRDIR\
md files\%region%\USRDIR\

if exist #files\Sound (
md files\NP%region%B01347\USRDIR\Sound
xcopy #files\Sound files\%region%\USRDIR\Sound
)
for %%f in (.\edat_rebuilder\edat\*.edat) do (
move /y %%f files\%region%\USRDIR >nul
)

for /d %%f in (.\edat_rebuilder\edat\*) do (
for %%a in (%%f\*.edat) do (
md files\%region%\USRDIR\%%~nf\
move /y %%a files\%region%\USRDIR\%%~nf\ >nul
)
)
for /d %%f in (.\edat_rebuilder\edat\*) do (
for /d %%a in (%%f\*) do (
for %%b in (%%a\*.edat) do (
md files\%region%\USRDIR\%%~nf\%%~na
move /y %%b files\%region%\USRDIR\%%~nf\%%~na >nul
)
)
)
for /d %%f in (.\edat_rebuilder\edat\*) do (
for /d %%a in (%%f\*) do (
for /d %%b in (%%a\*) do (
for %%c in (%%b\*.edat) do (
md files\%region%\USRDIR\%%~nf\%%~na\%%~nb
move /y %%c files\%region%\USRDIR\%%~nf\%%~na\%%~nb >nul
)
)
)
)



del /s /q files\%region%\USRDIR\ZzZz.ZzZz.edat
md #output\EncryptedModFiles\
xcopy /s /q /y files\%region%\USRDIR #output\EncryptedModFiles\
:ask
set createpkg=none
echo.
echo -------------------------------------
set /p createpkg=Do you want to create a package (PKG) file? (Y/N)
if /i %createpkg% NEQ Y if /i %createpkg% NEQ N goto ask
if /i %createpkg% EQU Y (psn_package_npdrm.exe -n pkgconfigs\package%region%.conf files\%region%)

echo.
echo -------------------------------------
echo Done!
echo You may now close this window and the EDAT Rebuilder window.
echo.
echo.
echo Alternatively, press any key to close just this window.
pause >nul
exit



:decrypt
if %is_edat% EQU false (
cls
echo WARNING
echo ----------------
echo No EDAT files detected.
echo Please place you encrypted EDAT files in the #files
echo folder and try again
echo.
echo If you're trying to decompress XBOX360 AR files,
echo please use the third option in the menu.
echo.
echo ----------------
echo Press any key to go back to the main menu...
pause >nul
goto begg
)
cls
echo DECRYPT and DECOMPRESS (PS3 ONLY)
echo.
echo SELECT REGION
echo NOTE: Type "b" to go to back to the main menu
echo ---------------------
echo Europe (NPEB) or US (NPUB)?
echo 1 - Europe
echo 2 - US
echo.
set /p region=Type the number of your region and press ENTER:
if "%region%" EQU "" goto begin
if /i %region% NEQ 1 if %region% NEQ 2 if /i %region% NEQ b goto decrypt
if %region% EQU 1 (set region=NPEB01347)
if %region% EQU 2 (set region=NPUB31204)
if /i %region% EQU b (goto begg)

del /s /q .\edat_rebuilder\edat\
timeout /t 1 /nobreak >nul
md .\edat_rebuilder\edat\
xcopy /s /y #files .\edat_rebuilder\edat >nul
xcopy /y files\ZzZz.ZzZz.edat .\edat_rebuilder\edat >nul
del /s /q .\edat_rebuilder\edat\Sound
rd /q #output\DecryptedFiles\

cls
echo DECRYPTING...
echo ----------------------------------------------
echo The decryption process has started...
echo.
echo Please wait until it's finished. The conversion
echo process will resume automatically.
cd edat_rebuilder
if /i %region% EQU NPEB01347 (decryptcodeEU.vbs)
if /i %region% EQU NPUB31204 (decryptcodeUS.vbs)
:check_endd
if exist edat\ZzZz.ZzZz.dat (
timeout /t 1 /nobreak
) else (goto check_endd)


SETLOCAL EnableDelayedExpansion
cd..
del /s /q files\%region%\USRDIR\
md files\%region%\USRDIR\
if exist #files\Sound (
md files\%region%\USRDIR\Sound
xcopy #files\Sound files\%region%\USRDIR\Sound
)
for %%f in (.\edat_rebuilder\edat\*.dat) do (
set filename=%%~nxf
set nodat=!filename:.dat=!
move /y %%f files\%region%\USRDIR >nul
ren files\%region%\USRDIR\!filename! !nodat!
)

for /d %%f in (.\edat_rebuilder\edat\*) do (
for %%a in (%%f\*.edat) do (
md files\%region%\USRDIR\%%~nf\
move /y %%a files\%region%\USRDIR\%%~nf\ >nul
)
)
for /d %%f in (.\edat_rebuilder\edat\*) do (
for /d %%a in (%%f\*) do (
for %%b in (%%a\*.edat) do (
md files\%region%\USRDIR\%%~nf\%%~na
move /y %%b files\%region%\USRDIR\%%~nf\%%~na >nul
)
)
)
for /d %%f in (.\edat_rebuilder\edat\*) do (
for /d %%a in (%%f\*) do (
for /d %%b in (%%a\*) do (
for %%c in (%%b\*.edat) do (
md files\%region%\USRDIR\%%~nf\%%~na\%%~nb
move /y %%c files\%region%\USRDIR\%%~nf\%%~na\%%~nb >nul
)
)
)
)



del /s /q files\%region%\USRDIR\ZzZz.ZzZz



md #output\DecryptedFiles\
xcopy /s /q /y files\%region%\USRDIR #output\DecryptedFiles\
:ask_decompress
set dec=none
echo.
echo -------------------------------------
set /p dec=Do you want to decompress the AR files? (Y/N)
if /i %dec% NEQ Y if /i %dec% NEQ N goto ask_decompress
if /i %dec% EQU Y (
md #output\DecryptedFiles\out
setlocal enabledelayedexpansion
for %%d in (#output\DecryptedFiles\*.ar.00) do (
echo Extracting AR file for decompression...
artools\quickbms.exe -Q artools\arcsys.bms "%%d" #output\DecryptedFiles\out >nul
set filename=%%~nxd
set noar=!filename:.ar.00=!
for /d %%f in (#output\DecryptedFiles\out\*) do (
ren %%f !noar!
echo Packing decompressed AR...
artools\ar0pack #output\DecryptedFiles\out\!noar!
rd /S /Q #output\DecryptedFiles\out\!noar!
)
)
ren #output\DecryptedFiles\out decompressed
)

echo.
echo -------------------------------------
echo Done!
echo You may now close this window and the EDAT Rebuilder window.
echo.
echo Your decrypted files are in the #output\DecryptedFiles\ folder.
echo Press any key to close this window.
pause >nul
exit

:decompressar
cls
echo DECOMPRESS
echo.
echo SELECT VERSION
echo NOTE: Type "b" to go back to the main menu
echo ---------------------
echo XBOX 360 or PS3?
echo 1 - PS3
echo 2 - XBOX 360
echo.
set /p platform=Type the number of your platform and press ENTER:
if "%platform%" EQU "" goto decompressar
if /i %platform% NEQ 1 if %platform% NEQ 2 if /i %platform% NEQ b goto decompressar
if %platform% EQU 1 (set platf=arcsys)
if %platform% EQU 2 (set platf=X360files)
if /i %platform% EQU b (goto begg)




:extractar
rd /S /Q #output\DecompressedFiles\
md #output\DecompressedFiles\
xcopy /s /q /y #files #output\DecompressedFiles\
md #output\DecompressedFiles\out
setlocal enabledelayedexpansion
for %%d in (#output\DecompressedFiles\*.ar.00) do (
echo Extracting AR file for decompression...
artools\quickbms.exe -Q artools\%platf%.bms "%%d" #output\DecompressedFiles\out >nul
set filename=%%~nxd
set noar=!filename:.ar.00=!
for /d %%f in (#output\DecompressedFiles\out\*) do (
ren %%f !noar!
echo Packing decompressed AR...
artools\ar0pack #output\DecompressedFiles\out\!noar!
rd /S /Q #output\DecompressedFiles\out\!noar!
)
)
xcopy /s /q /y #output\DecompressedFiles\out #output\DecompressedFiles\
rd /S /Q #output\DecompressedFiles\out\

echo.
echo -------------------------------------
echo Done!
echo You may now close this window.
echo.
echo Your decompressed files are in #output\DecompressedFiles\
echo Press any key to close this window.
pause >nul
exit

:extractarfile
cls
echo EXTRACT
echo.
echo SELECT OPTION
echo NOTE: Type "b" to go back to the main menu
echo ---------------------
echo Decompress or only extract?
echo 1 - Decompress and Extract
echo 2 - Extract only (be sure to decompress first)
echo.
set /p opar=Type the number of your platform and press ENTER:
if "%opar%" EQU "" goto extractarfile
if /i %opar% NEQ 1 if %opar% NEQ 2 if /i %opar% NEQ b goto extractarfile
if %opar% EQU 1 (goto decandextar_menu)
if %opar% EQU 2 (goto begin_extar)
if /i %opar% EQU b (goto begg)


:decandextar_menu
cls
echo DECOMPRESS and EXTRACT
echo.
echo SELECT VERSION
echo NOTE: Type "b" to go back to the previous menu
echo ---------------------
echo XBOX 360 or PS3?
echo 1 - PS3
echo 2 - XBOX 360
echo.
set /p platform_e=Type the number of your platform and press ENTER:
if "%platform_e%" EQU "" goto decandextar_menu
if /i %platform_e% NEQ 1 if %platform_e% NEQ 2 if /i %platform_e% NEQ b goto decandextar_menu
if %platform_e% EQU 1 (set platf=arcsys)
if %platform_e% EQU 2 (set platf=X360files)
if /i %platform_e% EQU b (goto extractarfile)


:begin_extar
rd /S /Q #output\DecompressedFiles\
md #output\DecompressedFiles\
xcopy /s /q /y #files #output\DecompressedFiles\
if /i (%opar% EQU 2) goto extar

:decandextar
md #output\DecompressedFiles\out
setlocal enabledelayedexpansion
for %%d in (#output\DecompressedFiles\*.ar.00) do (
echo Extracting AR file for decompression...
artools\quickbms.exe -Q artools\%platf%.bms "%%d" #output\DecompressedFiles\out >nul
set filename=%%~nxd
set noar=!filename:.ar.00=!
for /d %%f in (#output\DecompressedFiles\out\*) do (
ren %%f !noar!
echo Decompressing AR...
artools\ar0pack #output\DecompressedFiles\out\!noar!
rd /S /Q #output\DecompressedFiles\out\!noar!
)
)
xcopy /s /q /y #output\DecompressedFiles\out #output\DecompressedFiles\
rd /S /Q #output\DecompressedFiles\out\

:extar
xcopy /s /q /y #output\DecompressedFiles #output\ExtractedFiles\
rd /S /Q #output\DecompressedFiles\
md #output\ExtractedFiles\
setlocal enabledelayedexpansion
for %%d in (#output\ExtractedFiles\*.ar.00) do (
echo Extracting AR files...
artools\ar0unpack.exe "%%d" >nul
set filename=%%~nxd
set noar=!filename:.ar.00=!
del %%d
)
for %%d in (#output\ExtractedFiles\*.arl) do (del %%d)

echo.
echo -------------------------------------
echo Done!
echo You may now close this window.
echo.
echo Your extracted files are in #output\ExtractedFiles\
echo Press any key to close this window.
pause >nul
exit

:packar
rd /S /Q #output\PackedARFile\
md #output\PackedARFile\
xcopy /s /q /y #files #output\PackedARFile\file\
artools\ar0pack #output\PackedARFile\file
rd /S /Q #output\PackedARFile\file
xcopy /s /q /y #output\PackedARFile\file #output\PackedARFile\

echo.
echo -------------------------------------
echo Done!
echo You may now close this window.
echo.
echo Your packed file is located in #output\PackedARFile\
echo Press any key to close this window.
pause >nul
exit