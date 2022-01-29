@echo off
cd C:\_Addon\Franxx
set order=
set arg=
if not "%1"=="" (goto %1)
title Franxx
:init
set ver=0.1
mode con: cols=75 lines=25
::::::::::::::::::::::::::
:back
set local=main
:main
if "%1"=="" (cls)
set order="none"
echo Franxx Utils %ver% - %local%
echo ---------------------------------------------------------------------------
if not "%localmsg%"=="" (echo %localmsg%)
if "%2"=="" (
set /p order=%~dp0%^>
) else (set order=%2 ^& goto eof)

set localmsg=
if "%order%"=="back" (goto back)
if "%order%"=="exit" (if "%eofmsg%"=="" (set eofmsg=Have a nice day. Take care. & goto eof) else (goto eof))
if "%local%"=="main" (
::Format:if "%order%"=="" goto pass
if "%order%"=="aa" goto pass
if "%order%"=="adb" goto pass
if "%order%"=="af" goto pass
if "%order%"=="fastboot" goto pass
if "%order%"=="aff" goto pass
if "%order%"=="affr" goto pass
if "%order%"=="apush" goto pass
if "%order%"=="aapush" goto pass
if "%order%"=="ashell" goto pass
if "%order%"=="aashell" goto pass
if "%order%"=="apull" goto pass
if "%order%"=="aapull" goto pass
if "%order%"=="aad" goto pass
if "%order%"=="dl" goto pass
echo "%order%" command is not exist here. & pause & goto main
)
goto %local%run


:pass
goto %order%
::::::::::::
:adb
:aa
set local=adb
echo Starting adb...
adb start-server
:a
goto main
:adbrun
adb %order%
pause
goto a


:aad
adb devices
pause
if "%1"=="" (goto main) else (goto eof)

:fastboot
:af
set local=fastboot
if not "%2"=="" (fastboot %2 & pause & goto eof)
goto main
:fastbootrun
fastboot "%order%"
pause
goto af


:aff
set local=fastboot-flash
if not "%2"=="" (fastboot flash %2 & pause & goto eof)
goto main
:fastboot-flashrun
fastboot flash "%order%"
pause
goto aff


:affr
set local=fastboot-flash-recovery
if not "%2"=="" (fastboot flash recovery %2 & pause & goto eof)
goto main
:fastboot-flash-recoveryrun
fastboot "%order%"
pause
goto affr


:aapush
:apush
set local=adb-push
set localmsg=-Data will push to /sdcard/Download/.
goto main
:adb-pushrun
echo Starting adb...
adb start-server 
adb push "%order%" /sdcard/Download
pause
goto apush


:aashell
:ashell
mode con: cols=150 lines=50
set local=adb-shell
if not "%2"=="" (adb shell %2 & pause & goto eof) else (adb shell)
pause
goto back


:aapull
:apull
set local=apull
set localmsg=-No frontword "pull" if you want pull file. ^& echo -File will be pull to %userprofile%\download\.
goto main
:apullrun
if not "%order:~0,1%"=="/" (adb shell %order%) else (adb pull %order% %userprofile%\download\)
pause
if not "%2"=="" (goto eof) 
goto apull


:dl
set local=dl
::franxx dl%1 https://www.bilibili.com/video/BV1T5411E7gF %2
if not "%1"=="" (
set order="%3"
set eofmsg=-File will be place at %userprofile%\downloads\ ^& echo= if progress is success.
if "%2"=="mp3" (ytdl -x --audio-format mp3 %order% & move *.mp3 %userprofile%\downloads\ & goto eof)
if "%2"=="mp4" (ytdl --recode-video mp4 %order% & move *.mp4 %userprofile%\downloads\ & goto eof)
if "%2"=="mkv" (ytdl %order% & move *.mkv %userprofile%\downloads\ & goto eof)
if "%2"=="u" (ytdl --update & pause & goto eof)
set order="%2=%3"
aria2c.exe -s 10 -x 16 --dir=%userprofile%\downloads --conf-path=aria2.conf %order% & goto eof)
goto main
:dlrun
if "%order:~0,3%"=="mp3" (ytdl -x --audio-format mp3 %order:~3% & move *.mp3 %userprofile%\downloads\ & pause & goto dl)
if "%order:~0,3%"=="mp4" (ytdl --recode-video mp4 %order:~3% & move *.mp4 %userprofile%\downloads\ & pause % goto dl)
if "%order:~0,3%"=="mkv" (ytdl %order:~3% & move *.mkv %userprofile%\downloads\ & pause & goto dl)
aria2c.exe -s 10 -x 16 --dir=%userprofile%\downloads --conf-path=aria2.conf "%order%" & pause & goto dl



:eof
if not "%eofmsg%"=="" (echo %eofmsg%)
set eofmsg=
echo.
timeout 3 > nul
title %windir%\system32\cmd.exe