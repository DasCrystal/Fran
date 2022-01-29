@echo off
cd %~dp0%
set order= & set local= & set localmsg=
set ver=0.4
if exist Franxx (cd Franxx)
if not "%1"=="" (goto %1)

set local=core
goto core
:back
if not exist franxxcmdlist (cd ..)
if "%local:~0,3%"=="adb" (taskkill -f -im adb.exe)
if "%order%"=="exit" (goto eof)
set local=core
set order=
::::::::::::::::::::::::::::::::
:core
::findstr cfg= franxx.conf > miniram && set /p cfg=<miniram && set cfg=%cfg:~4% (設定值讀取命令,不完整)
echo.
echo Franxx Utils %ver% - %local%
echo -----------------------------
if not "%localmsg%"=="" (echo %localmsg%)
if "%2"=="" (set /p order=PlantationShell^>)
set localmsg=
if "%order%"=="back" (goto back)
if "%order%"=="exit" (if "%eofmsg%"=="" (set eofmsg=Have a nice day. Take care. & goto back) else (goto back))
if "%local%"=="core" (
findstr %order% franxxcmdlist > nul && goto %order%
%order% & goto core) else (goto %local%run)
::::::::::::::::::::::::::::::::
:adb
:aa
cd adb
set local=adb
echo Starting adb...
adb start-server
goto core
:adbrun
adb "%order%"
if "%2"=="" (goto %local%) else (goto eof)

:aad
cd adb
set local=adb-devices
adb start-server
adb devices
if "%1"=="" (goto back) else (goto eof)



:fastboot
:af
cd adb
set local=fastboot
if not "%2"=="" (fastboot %2 & goto eof)
goto core
:fastbootrun
fastboot "%order%"
if "%2"=="" (goto %local%) else (goto eof)



:aff
cd adb
set local=fastboot-flash
if not "%2"=="" (fastboot flash %2 & goto eof)
goto core
:fastboot-flashrun
fastboot flash "%order%"
if "%2"=="" (goto %local%) else (goto eof)



:affr
cd adb
set local=fastboot-flash-recovery
if not "%2"=="" (fastboot flash recovery %2 & goto eof)
goto core
:fastboot-flash-recoveryrun
fastboot "%order%"
if "%2"=="" (goto back) else (goto eof)



:aapush
:apush
:adb-push
cd adb
set local=adb-push
set localmsg=-Data will push to /sdcard/Download/.
goto core
:adb-pushrun
echo Starting adb...
adb start-server 
adb push "%order%" /sdcard/Download
if "%2"=="" (goto %local%) else (goto eof)



:aashell
:ashell
cd adb
mode con: cols=150 lines=50
set local=adb-shell
if not "%2"=="" (adb shell %2 & goto eof) else (adb shell)
if "%2"=="" (goto back) else (goto eof)


:aapull
:apull
:adb-pull
cd adb
set local=adb-pull
set localmsg=-No frontword "pull" if you want pull file. ^& echo -File will be pull to %userprofile%\download\.
goto core
:apullrun
if not "%order:~0,1%"=="/" (adb shell %order%) else (adb pull %order% %userprofile%\download\)
if "%2"=="" (goto %local%) else (goto eof)


:dl
cd dl
set local=dl
goto core
:dlrun
if "%order%"=="" (
if "%4"=="" (set order=%2 %3 & goto dlruns)
if "%5"=="" (set order=%2 %3=%4 & goto dlruns)
if "%6"=="" (set order=%2 %3=%4=%5 & goto dlruns)
)
:dlruns::::::::::::::::::::::::::::::::::::::::::
echo Current target: %order%
set eofmsg=-File will be place at %userprofile%\downloads\ ^& echo= if progress is success.
if "%order:~0,3%"=="mp3" (ytdl -x --audio-format mp3 %order:~3% & move *.mp3 %userprofile%\downloads\ & goto dlpassed)
if "%order:~0,3%"=="mp4" (ytdl --recode-video mp4 %order:~3% & move *.mp4 %userprofile%\downloads\ & goto dlpassed)
if "%order:~0,7%"=="nosplit" (aria2c.exe --dir=%userprofile%\downloads %order:~7% & goto dlpassed)
if "%order%"=="u" (ytdl --update & goto dlpassed)
:::::::::::::::::::::::::::::::::::::::::::::::::
aria2c.exe -s 10 -x 16 --dir=%userprofile%\downloads --conf-path=aria2.conf %order%
:dlpassed
if "%2"=="" (goto %local%) else (goto eof)


:counter
:count
set local=counter
set localmsg=Give new counter a name. Can't be "exit" or "back":
if not exist counter (mkdir counter)
set counter=0
goto core
:counterrun
set endsignal=
if "%order%"=="" (set order=counter)
set /p endsignal=---%counter%---
if "%endsignal%"=="end" (goto counterend)
set /a counter+=1
goto counterrun
set endsignal=
:counterend
echo Saving result...
echo %counter%>counter\%order%
set /p counter=<counter\%order%
echo Total count is %counter%
if "%2"=="" (goto back) else (goto eof)

:virtualboxresolution
:virtuslboxscreen
:boxscreen
::VBoxManage setextradata "Name" VBoxInternal2/EfiGraphicsResolution 1920x1080


:spa
:envpath
:envpaths
start C:\Windows\System32\SystemPropertiesAdvanced.exe
if "%1"=="" (goto back) else (goto eof)



:franxxdir
explorer.exe /n,/e,C:\_Addon\franxx
if "%1"=="" (goto back) else (goto eof)

::::::::::::::::::::::::::::::::::::::::::
:air
set local=air
goto core
:airrun
if "%order:~0,4%"=="uefi" (goto air-uefi)
set localmsg=Invaild command. & goto air
::---------------------------------------
:air-uefi
echo hh
cd D:/AirOS/edk2/
"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
if "%order:~5%"=="build" (
echo Doing edk2 build task...
set NASM_PREFIX="C:\Program Files\NASM\"
set BUILD=D:\AirOS\edk2\Build
edksetup.bat VS2015
set WINSDK81_PREFIX="c:\Program Files (x86)\Windows Kits\8.1\bin\"
build -a X64 -t VS2015 -p OvmfPkg\OvmfPkgX64.dsc -b DEBUG
goto airend
)
::----------------------------------------
:air-emu
"c:\Program Files\qemu\qemu-system-x86_64.exe" -m 5120 -smp 1 -bios %build%\OvmfX64\DEBUG_VS2015\FV\OVMF.fd -global e1000.romfile="" -machine q35 -serial mon:stdio -hda fat:rw:%build%\Ovmf64\DEBUG_VS2015\FV\hda-contents --net none
goto air
::----------------------------------------
:airend
if "%2"=="" (goto back) else (goto eof)

::::::::::::::::::::::::::::::::::::::::::

:eof
if not "%eofmsg%"=="" (echo %eofmsg%)
set eofmsg=
echo.
timeout 1 > nul