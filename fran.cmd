::DocEncode=Big5(cp950)
::參數格式:fran.cmd <function-name-to-call> <ArgumentForFunction>
@echo off
setlocal enabledelayedexpansion

:init
set ccd=%cd% & cd /d %~dp0
set ver=2.0
set outdir=%userprofile%\downloads
set mclauncher="C:\Program Files (x86)\Minecraft Launcher\MinecraftLauncher.exe"

if exist private.cmd (
    set msg=- 自訂指令集已啟用。
)

set func=%1& set order=%2 %3 %4 %5 %6 %7 %8 %9

::::::::::::::::::::::::::::::::::::::

:core
echo.
echo=  Fran Utils %ver% %msg% & set msg=

if "%func%"=="" (
    start %windir%\System32\cmd.exe
    exit
) else (
    echo=  ^> %func% %order%
    echo.
    goto check
)

:check
if exist private.cmd (
    call private.cmd
)
findstr /x :%func% %~dpnx0 > nul
if %errorlevel%==0 (
    goto %func%
) else (
    set msg="%func%"不存在於Fran的指令集中。
    set timeout=3
    goto eof
)

::功能集開頭::::::::::::::::::::::::::::::

:adb
:adb-dev
:adb-kill
set class=adb
echo Starting adb...
if "%func%"=="%class%-kill" (
    bin\adb\adb.exe kill-server
    set msg=adb server killed.
    set timeout=-1& goto eof
)
bin\adb\adb.exe start-server
if "%func%"=="%class%-dev" (
    bin\adb\adb.exe devices
) else (
    bin\adb\adb.exe %order%
)
set timeout=-1& goto eof


:fastboot
:fastboot-dev
:fastboot-flashre
set class=fastboot
if "%func%"=="%class%-dev" (
    bin\adb\fastboot.exe device
) else if "%func%"=="%class%-flashre" (
    bin\adb\fastboot.exe flash recovery %order%
) else (
    bin\adb\fastboot.exe %order%
)
set timeout=-1& goto eof


:self
:self-dir
:self-edit
set class=self
if "%func%"=="%class%-dir" (
    echo 這個工具的根目錄。 & start explorer.exe /n,/e,%~dp0
    
) else if "%func%"=="%class%-edit" (
    echo 用vsCode編輯自己。 & cmd /c start "vsCode" code %~dpnx0
) else (
    set msg=給%class%的引數無效。
)
set timeout=2& goto eof


:mc
:mc-mod
:mc-mod-init
set class=mc
set order=%2
if "%func%"=="%class%" (
    start "minecraft" %mclauncher%
    set msg=已啟動 Minecraft Launcher。
)
@REM ) else if "%func%"=="%class%-mod-init" (
@REM     cd /d %appdata%\.minecraft\mods
@REM     if not exist cv (echo 0.0.0>cv)
@REM     dir
@REM     echo 初始化完成。
@REM ) else if "%func%"=="%class%-mod" (
@REM     cd /d %appdata%\.minecraft\mods
@REM     set /p from=<cv
@REM     if "%from%"=="%order%" (
@REM         set msg=現在已經在%order%了喔。
@REM         goto eof
@REM     )
@REM     move *.jar %from%
@REM     cd %order%
@REM     move *.jar ..
@REM     cd ..
@REM     echo %order%>cv
@REM     cd /d %~dp0
@REM )
set timeout=2& goto eof


:dl
:dl-mp3
:dl-mp4
:dl-origin
:dl-youtube-dl-update
set class=dl
if not "%3"=="" (
    set order=%2=%3
) else (
    set order=%2
)
if "%func%"=="%class%-mp3" (
    echo Target: %order%
    bin\dl\youtube-dl.exe -x --audio-format mp3 "%order%"
    move *.mp3 %outdir%

) else if "%func%"=="%class%-mp4" (
    echo Target: %order%
    bin\dl\youtube-dl.exe --recode-video mp4 "%order%"
    move *.mp4 %outdir%

) else if "%func%"=="%class%-origin" (
    echo Target: %order%
    bin\dl\youtube-dl.exe %order%

) else if "%func%"=="%class%-youtube-dl-update" (
    bin\dl\youtube-dl.exe --update

) else (
    echo 現在啟動aria2c的控制台。
    cd /d bin\dl
    index.html
    if not exist aria2.session (
        echo >aria2.session
    )
    aria2c.exe ^
        --enable-rpc=true^
        --rpc-listen-all=true^
        --rpc-allow-origin-all=true^
        --dir=%userprofile%\downloads^
        --input-file=aria2.session^
        --save-session=aria2.session

    cd /d %~dp0
)
:dl.end
set timeout=-1& goto eof


:apair
set class=adb-pair
bin\adb\adb.exe pair %2
bin\adb\adb.exe connect %3
goto eof


:apush
::不支援非ASCII字元
set class=apush
echo Target:%order%
bin\adb\adb.exe push "%order%" /sdcard/Download
set timeout=-1& goto eof


:apull
set class=apull
echo 請稍候。
bin\adb\adb.exe pull /storage/emulated/0/Download/%order% %outdir%\
set timeout=-1& goto eofmsg


:ashell
mode con: cols=150 lines=50
set class=ashell
bin\adb\adb.exe shell
goto eof


:counter
set class=counter
if not exist counter (mkdir counter)
set counter=0
set endsignal=
if "%order%"=="" (
    set order=counter
) else (
    set order=%order%
)
:counterrun
set /p endsignal=---%counter%---
if "%endsignal%"=="end" (goto counterend)
set /a counter+=1
goto counterrun
set endsignal=
:counterend
echo Saving result...
echo %counter%>counter\%order%.txt
set /p counter=<counter\%order%.txt
echo Total count is %counter%
set timeout=-1& goto eof


:ct
:ct-panel
:ct-spa
:ct-po
set class=ct
if "%func%"=="%class%-panel" (
  control
  echo 控制台已啟動。
) else if "%func%"=="%class%-diskc" (
  cleanmgr /sageset:99
  cleanmgr /sagerun:99
  echo 進階磁碟清理已啟動。
) else if "%func%"=="%class%-spa" (
  start %windir%\System32\SystemPropertiesAdvanced.exe
  echo 進階系統設定已啟動.
) else if "%func%"=="%class%-po" (
  control powercfg.cpl
  echo 電源管理面板已啟動。
) else (
  set msg=無效的指令。
)
set timeout=2& goto eof


:ping
set class=ping
set msg=-Google server ip is 142.251.43.14
if not "%2"=="" (set order=%2 %3)
if "%func%"=="%class%-long" (
        echo.
        echo -Use [Ctrl] + [C] to stop.
        ping -t -l 1 google.com
) else if "%func%"=="%class%-short" (
        ping -n 1 %order%
        timeout 1 /nobreak > nul
) else (
        ping %order% )
set timeout=-1 & goto eof


:real
:real-anime
@REM :real-videox2
@REM :real-videox4
::RealESRGAN
set class=real
set input=%order%
set output=%outdir%\output-%random%.png
if exist %output% (
  echo Do you want OVERWRITE existed file ?
  set /p order=type "yes" if you want:
  if not "!order!"=="yes" (goto RealESRGANend) )
echo Input:%input%[L0461]
echo Output:%output%[L0462]
if "%func%"=="%class%-anime" (
  echo Anime opmized engine selected.
  set order= -j 5:5:5 -i %input% -o %output% -n realesrgan-x4plus-anime
) else if "%func%"=="%class%-videox2" (
  echo Videox2 specific engine selected.
  set order= -j 5:5:5 -i %input% -o %output% -n RealESRGANv2-animevideo-xsx2
) else if "%func%"=="%class%-videox4" (
  echo Videox4 specific engine selected.
  set order= -j 5:5:5 -i %input% -o %output% -n RealESRGANv2-animevideo-xsx4
) else (
  set order= -j 5:5:5 -i %input% -o %output% )

bin\RealESRGAN\realesrgan-ncnn-vulkan %order%

if errorlevel 0 (
  echo Compelected.
  echo=
  echo File will be placed at %output%
  echo= )
:RealESRGAN.end
set input=& set output=
set timeout=10 & goto eof

::功能集結尾::::::::::::::::::::::::::::::

:eof
if not "%msg%"=="" (
    echo %msg% & set msg=
)
@REM echo ------------------End
echo.
if not "%timeout%"=="" (

    if "%timeout%"=="-1" (
        echo 按下任意鍵退出。
    ) else (
        echo 將在%timeout%秒後退出。
    )
    timeout %timeout% > nul
    
)
echo.
cd %ccd%
endlocal
goto:eof

:help
echo Fran Utils %ver%
echo.
echo 用法：fran [功能] <指令>
echo.
echo 功能
echo   指令
echo adb
echo   adb-dev
echo   adb-kill
echo fastboot
echo   fastboot-dev
echo self
echo   self-dir
echo   self-edit
echo mc
echo   mc-mod
echo   mc-mod-init
echo dl
echo   dl-mp3
echo   dl-mp4
echo   dl-origin
echo   dl-youtube-dl-update
echo apair
echo apush
echo apull
echo ashell
echo counter
echo ct
echo   ct-panel
echo   ct-spa
echo   ct-po
echo ping
echo real
echo   real-anime