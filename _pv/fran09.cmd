@echo off
setlocal enabledelayedexpansion

set ver=0.9.1
set order= & set local= & set localmsg=
set outdir=%userprofile%\downloads
::Lang
set INVAILD_COMMAND=Command is invaild.

if not "%1"=="" (goto %1)
:back
set local=core
:core
echo=
echo Fran Utils %ver% - %local%
echo -----------------------------
if not "%msg%"=="" (echo %msg%) & set msg=
if "%2"=="" (set /p order=PlantationShell^>)

::以下指令檢測::

if "%order%"=="about"     ( goto about )
if "%order%"=="help"      ( goto help  )
if "%order%"=="exit"      ( goto eof )
if "%order%"=="back"      ( goto back )
if not "%local%"=="core"  ( goto %local%run )

if not "%order%"=="core" (
  if not "%order%"=="eof" (
    if not "%order~-3%"=="run" (
    findstr :%order% %~dpnx0 > nul && goto %order%
    )
  )
)
set msg=%INVAILD_COMMAND% & goto core

::以下指令集::::::::::::::::::::::::::::::

:adb
:aa
set local=adb
goto core
:adbrun
echo Starting adb...
"%~dp0\adb\adb.exe" start-server
"%~dp0\adb\adb.exe" "%order%"
if "%2"=="" (goto %local%) else (pause & goto eof)


:aad
:adb-devices
cd adb
"%~dp0\adb\adb.exe" start-server
"%~dp0\adb\adb.exe" devices
if "%2"=="" (goto %local%) else (pause & goto eof)


:fastboot
:af
set local=fastboot
goto core
:fastbootrun
"%~dp0\adb\fastboot.exe" "%order%"
if "%2"=="" (goto %local%) else (pause & goto eof)


:afd
:fastboot-devices
set local=fastboot-devices
"%~dp0\adb\fastboot.exe" devices
if "%2"=="" (goto back) else (pause & goto eof)


:aff
:fastboot-flash
set local=fastboot-flash
goto core
:fastboot-flashrun
"%~dp0\adb\fastboot.exe" flash "%order%"
if "%2"=="" (goto %local%) else (pause & goto eof)


:affr
:fastboot-flash-recovery
set local=fastboot-flash-recovery
goto core
:fastboot-flash-recoveryrun
"%~dp0\adb\fastboot.exe" flash recovery "%order%"
if "%2"=="" (goto affr) else (pause & goto eof)


:aapair
:apair
:adb-pair
set local=adb-pair
set msg=-Pair device using ip and port.
goto core
:adb-pairrun
"%~dp0\adb\adb.exe" pair %order%
"%~dp0\adb\adb.exe" connect %order%
if "%2"=="" (goto %local%) else (pause & goto eof)


:aapush
:apush
:adb-push
set local=adb-push
set msg=-Data will push to /sdcard/Download/.
::If you want use this in wireless, please pair first.
goto core
:adb-pushrun
echo Starting adb...
"%~dp0\adb\adb.exe" start-server
"%~dp0\adb\adb.exe" push "%order%" /sdcard/Download
if "%2"=="" (goto %local%) else (pause & goto eof)


:aapull
:apull
:adb-pull
set local=adb-pull
set msg=-File will be pull to %outdir%. ^& echo -Only support files at download folder.
goto core
:adb-pullrun
echo Please wait.
"%~dp0\adb\adb.exe"  pull /storage/emulated/0/Download/%order% %outdir%\
if "%2"=="" (goto %local%) else (pause & goto eof)


:aashell
:ashell
:adb-shell
mode con: cols=150 lines=50
set local=adb-shell
if not "%2"=="" ("%~dp0\adb\adb.exe" shell %2 & goto eof) else ("%~dp0\adb\adb.exe" shell)
if "%2"=="" (goto core) else (goto eof)


:dl
set local=dl
goto core
:dlrun
if not "%2"=="" (
if "%6"=="" (set order=%2 %3=%4=%5)
if "%5"=="" (set order=%2 %3=%4)
if "%4"=="" (set order=%2 %3)
)
echo Current target: %order%
set msg=-File will be place at %outdir%\ ^& echo= if progress is success.
if "%order:~0,3%"=="mp3"     ("%~dp0\dl\ytdl.exe" -x --audio-format mp3 %order:~3% & move *.mp3 %outdir%\ & goto dlpassed)
if "%order:~0,3%"=="mp4"     ("%~dp0\dl\ytdl.exe" --recode-video mp4 %order:~3% & move *.mp4 %outdir%\ & goto dlpassed)
if "%order:~0,5%"=="nocov"   ("%~dp0\dl\ytdl.exe" %order:~5% & goto dlpassed)
if "%order:~0,7%"=="nosplit" ("%~dp0\dl\aria2c.exe" --dir=%outdir% %order:~7% & goto dlpassed)
if "%order:~0,5%"=="ytdlu"   ("%~dp0\dl\ytdl.exe" --update & goto dlpassed)
:::::::::::::::::::::::::::::::::::::::::::::::::
:dlpassed
pause
if "%2"=="" (goto %local%) else (goto eof)


:counter
:count
set local=counter
set msg=Give new counter a name. Can't be "exit" or "back":
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
echo %counter%>%~dp0\counter\%order%.txt
set /p counter=<%~dp0\counter\%order%.txt
echo Total count is %counter%
if "%2"=="" (goto %local%) else (pause & goto eof)


:ctp
:controlpanel
set local=controlpanel
goto core
:controlpanelrun
if "%order:~0,3%"=="ctp" (
  explorer.exe /n,/e,::{26EE0668-A00A-44D7-9371-BEB064C98683}
  echo ControlPanel launched.
) else if "%order:~0,5%"=="diskc" (
  cleanmgr /sageset:99
  cleanmgr /sagerun:99
  echo AdvancedDiskCleaner launched.
) else if "%order:~0,3%"=="spa" (
  start C:\Windows\System32\SystemPropertiesAdvanced.exe
  echo SystemPropertiesAdvanced launched.
) else if "%order:~0,2%"=="po" (
  explorer.exe /n,/e,::{26EE0668-A00A-44D7-9371-BEB064C98683}\2\::{025A5937-A6BE-4686-A844-36FE4BEC8B6D}
) else (
  echo Invaild command. )
if "%2"=="" (goto %local%) else (goto eof)


:po
:poweroption
:power-option
set local=power-option
goto core
:power-optionrun
::下面那行在某些模塊中極為重要
if not "%2"=="" (set order=%2 %3)
::上面那行
if "%order:~0,4%"=="list" (powercfg /list & pause > nul & goto power-optionend)
::顯示極速模式:powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
::在下方加入其他的電源計畫
if "%order:~0,6%"=="switch" (
    if "%order:~7%"=="normal" (powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e & echo Switched to "normal".  & goto power-optionend)
    if "%order:~7%"=="extreme" (powercfg -setactive 763aa365-a15b-458b-b1f7-bb7b9e1f758b & echo Switched to "extreme".  & goto power-optionend)
    set localmsg=Ordered plan not exist. & goto power-optionends )

if "%order:~0,3%"=="del" (
    powercfg /delete %order:~4% & goto power-optionend)

set localmsg=Invaild command.
:power-optionend
if "%2"=="" (goto po) else (pause & goto eof)


:self
if not "%2"=="" (set order=%2)
set local=self
set localmsg=Self mangement.
goto core
:selfrun
if "%order%"=="dir" (echo Codes' home. & start explorer.exe /n,/e,%~dp0)
if "%order%"=="edit" (echo Edit self using vsCode. & start "vsCode" code %~dp0\fran.cmd)
if "%2"=="" (goto %local%) else (goto eof)


:docto
set local=docto
set localmsg=Docment covent, doc to to pdf.
goto core
:doctorun
echo Task is running...
"%~dp0\docto\docto.exe" -WD -F %order% -T wdFormatPDF -O %outdir%\
if "%2"=="" (goto %local%) else (pause & goto eof)


@REM :videoto
@REM :vidto
@REM set local=videoto

@REM goto core
@REM :videotorun
@REM ffmpeg -i "%2" -vn "%outdir%\%3"
@REM if "%2"=="" (goto %local%) else (goto eof)

::在ping裡加入一點log指令好了

:ping
set local=ping
set msg=-Google server ip is 142.251.43.14
goto core
:pingrun
if not "%2"=="" (set order=%2 %3)
if "%order:~0,4%"=="long" (
        echo.
        echo -Use [Ctrl] + [C] to stop.
        ping -t -l 1 google.com
    ) else if "%order:~0,5%"=="short" (
        ping -n 1 %order:~6%
        timeout 1 /nobreak > nul
    ) else (
        ping %order% )
if "%2"=="" (goto %local%) else (pause & goto eof)


:niceheader
:nh
::目前可以使用gcc & g++
::下面字碼頁(UTF-8)
chcp 65001 > nul
echo=
cd /d %ccd%
set target=%3
if not "%5"=="" (set arg=%4=%5) else (set arg=%4)
::關於為什麼要用DelayedExpansion及配套的"!"，請見:
::https://stackoverflow.com/questions/9102422/windows-batch-set-inside-if-not-working/9102569
set /p = 正在編譯...<nul
if "%2"=="cpp" (
  set target=%target:~0,-4%
  g++ !target!.cpp -o !target! %arg% || goto:eof
  echo 完成。
) else if "%2"=="c" (
  set target=%target:~0,-2%
  gcc !target!.c -o !target! %arg% || goto:eof
  echo 完成。
) else (
  echo 失敗:指定了無效或不可用的語言。& goto:eof )
echo --------------------正在執行
"%target%.exe"
echo=
echo ----------回傳值為%errorlevel%,執行結束
echo=
goto:eof ::注意不要寫錯，這裡要直跳尾部，真正的尾部。


:RealESRGAN
:re
set local=RealESRGAN
set msg=-Please use this function by outcall method.
goto core
:RealESRGANrun
set input=%2
set output=%outdir%\%~n2_out.png
if exist %output% (
  echo Do you want OVERWRITE existed file ?
  set /p order=type "yes" if you want:
  if not "!order!"=="yes" (goto RealESRGANend) )
echo Input:%input%[L0461]
echo Output:%output%[L0462]
if "%3"=="anime" (
  echo Anime opmized engine selected.
  set order= -j 5:5:5 -i %input% -o %output% -n realesrgan-x4plus-anime
) else if "%3"=="" (
  set order= -j 5:5:5 -i %input% -o %output%
) else (
  set order= -j 5:5:5 -i %input% -o %output% -n %3 )

"%~dp0\RealESRGAN\realesrgan-ncnn-vulkan.exe" %order%

if errorlevel 0 (
  echo Compelected.
  echo=
  echo File will be placed at %outdir%
  echo= )

:RealESRGANend
set input=
if "%2"=="" (goto %local%) else (pause & goto eof)

::指令集結尾::::::::::::::::::::::::::::::



:eof
echo=