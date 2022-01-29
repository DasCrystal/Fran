 ::DocEncode=Big5(cp950)

@echo off

::DebugTool
::logcount�O����N��O�H�O�����ƪ��N���I
::�V�ª������Ʀr�V�j
::�����ҲաGback,core,check,eof
if not "%1"=="" (set order=_%1)
set logfile=%~dp0_log\log%order%.txt
set MultiLog=
if not "%MultiLog%"=="" (
    if exist %logfile:~0,-4%*10.txt (
        set logcount=
    ) else if exist %logfile:~0,-4%*9.txt (
        set logcount=10
    ) else if exist %logfile:~0,-4%*8.txt (
        set logcount=9
    ) else if exist %logfile:~0,-4%*7.txt (
        set logcount=8
    ) else if exist %logfile:~0,-4%*6.txt (
        set logcount=7
    ) else if exist %logfile:~0,-4%*5.txt (
        set logcount=6
    ) else if exist %logfile:~0,-4%*4.txt (
        set logcount=5
    ) else if exist %logfile:~0,-4%*3.txt (
        set logcount=4
    ) else if exist %logfile:~0,-4%*2.txt (
        set logcount=3
    ) else if exist %logfile:~0,-4%*1.txt (
        set logcount=2
    ) else if exist %logfile:~0,-4%*.txt (
        set logcount=1
    ) else (
        set logcount=
    )
)

echo [INFO]�����u��G�����ɶ� "%date% %time%"�C>> %logfile%
echo [INFO]�����u��G�O���ɬ�%logfile%�C>> %logfile%
if "%MultiLog%"=="" (
    echo [INFO]�����u��G�h���O���ɤw�����C>> %logfile%
    if exist %logfile% (del %logfile%)
) else (
    echo [INFO]�����u��G�h���O���ɤw�}�ҡC>> %logfile%
    if exist %logfile% (ren %logfile% log_%1%logcount%.txt)
)

echo [INFO]�����u��G�ǤJ�����O��"%1 %2 %3 %4 %5 %6 %7 %8 %9">> %logfile%
if not "%fd%"=="" (
    echo [INFO]�����u��G�ԲӰ���Ҧ��w�}�ҡC>> %logfile%
    echo on & set fd=)

setlocal enabledelayedexpansion
set ver=1.0
set order=& set local=& set localmsg=& set msg=& set or=
set outdir=%userprofile%\downloads

if "%2"=="" (
    set order=%1
) else if "%3"=="" (
    set order=%2
) else if "%4"=="" (
    set order=%2 %3
) else if "%5"=="" (
    set order=%2 %3 %4
) else if "%6"=="" (
    set order=%2 %3 %4 %5
) else if "%7"=="" (
    set order=%2 %3 %4 %5 %6
) else if "%8"=="" (
    set order=%2 %3 %4 %5 %6 %7
) else if "%9"=="" (
    set order=%2 %3 %4 %5 %6 %7 %8
) else if not "%9"=="" (
    set order=%2 %3 %4 %5 %6 %7 %8 %9
)

if not "%order%"=="" (
    goto check
)

::�֤߼Ҳ�:::::::::::::::::::

:back
set local=& set order=


:core
echo [INFO]����Gcore�ҲաC>> %logfile%
echo=
title Fran Utils %ver%
echo Fran Utils %ver%
echo --------------------------
if not "%msg%"=="" (echo %msg%) & set msg=
if "%2"=="" (
    if "%local%"=="" (
    echo [INFO]����ҲաGcore���D�ҲաC>> %logfile%
    set /p order=FU^>
    if "!order!"=="exit" (goto eof)
    goto check
    ) else (
    echo [INFO]����Gcore���l�ҲաC>> %logfile%
    set /p order=FU^>%local%^>
    if "!order!"=="back" (goto back)
    if "!order!"=="exit" (goto eof)
    goto %local%.run
    )
) else (
    echo [INFO]����G�ˬd�����A��������\��C>> %logfile%
    goto %local%.run
)

:check
echo [INFO]�ˬd�G"%order%"�C>> %logfile%
if "%order%"=="" (set msg=���O���s�b�C & goto back)
if "%local%"=="" (
    set or=
    if "%2"=="" (
        set order=%order: =-%
        findstr /x :%order% %~dpnx0 > nul && set  or=ok
    ) else (
        findstr /x :%1 %~dpnx0 > nul && set or=ok
    )
)
if "%or%"=="ok" (
    echo [INFO]�ˬd�G"%order%"�s�b�C>> %logfile%
    if "%1"=="" (
        goto %order%
    ) else (
        goto %1
    )
) else (
    echo [INFO]�ˬd�G"%order%"���s�b�C>> %logfile%
    set msg=���O���s�b�C
    if "%2"=="" (goto back) else (goto eof)
)

echo [ERRS]�Y��G�妸�ɥX�{�������~�A�й��խץ��i�઺���D��A�����楻�妸�ɡC>> %logfile%
goto eof

::���O���}�Y:::::::::::::::::::


:t
set local=t
goto core
:t.run
if "%order:~2%"=="L1" (
    :t-l1
    echo Hey what's u-serprofile.
    goto test.end )
echo OwO
:test.end
if "%2"=="" (goto back) else (goto eof)


:adb
set local=adb
goto core
:adb.run
echo Starting adb...
"%~dp0\adb\adb.exe" start-server
"%~dp0\adb\adb.exe" "%order%"
:adb.end
if "%2"=="" (goto %local%) else (goto eof)


:fastboot
:af
set local=fastboot
goto core
:fastboot.run
"%~dp0\adb\fastboot.exe" "%order%"
if "%2"=="" (goto %local%) else (pause & goto eof)


:timer
echo [INFO]����Gtimer�ҲաC>> %logfile%
set local=timer
set msg=�H�����p��,�̪�10�����C
goto core
:timer.run
set /a order=order * 60
:timer.loop
set /a m=order / 60
set /a s=order %% 60
if %m% LSS 10 (
    if %s% LSS 10 (
        echo - 0%m%:0%s% -
    ) else (
        echo - 0%m%:%s% -
    )
) else if %s% LSS 10 (
    if %m% LSS 10 (
        echo - 0%m%:0%s% -
    ) else (
        echo - %m%:0%s% -
    )
) else (
    echo - %m%:%s% -
)
timeout 1 /nobreak > nul 
set /a order-=1
if "%order%"=="0" (goto timer.end)
goto timer.loop
:timer.end
echo - �ɶ���� -
echo  & timeout 2 /nobreak > nul
echo  & timeout 2 /nobreak > nul
echo 
if "%2"=="" (goto %local%) else (goto eof)


:apair
:adb-pair
echo [INFO]����Gadb-pair�ҲաC>> %logfile%
set local=adb-pair
set msg=�HIP�PPort�i��t��C
goto core
:adb-pair.run
"%~dp0\adb\adb.exe" pair %order%
"%~dp0\adb\adb.exe" connect %order%
if "%2"=="" (goto %local%) else (goto eof)


:apush
:adb-push
echo [INFO]����Gadb-push�ҲաC>> %logfile%
set local=adb-push
set msg=-Data will push to /sdcard/Download/.
::If you want use this in wireless, please pair first.
goto core
:adb-push.run
echo Starting adb...
"%~dp0\adb\adb.exe" start-server
"%~dp0\adb\adb.exe" push "%order%" /sdcard/Download
if "%2"=="" (goto %local%) else (pause & goto eof)


:apull
:adb-pull
echo [INFO]����Gadb-pull�ҲաC>> %logfile%
set local=adb-pull
set msg=-�ɮ׷|��m�b%outdir%�C^& echo -�u�䴩�b�U���ɮק������ɮסC
goto core
:adb-pull.run
echo �еy��C
"%~dp0\adb\adb.exe"  pull /storage/emulated/0/Download/%order% %outdir%\
if "%2"=="" (goto %local%) else (goto eof)


:ashell
:adb-shell
echo [INFO]����Gadb-shell�ҲաC>> %logfile%
mode con: cols=150 lines=50
set local=adb-shell
if not "%2"=="" ("%~dp0\adb\adb.exe" shell %2 & goto eof) else ("%~dp0\adb\adb.exe" shell)
if "%2"=="" (goto core) else (goto eof)


:dl
echo [INFO]����Gdl�ҲաC>> %logfile%
set local=dl
goto core
:dl.run
echo Current target: %order%
set msg=-File will be place at %outdir%\ ^& echo= if progress is success.
if "%order:~0,3%"=="mp3"     ("%~dp0\dl\ytdl.exe" -x --audio-format mp3 %order:~3% & move *.mp3 %outdir%\ & goto dl.end)
if "%order:~0,3%"=="mp4"     ("%~dp0\dl\ytdl.exe" --recode-video mp4 %order:~3% & move *.mp4 %outdir%\ & goto dl.end)
if "%order:~0,5%"=="nocov"   ("%~dp0\dl\ytdl.exe" %order:~5% & goto dl.end)
if "%order:~0,5%"=="ytdlu"   ("%~dp0\dl\ytdl.exe" --update & goto dl.end)
"%~dp0\dl\aria2c.exe" --dir=%outdir% %order:~7%
:dl.end
if "%2"=="" (goto %local%) else (goto eof)


:counter
:count
echo [INFO]����Gcounter�ҲաC>> %logfile%
set local=counter
set msg=Give new counter a name. Can't be "exit" or "back":
if not exist counter (mkdir counter)
set counter=0
goto core
:counter.run
set endsignal=
if "%order%"=="" (set order=counter)
set /p endsignal=---%counter%---
if "%endsignal%"=="end" (goto counter.end)
set /a counter+=1
goto counter.run
:counter.end
echo Saving result...
echo %counter%>%~dp0\counter\%order%.txt
set /p counter=<%~dp0\counter\%order%.txt
echo Total count is %counter%
if "%2"=="" (goto %local%) else (goto eof)


:ctp
:control
echo [INFO]����Gcontrol�ҲաC>> %logfile%
set local=control
goto core
:control.run
if "%order%"=="ctp" (
  control
  echo ����x�w�ҰʡC
) else if "%order%"=="diskc" (
  cleanmgr /sageset:99
  cleanmgr /sagerun:99
  echo �i���ϺвM�z�w�ҰʡC
) else if "%order%"=="spa" (
  start C:\Windows\System32\SystemPropertiesAdvanced.exe
  echo SystemPropertiesAdvanced launched.
) else if "%order%"=="po" (
  control powercfg.cpl
  echo �q���޲z���O�w�ҰʡC
) else (
  echo �L�Ī����O�C )
if "%2"=="" (goto %local%) else (goto eof)


:self
echo [INFO]����Gself�ҲաC> %logfile%
set local=self
set localmsg=Self mangement.
goto core
:self.run
if "%order%"=="dir" (echo �o�Ӥu�㪺�ڥؿ��C & start explorer.exe /n,/e,%~dp0)
if "%order%"=="edit" (echo ��vsCode�s��ۤv�C & start "vsCode" code %~dp0\fran.cmd)
if "%2"=="" (goto %local%) else (goto eof)


:ping
echo [INFO]����Gping�ҲաC> %logfile%
set local=ping
set msg=-Google server ip is 142.251.43.14
goto core
:ping.run
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


:RealESRGAN
:re
echo [INFO]����GRealESRGAN�ҲաC> %logfile%
set local=RealESRGAN
set msg=-Please use this function by outcall method.
goto core
:RealESRGAN.run
set input=%order%
set output=%outdir%\output-%random%.png
if exist %output% (
  echo Do you want OVERWRITE existed file ?
  set /p order=type "yes" if you want:
  if not "!order!"=="yes" (goto RealESRGANend) )
echo Input:%input%[L0461]
echo Output:%output%[L0462]
if "%input:~-5%"=="anime" (
  echo Anime opmized engine selected.
  set order= -j 5:5:5 -i %input:~0,-5% -o %output% -n realesrgan-x4plus-anime
) else (
  set order= -j 5:5:5 -i %input% -o %output% )
"%~dp0\RealESRGAN\realesrgan-ncnn-vulkan.exe" %order%
if errorlevel 0 (
  echo Compelected.
  echo=
  echo File will be placed at %outdir%
  echo= )
:RealESRGAN.end
set input=& set output=
if "%2"=="" (goto %local%) else (goto eof)
::���O������:::::::::::::::::::

:eof
echo=
if not "%msg%"=="" (echo %msg%) & set msg=
echo=
if "%local%"=="adb" (
    taskkill -f -im adb.exe > nul
) else if "%local%"=="ctp" (
    timeout 1 /nobreak > nul
) else if not "%2"=="" (
        pause
)

echo [INFO]�妸�ɰ��浲���C>> %logfile%
