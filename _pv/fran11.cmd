::DocEncode=Big5(cp950)
@echo off
goto init
:reinit
set msg=���b���s��l��...
:init
set ccd=%cd% & cd /d %~dp0
set ver=1.1
set local=& set or=
@REM set ccd=%cd% & cd /d %~dp0%
::%~dp0%�᭱�o��"%"�����[�A�_�h����L�ؿ����s���v���|�X���D
::�]�w�u��PATH::
set path=%path%;%~dp0\bin;^
%~dp0\bin\adb;^
%~dp0\bin\dl;^
%~dp0\bin\docto;^
%~dp0\bin\ffmpeg;^
%~dp0\bin\RealESRGAN;^
%~dp0\bin\trans

:::::::::::::::
set outdir=%userprofile%\downloads
set logfile=%~dp0_log\log%order%.txt
if "%order%"=="reinit" (set msg=%msg%�����C)



::DebugTool
::�����ҲաGback,core,check,eof
if exist %logfile% (del %logfile%)
echo [INFO]�����u��G�h���O���ɥ\��w�Q��ΡC>> %logfile%
echo [INFO]�����u��G�����ɶ� "%date% %time%"�C>> %logfile%
echo [INFO]�����u��G�O���ɬ�"%logfile%"�C>> %logfile%
echo [INFO]�����u��G�ǤJ���޼Ƭ�"%1,%2,%3,%4,%5,%6,%7,%8,%9">> %logfile%


if "%1"=="dbg" (
    if "%2"=="SW" (
        if "%fd%"=="F" (
            set fd=T
            set msg=�������A������True�C
        ) else (
            set fd=F
            set msg=�������A������False�C
        )
    ) else if "%2"=="T" (
        set fd=T
        set msg=�������A������True�C
    ) else if "%2"=="F" (
        set fd=F
        set msg=�������A������False�C
    ) else (
        echo �o�ӫ��O�u��SW,T,F�ﶵ�i�ΡC
    )
    
    set timeout=0& goto eof
)
if "%fd%"=="T" (
    echo [INFO]�����u��G�ԲӰ���Ҧ��w�}�ҡC>> %logfile%
    echo on
    set fd=F
)


setlocal enabledelayedexpansion
ser order=%1-%2-%3-%4-%5-%6-%7-%8-%9

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
set order=
if "%2"=="" (
    if "%local%"=="" (
    echo [INFO]����ҲաGcore���D�ҲաC>> %logfile%
    set /p order=Fu^>
    if "!order!"=="exit" (goto eof)
    if "!order!"=="reinit" (goto reinit)
    goto check
) else (
    echo [INFO]����Gcore���l�ҲաC>> %logfile%
    set /p order=Fu^>%local%^>
    if "!order!"=="back"   (goto back)
    if "!order!"=="exit"   (goto eof)
    if "!order!"=="reinit" (goto reinit)
    goto %local%.run
    )
) else (
    echo [INFO]����G����.run�ҲաC>> %logfile%
    goto %local%.run
)

:check
echo [INFO]�ˬd�G"%order%"�C>> %logfile%
if "%order%"=="" (set msg=���O���s�b�C & goto back)
if "%local%"=="" (
    set or=
    if "%2"=="" (
        @rem �D�Ҳժ�order����
        set order=%order: =-%
        set order=%order:.=-%
        findstr /x :!order! %~dpnx0 > nul && set or=ok
    ) else (
        findstr /x :%1 %~dpnx0 > nul && set or=ok
    )
)
if "%or%"=="ok" (
    echo [INFO]�ˬd�G"%order%"�s�b�C>> %logfile%
    if "%2"=="" (
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
echo [INFO]������O�G%local%�C>> %logfile%
goto core
:adb.run
echo Starting adb...
adb start-server
adb "%order%"
:adb.end
if "%2"=="" (goto %local%) else (goto eof)


:fastboot
:af
set local=fastboot
echo [INFO]������O�G%local%�C>> %logfile%
goto core
:fastboot.run
fastboot "%order%"
if "%2"=="" (goto %local%) else (goto eof)

:affr
:fastboot-flash-recovery
set local=fastboot-flash-recovery
goto core
:fastboot-flash-recoveryrun
fastboot flash recovery "%order%"
if "%2"=="" (goto affr) else (goto eof)

:timer
set local=timer
echo [INFO]������O�G%local%�C>> %logfile%
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
set local=adb-pair
echo [INFO]������O�G%local%�C>> %logfile%
set msg=�HIP�PPort�i��t��C
goto core
:adb-pair.run
adb pair %order%
adb connect %order%
if "%2"=="" (goto %local%) else (goto eof)


:apush
:adb-push
set local=adb-push
echo [INFO]������O�G%local%�C>> %logfile%
set msg=-Data will push to /sdcard/Download/.
::If you want use this in wireless, please pair first.
goto core
:adb-push.run
echo Starting adb...
adb start-server
adb push "%order%" /sdcard/Download
if "%2"=="" (goto %local%) else (goto eof)


:apull
:adb-pull
set local=adb-pull
echo [INFO]������O�G%local%�C>> %logfile%
set msg=-�ɮ׷|��m�b%outdir%�C^& echo -�u�䴩�b�U���ɮק������ɮסC
goto core
:adb-pull.run
echo �еy��C
adb  pull /storage/emulated/0/Download/%order% %outdir%\
if "%2"=="" (goto %local%) else (goto eof)


:ashell
:adb-shell
mode con: cols=150 lines=50
set local=adb-shell
echo [INFO]������O�G%local%�C>> %logfile%
if not "%2"=="" (adb shell %2 & goto eof) else (adb shell)
if "%2"=="" (goto core) else (goto eof)


:dl
set local=dl
echo [INFO]������O�G%local%�C>> %logfile%
goto core
:dl.run
set msg=-File will be place at %outdir%\ ^& echo= if progress is success.
if "%order:~0,3%"=="mp3" (
    set order=%order:~4%& set order=!order: ==!
    echo Current target: !order!
    ytdl -x --audio-format mp3 --verbose "!order!"
    move *.mp3 %outdir%

) else if "%order:~0,3%"=="mp4" (
    set order=%order:~4%& set order=!order: ==!
    echo Current target: !order!
    ytdl --recode-video mp4 %order:~3%
    move *.mp4 %outdir%\

) else if "%order:~0,5%"=="origin" (
    set order=%order:~5%& set order=!order: ==!
    echo Current target: !order!
    ytdl %order:~5%

) else if "%order:~0,5%"=="ytdlu" (
    ytdl --update

) else if "%order:~0,5%"=="clear" (
    del /f /s /q "%userprofile%\AppData\Local\VirtualStore"

) else (
    echo �{�b�Ұ�aria2c������x�C
    cd /d %~dp0\bin\dl
    Aria2Panel.html
    aria2c.exe --conf-path=aria2.conf
    cd /d %~dp0
)

:dl.end
if "%2"=="" (goto %local%) else (goto eof)


:counter
:count
set local=counter
echo [INFO]����G%local%�C>> %logfile%
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
echo %counter%>%~dp0\data\counter\%order%.txt
set /p counter=<%~dp0\data\counter\%order%.txt
echo Total count is %counter%
if "%2"=="" (goto %local%) else (goto eof)


:ctp
:control
set local=control
echo [INFO]������O�G%local%�C>> %logfile%
goto core
:control.run
if "%order%"=="panel" (
  control
  echo ����x�w�ҰʡC
) else if "%order%"=="diskc" (
  cleanmgr /sageset:99
  cleanmgr /sagerun:99
  echo �i���ϺвM�z�w�ҰʡC
) else if "%order%"=="spa" (
  start C:\Windows\System32\SystemPropertiesAdvanced.exe
  echo �i���t�γ]�w�w�Ұ�.
) else if "%order%"=="po" (
  control powercfg.cpl
  echo �q���޲z���O�w�ҰʡC
) else (
  set msg=�L�Ī����O�C
)

if "%2"=="" (goto %local%) else (set timeout=2& goto eof)


:self
set local=self
echo [INFO]������O�G%local%(�s�����)�C>> %logfile%
set localmsg=Self mangement.
goto core
:self.run
if "%order%"=="dir" (
    echo �o�Ӥu�㪺�ڥؿ��C & start explorer.exe /n,/e,%~dp0
    goto self.end
) else if "%order%"=="edit" (
    echo ��vsCode�s��ۤv�C & cmd /c start "vsCode" code %~dpnx0
    goto self.end
)
set msg=��%local%���޼ƵL�ġC
:self.end
if "%2"=="" (goto %local%) else (set timeout=2& goto eof)


:ping
set local=ping
echo [INFO]������O�G%local%�C>> %logfile%
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
set local=RealESRGAN
echo [INFO]������O�G%local%�C>> %logfile%
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
realesrgan-ncnn-vulkan %order%
if errorlevel 0 (
  echo Compelected.
  echo=
  echo File will be placed at %output%
  echo= )
:RealESRGAN.end
set input=& set output=
if "%2"=="" (goto %local%) else (goto eof)


:mega
set local=mega
set MegaCmdClinetExec="C:\Users\Administrator\AppData\Local\MEGAcmd\MEGAclient.exe"
goto core
:mega.run
if "%order%"=="UL" (
    %MegaCmdClinetExec% put %order:~7% /
) else if "%order%"=="DL" (
    %MegaCmdClinetExec% get %order:~7% %outdir%
) else if "%order%"=="shell" (
    start "MegaCmdShell" %MegaCmdClinetExec:~0,-11%cmdShell.exe
) else if "%order%"=="kill-server" (
    taskkill -f -im MEGAcmdServer.exe
    timeout 3 > nul
) else (
    set msg=�ާ@���s�b�C
)
if "%2"=="" (goto %local%) else (set timeout=0& goto eof)


:mc
start D:\_Addon\_Utils\EasyMC.exe
if "%2"=="" (
    if "%1"=="" (
        goto back
    ) else (
        set timeout=2& goto eof
    )
) else (
    set timeout=2& goto eof
)


:lspath
echo %path%
if "%2"=="" (
    if "%1"=="" (
        goto back
    ) else (
        set timeout=2& goto eof
    )
) else (
    set timeout=2& goto eof
)

::end
::���O������:::::::::::::::::::

:eof
echo=
if not "%msg%"=="" (echo %msg%) & set msg=
echo=
if "%local%"=="adb" (
    taskkill -f -im adb.exe > nul
) else if not "%timeout%"=="" (
    timeout /nobreak %timeout% > nul
) else if not "%2"=="" (
        pause
)
cd /d %ccd%
echo [INFO]�妸�ɰ��浲���C>> %logfile%
goto:eof


:help
set local=help
findstr /b : %~dpnx0
if "%2"=="" (goto back) else (set timeout=2& goto eof)

::spell
::magic
::charms
�ٷF �O��s���� ��I �o�i�H�i�� �ٱi���o�i�H�i�� �ڤ����D �A��^�a �٭ɹL�ɹL���n�] ��e�]���F ��I�I ���n�x��
�A�n���nťť�ݧA�{�b�b������