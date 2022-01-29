::DocEncode=Big5(cp950)
@echo off
goto init
:reinit
set msg=正在重新初始化...
:init
set ccd=%cd% & cd /d %~dp0
set ver=1.1
set local=& set or=
@REM set ccd=%cd% & cd /d %~dp0%
::%~dp0%後面這個"%"必須加，否則對於其他目錄的存取權限會出問題
::設定工具PATH::
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
if "%order%"=="reinit" (set msg=%msg%完成。)



::DebugTool
::內部模組：back,core,check,eof
if exist %logfile% (del %logfile%)
echo [INFO]偵錯工具：多重記錄檔功能已被棄用。>> %logfile%
echo [INFO]偵錯工具：紀錄時間 "%date% %time%"。>> %logfile%
echo [INFO]偵錯工具：記錄檔為"%logfile%"。>> %logfile%
echo [INFO]偵錯工具：傳入的引數為"%1,%2,%3,%4,%5,%6,%7,%8,%9">> %logfile%


if "%1"=="dbg" (
    if "%2"=="SW" (
        if "%fd%"=="F" (
            set fd=T
            set msg=偵錯狀態切換到True。
        ) else (
            set fd=F
            set msg=偵錯狀態切換到False。
        )
    ) else if "%2"=="T" (
        set fd=T
        set msg=偵錯狀態切換到True。
    ) else if "%2"=="F" (
        set fd=F
        set msg=偵錯狀態切換到False。
    ) else (
        echo 這個指令只有SW,T,F選項可用。
    )
    
    set timeout=0& goto eof
)
if "%fd%"=="T" (
    echo [INFO]偵錯工具：詳細執行模式已開啟。>> %logfile%
    echo on
    set fd=F
)


setlocal enabledelayedexpansion
ser order=%1-%2-%3-%4-%5-%6-%7-%8-%9

if not "%order%"=="" (
    goto check
)

::核心模組:::::::::::::::::::

:back
set local=& set order=


:core
echo [INFO]執行：core模組。>> %logfile%
echo=
title Fran Utils %ver%
echo Fran Utils %ver%
echo --------------------------
if not "%msg%"=="" (echo %msg%) & set msg=
set order=
if "%2"=="" (
    if "%local%"=="" (
    echo [INFO]執行模組：core的主模組。>> %logfile%
    set /p order=Fu^>
    if "!order!"=="exit" (goto eof)
    if "!order!"=="reinit" (goto reinit)
    goto check
) else (
    echo [INFO]執行：core的子模組。>> %logfile%
    set /p order=Fu^>%local%^>
    if "!order!"=="back"   (goto back)
    if "!order!"=="exit"   (goto eof)
    if "!order!"=="reinit" (goto reinit)
    goto %local%.run
    )
) else (
    echo [INFO]執行：執行.run模組。>> %logfile%
    goto %local%.run
)

:check
echo [INFO]檢查："%order%"。>> %logfile%
if "%order%"=="" (set msg=指令不存在。 & goto back)
if "%local%"=="" (
    set or=
    if "%2"=="" (
        @rem 主模組的order限制
        set order=%order: =-%
        set order=%order:.=-%
        findstr /x :!order! %~dpnx0 > nul && set or=ok
    ) else (
        findstr /x :%1 %~dpnx0 > nul && set or=ok
    )
)
if "%or%"=="ok" (
    echo [INFO]檢查："%order%"存在。>> %logfile%
    if "%2"=="" (
        goto %order%
    ) else (
        goto %1
    )
) else (
    echo [INFO]檢查："%order%"不存在。>> %logfile%
    set msg=指令不存在。
    if "%2"=="" (goto back) else (goto eof)
)

echo [ERRS]崩潰：批次檔出現內部錯誤，請嘗試修正可能的問題後再次執行本批次檔。>> %logfile%
goto eof

::指令集開頭:::::::::::::::::::


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
echo [INFO]執行指令：%local%。>> %logfile%
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
echo [INFO]執行指令：%local%。>> %logfile%
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
echo [INFO]執行指令：%local%。>> %logfile%
set msg=以分鐘計時,最長10分鐘。
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
echo - 時間到啦 -
echo  & timeout 2 /nobreak > nul
echo  & timeout 2 /nobreak > nul
echo 
if "%2"=="" (goto %local%) else (goto eof)


:apair
:adb-pair
set local=adb-pair
echo [INFO]執行指令：%local%。>> %logfile%
set msg=以IP與Port進行配對。
goto core
:adb-pair.run
adb pair %order%
adb connect %order%
if "%2"=="" (goto %local%) else (goto eof)


:apush
:adb-push
set local=adb-push
echo [INFO]執行指令：%local%。>> %logfile%
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
echo [INFO]執行指令：%local%。>> %logfile%
set msg=-檔案會放置在%outdir%。^& echo -只支援在下載檔案夾中的檔案。
goto core
:adb-pull.run
echo 請稍後。
adb  pull /storage/emulated/0/Download/%order% %outdir%\
if "%2"=="" (goto %local%) else (goto eof)


:ashell
:adb-shell
mode con: cols=150 lines=50
set local=adb-shell
echo [INFO]執行指令：%local%。>> %logfile%
if not "%2"=="" (adb shell %2 & goto eof) else (adb shell)
if "%2"=="" (goto core) else (goto eof)


:dl
set local=dl
echo [INFO]執行指令：%local%。>> %logfile%
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
    echo 現在啟動aria2c的控制台。
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
echo [INFO]執行：%local%。>> %logfile%
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
echo [INFO]執行指令：%local%。>> %logfile%
goto core
:control.run
if "%order%"=="panel" (
  control
  echo 控制台已啟動。
) else if "%order%"=="diskc" (
  cleanmgr /sageset:99
  cleanmgr /sagerun:99
  echo 進階磁碟清理已啟動。
) else if "%order%"=="spa" (
  start C:\Windows\System32\SystemPropertiesAdvanced.exe
  echo 進階系統設定已啟動.
) else if "%order%"=="po" (
  control powercfg.cpl
  echo 電源管理面板已啟動。
) else (
  set msg=無效的指令。
)

if "%2"=="" (goto %local%) else (set timeout=2& goto eof)


:self
set local=self
echo [INFO]執行指令：%local%(編輯自體)。>> %logfile%
set localmsg=Self mangement.
goto core
:self.run
if "%order%"=="dir" (
    echo 這個工具的根目錄。 & start explorer.exe /n,/e,%~dp0
    goto self.end
) else if "%order%"=="edit" (
    echo 用vsCode編輯自己。 & cmd /c start "vsCode" code %~dpnx0
    goto self.end
)
set msg=給%local%的引數無效。
:self.end
if "%2"=="" (goto %local%) else (set timeout=2& goto eof)


:ping
set local=ping
echo [INFO]執行指令：%local%。>> %logfile%
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
echo [INFO]執行指令：%local%。>> %logfile%
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
    set msg=操作不存在。
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
::指令集結尾:::::::::::::::::::

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
echo [INFO]批次檔執行結束。>> %logfile%
goto:eof


:help
set local=help
findstr /b : %~dpnx0
if "%2"=="" (goto back) else (set timeout=2& goto eof)

::spell
::magic
::charms
欸幹 是穿山甲欸 嗚呼 這可以養嗎 欸張郎這可以養嗎 我不知道 你抓回家 欸借過借過不要跑 嗚牠跑掉了 嗚呼呼 嗚喔好屌喔
你要不要聽聽看你現在在說什麼