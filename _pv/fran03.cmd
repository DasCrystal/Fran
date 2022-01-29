@echo off
set order= & set local= & set localmsg=
set ver=0.3
if exist Franxx (cd Franxx)
if not "%1"=="" (goto %1) else (if "%0"=="franxx.cmd" (start fran.exe))

set local=core
goto core
:back
if not exist franxxcmdlist (cd ..)
if "%local:~0,3%"=="adb" (taskkill -f -im adb.exe)
if "%order%"=="exit" (goto eof)
set local=core
set order=
::::::::::::::::::::::::::
:core
echo.
echo Franxx Utils %ver% - %local%
echo -----------------------------
if not "%localmsg%"=="" (echo %localmsg%)
if "%2"=="" (set /p order=PlantationShell^>)
set localmsg=
if "%order%"=="back" (goto back)
if "%order%"=="exit" (if "%eofmsg%"=="" (set eofmsg=Have a nice day. Take care. & goto back) else (goto back))
if "%local%"=="core" (findstr %order% franxxcmdlist > nul && goto %order%
%order% & goto core) else (goto %local%run)
::echo %order% command is not exist here. & timeout 1 > nul
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
if "%2"=="" (pause & goto %local%) else (goto eof)

:aad
cd adb
set local=adb-devices
adb start-server
adb devices
pause
if "%1"=="" (goto back) else (goto eof)



:fastboot
:af
cd adb
set local=fastboot
if not "%2"=="" (fastboot %2 & pause & goto eof)
goto core
:fastbootrun
fastboot "%order%"
if "%2"=="" (pause & goto %local%) else (goto eof)



:aff
cd adb
set local=fastboot-flash
if not "%2"=="" (fastboot flash %2 & pause & goto eof)
goto core
:fastboot-flashrun
fastboot flash "%order%"
if "%2"=="" (pause & goto %local%) else (goto eof)



:affr
cd adb
set local=fastboot-flash-recovery
if not "%2"=="" (fastboot flash recovery %2 & pause & goto eof)
goto core
:fastboot-flash-recoveryrun
fastboot "%order%"
if "%2"=="" (pause & goto back) else (goto eof)



:aapush
:apush
cd adb
set local=adb-push
set localmsg=-Data will push to /sdcard/Download/.
goto core
:adb-pushrun
echo Starting adb...
adb start-server 
adb push "%order%" /sdcard/Download
if "%2"=="" (pause & goto %local%) else (goto eof)



:aashell
:ashell
cd adb
mode con: cols=150 lines=50
set local=adb-shell
if not "%2"=="" (adb shell %2 & pause & goto eof) else (adb shell)
if "%2"=="" (pause & goto back) else (goto eof)


:aapull
:apull
cd adb
set local=apull
set localmsg=-No frontword "pull" if you want pull file. ^& echo -File will be pull to %userprofile%\download\.
goto core
:apullrun
if not "%order:~0,1%"=="/" (adb shell %order%) else (adb pull %order% %userprofile%\download\)
if "%2"=="" (pause & goto %local%) else (goto eof)


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
if "%2"=="" (pause & goto %local%) else (goto eof)


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
if "%2"=="" (pause & goto back) else (goto eof)

:virtualboxresolution
:virtuslboxscreen
:boxscreen
::VBoxManage setextradata "Name" VBoxInternal2/EfiGraphicsResolution 1920x1080



:eof
if not "%eofmsg%"=="" (echo %eofmsg%)
set eofmsg=
echo.
timeout 1 > nul
title %windir%\system32\cmd.exe