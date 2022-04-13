::DocEncode=Big5(cp950)
::�ѼƮ榡:fran.cmd <function-name-to-call> <ArgumentForFunction>
@echo off
setlocal enabledelayedexpansion

:init
set ccd=%cd% & cd /d %~dp0
set ver=2.0
set outdir=%userprofile%\downloads
set mclauncher="C:\Program Files (x86)\Minecraft Launcher\MinecraftLauncher.exe"

if exist private.cmd (
    set msg=- �ۭq���O���w�ҥΡC
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
    set msg="%func%"���s�b��Fran�����O�����C
    set timeout=3
    goto eof
)

::�\�ධ�}�Y::::::::::::::::::::::::::::::

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
    echo �o�Ӥu�㪺�ڥؿ��C & start explorer.exe /n,/e,%~dp0
    
) else if "%func%"=="%class%-edit" (
    echo ��vsCode�s��ۤv�C & cmd /c start "vsCode" code %~dpnx0
) else (
    set msg=��%class%���޼ƵL�ġC
)
set timeout=2& goto eof


:mc
:mc-mod
:mc-mod-init
set class=mc
set order=%2
if "%func%"=="%class%" (
    start "minecraft" %mclauncher%
    set msg=�w�Ұ� Minecraft Launcher�C
)
@REM ) else if "%func%"=="%class%-mod-init" (
@REM     cd /d %appdata%\.minecraft\mods
@REM     if not exist cv (echo 0.0.0>cv)
@REM     dir
@REM     echo ��l�Ƨ����C
@REM ) else if "%func%"=="%class%-mod" (
@REM     cd /d %appdata%\.minecraft\mods
@REM     set /p from=<cv
@REM     if "%from%"=="%order%" (
@REM         set msg=�{�b�w�g�b%order%�F��C
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
    echo �{�b�Ұ�aria2c������x�C
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
::���䴩�DASCII�r��
set class=apush
echo Target:%order%
bin\adb\adb.exe push "%order%" /sdcard/Download
set timeout=-1& goto eof


:apull
set class=apull
echo �еy�ԡC
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
  echo ����x�w�ҰʡC
) else if "%func%"=="%class%-diskc" (
  cleanmgr /sageset:99
  cleanmgr /sagerun:99
  echo �i���ϺвM�z�w�ҰʡC
) else if "%func%"=="%class%-spa" (
  start %windir%\System32\SystemPropertiesAdvanced.exe
  echo �i���t�γ]�w�w�Ұ�.
) else if "%func%"=="%class%-po" (
  control powercfg.cpl
  echo �q���޲z���O�w�ҰʡC
) else (
  set msg=�L�Ī����O�C
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

::�\�ධ����::::::::::::::::::::::::::::::

:eof
if not "%msg%"=="" (
    echo %msg% & set msg=
)
@REM echo ------------------End
echo.
if not "%timeout%"=="" (

    if "%timeout%"=="-1" (
        echo ���U���N��h�X�C
    ) else (
        echo �N�b%timeout%���h�X�C
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
echo �Ϊk�Gfran [�\��] <���O>
echo.
echo �\��
echo   ���O
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