ECHO Welcome To Auto Installer 



set "kaynak_klasor=%cd%"
set "hedef_klasor=C:\Elkon"

if not exist "%hedef_klasor%" (
    mkdir "%hedef_klasor%"

    xcopy "%kaynak_klasor%\*" "%hedef_klasor%\" /E /I
) else (
    xcopy "%kaynak_klasor%\*" "%hedef_klasor%\" /E /I
)

cd "C:\Elkon"

echo Dosyalar kopyalandı.

start /WAIT /d "01_Programs\01_ABB\AB\" start_menu.exe 
ECHO ABB is closed successfuly
start /WAIT /d "01_Programs\01_ABB\AdditionalTools\" start_menu.exe 
::set "params=%*"
::cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
@echo off
setlocal enabledelayedexpansion

cd "C:\Elkon"
cd "01_Programs"
cd "02_Reliance"

set "reli_sabit_kisim=reli"
set "reli_dosya_adi="
set "reli_dosya_yolu="

set "sentinel_sabit_kisim=sentinel"
set "sentinel_dosya_adi="
set "sentinel_dosya_yolu="

for %%f in ("%reli_sabit_kisim%*") do (
    set "reli_dosya_adi=!reli_dosya_adi! %%~nxf"
)

for %%f in ("%sentinel_sabit_kisim%*") do (
    set "sentinel_dosya_adi=!sentinel_dosya_adi! %%~nxf"
)

setx sentinel_dosya_adi !sentinel_dosya_adi!
setx reli_dosya_adi !reli_dosya_adi!

for  %%A in ("%reli_dosya_adi%") do (
    set "reli_dosya_yolu=%%~dpA"
)

for  %%A in ("%sentinel_dosya_adi%") do (
    set "sentinel_dosya_yolu=%%~dpA"
)

if defined reli_dosya_yolu (
    echo Reli has found:
    echo Dosya Yolu: !reli_dosya_yolu!
    echo Dosya Adi: %reli_dosya_adi%
) else (
    echo Reli hasn't bulunamadı.
)

if defined sentinel_dosya_yolu (
    echo Sentinel has found:
    echo Dosya Yolu: !sentinel_dosya_yolu!
    echo Dosya Adi: %sentinel_dosya_adi%
) else (
    echo Sentinel hasn't found.
)

setx reli_dosya_yolu !reli_dosya_yolu!
setx sentinel_dosya_yolu !sentinel_dosya_yolu!



endlocal

set "reli_klasor_adi=rsetup"
echo Reli Dosya Adi: %reli_dosya_adi%
echo Reli Klasör Adi : %reli_klasor_adi%
echo -----------------------------------------
set "sentinel_klasor_adi=ssetup"
echo Sentinel File Name : %sentinel_dosya_adi%
echo Sentinel Folder Name : %sentinel_klasor_adi%

echo Reli File Path : %reli_dosya_yolu%
echo Sentinel File Path : %sentinel_dosya_yolu%


set "reli_hedef_klasor=%reli_dosya_yolu%%reli_klasor_adi%"
set "sentinel_hedef_klasor=%sentinel_dosya_yolu%%sentinel_klasor_adi%"
echo %reli_hedef_klasor%
echo %sentinel_hedef_klasor%


if not exist "%reli_hedef_klasor%" (
    mkdir "%reli_hedef_klasor%"

    echo New Reli Folder Has Created

    @echo off
    setlocal
    cd /d %~dp0
    Call :UnZipFile "%reli_hedef_klasor%" "%reli_dosya_yolu%%reli_dosya_adi%"
    exit /b

    echo Reli is going to install.
    start /WAIT /d "%reli_hedef_klasor%\Setup\" Setup.exe

    echo Uzipping has done.
) else (
    echo Şu anki dizin: %cd%
    echo I am here
    start /WAIT /d "%reli_hedef_klasor%\Setup\" Setup.exe
)

if not exist "%sentinel_hedef_klasor%" (
    mkdir "%sentinel_hedef_klasor%"

    echo New Sentinel Folder Has Created

    @echo off
    setlocal
    cd /d %~dp0
    Call :UnZipFile "%sentinel_hedef_klasor%" "%sentinel_dosya_yolu%%sentinel_dosya_adi%"
    exit /b

    echo Uzipping has done.
    echo Sentinel is going to install.
    start /WAIT /d "%sentinel_hedef_klasor%\Sentinel_LDK_Run-time_setup\" HASPUserSetup.exe
) else (
    echo Şu anki dizin: %cd%
    echo I am here sentinel
    start /WAIT /d "%sentinel_hedef_klasor%\Sentinel_LDK_Run-time_setup\" HASPUserSetup.exe
)

:UnZipFile <ExtractTo> <newzipfile>
    set vbs="%temp%\_.vbs"
    if exist %vbs% del /f /q %vbs%
    >%vbs% echo Set fso = CreateObject("Scripting.FileSystemObject")
    >>%vbs% echo If NOT fso.FolderExists(%1) Then
    >>%vbs% echo fso.CreateFolder(%1)
    >>%vbs% echo End If
    >>%vbs% echo set objShell = CreateObject("Shell.Application")
    >>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
    >>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
    >>%vbs% echo Set fso = Nothing
    >>%vbs% echo Set objShell = Nothing
    cscript //nologo %vbs%
    if exist %vbs% del /f /q %vbs%


echo SQL is going to install.
cd "C:\Elkon"
start /WAIT /d "01_Programs\03_SQL\SQL2014\" sqlsetup.cmd



echo Files that you have to have are going to copy.
cd "C:\Elkon"
set "opc_file_dest=C:\ProgramData\Gateway Files"
set "opc_server_file_dest=C:\ProgramData\CoDeSysOPC"
set "oscat_file_dest=C:\Program Files (x86)\Common Files\CAA-Targets\ABB_AC500\AC500_V12\library"

if not exist "%opc_file_dest%" (
    mkdir "%opc_file_dest%"
    echo New OPC Folder Has Created.

    copy /y "01_Programs\04_Ek Dosyalar\Application.SDB" "%opc_file_dest%"
) else (
    copy /y "01_Programs\04_Ek Dosyalar\Application.SDB" "%opc_file_dest%"
)


cd "C:\Elkon"
if not exist "%opc_server_file_dest%" (
    mkdir "%opc_server_file_dest%"
    echo New Opc Server Folder Has Created.

    copy /y "01_Programs\04_Ek Dosyalar\OPCServer.ini" "%opc_server_file_dest%"
) else (
    copy /y "01_Programs\04_Ek Dosyalar\OPCServer.ini" "%opc_server_file_dest%"
)


echo test expre
if not exist "%oscat_file_dest%" (
    mkdir "%oscat_file_dest%"
    echo New Oscat Folder Has Created.

    copy /y "01_Programs\04_Ek Dosyalar\oscat_basic_333.lib" "%oscat_file_dest%"
) else (
    copy /y "01_Programs\04_Ek Dosyalar\oscat_basic_333.lib" "%oscat_file_dest%"
)

echo Geçerli Dizin: %cd%
cd "C:\Elkon"
cd "00_Project"
cd "02_Scada"


set "elkon_sabit_kisim=ElkonSCADA"
set "elkon_dosya_adi="
set "elkon_dosya_yolu="
echo Geçerli Dizin: %cd%


for %%f in ("%elkon_sabit_kisim%*") do (
    set "elkon_dosya_adi=%%~nxf"
)

for  %%A in ("%elkon_dosya_adi%") do (
    set "elkon_dosya_yolu=%%~dpA"
)

if defined elkon_dosya_yolu (
    echo Elkon has found:
    echo Dosya Yolu: %elkon_dosya_yolu%
    echo Dosya Adi: %elkon_dosya_adi%
) else (
    echo Elcon hasn't found.
)

echo finished

:: set "elkon_klasor_adi=%elkon_dosya_adi:~0,-4%"
set "elkon_klasor_adi=esetup"
echo Elkon Dosya Adi: %elkon_dosya_adi%
echo Elkon Klasör Adi : %elkon_klasor_adi%



set "elkon_hedef_klasor=%elkon_dosya_yolu%%elkon_klasor_adi%"
echo %elkon_hedef_klasor%

echo "%elkon_dosya_yolu%%elkon_dosya_adi%"


if not exist "%elkon_hedef_klasor%" (
    mkdir "%elkon_hedef_klasor%"

    echo New Elkon Folder Has Created

    @echo off
    setlocal
    cd /d %~dp0
    Call :UnZipFile2 "%elkon_hedef_klasor%" "%elkon_dosya_yolu%%elkon_dosya_adi%"
    exit /b

    echo Uzipping has done.
) else (
    echo Şu anki dizin: %cd%
)

:UnZipFile2 <ExtractTo> <newzipfile>
    set vbs="%temp%\_.vbs"
    if exist %vbs% del /f /q %vbs%
    >%vbs% echo Set fso = CreateObject("Scripting.FileSystemObject")
    >>%vbs% echo If NOT fso.FolderExists(%1) Then
    >>%vbs% echo fso.CreateFolder(%1)
    >>%vbs% echo End If
    >>%vbs% echo set objShell = CreateObject("Shell.Application")
    >>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
    >>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
    >>%vbs% echo Set fso = Nothing
    >>%vbs% echo Set objShell = Nothing
    cscript //nologo %vbs%
    if exist %vbs% del /f /q %vbs%


@echo off




cd "C:\Elkon"
@echo off

set "gercek_dosya_yolu=%elkon_dosya_yolu%%elkon_klasor_adi%\Elkon_QuickNew_v1.rp4"
set "alias_alias=C:\Program Files (x86)\GEOVAP\Reliance4\R_Ctl.exe"
set "kisayol_adi=Elkon_QuickNew_v1.lnk"
set "masaustu_klasor=%USERPROFILE%\Desktop\"

echo Set wshShell = CreateObject("WScript.Shell")> CreateShortcut.vbs
echo set link = wshShell.CreateShortcut("%masaustu_klasor%%kisayol_adi%")>> CreateShortcut.vbs
echo link.TargetPath = "%alias_alias%">> CreateShortcut.vbs
echo link.Arguments = "%gercek_dosya_yolu%">> CreateShortcut.vbs
echo link.Save>> CreateShortcut.vbs

cscript /nologo CreateShortcut.vbs
del CreateShortcut.vbs

echo Shortcut Has Created.

echo Kurulum Tamamlandı.

pause


