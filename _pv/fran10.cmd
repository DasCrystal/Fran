 ::DocEncode=Big5(cp950)

@echo off

::DebugTool
::logcount是什麼意思呢？是紀錄數的意思喔！
::越舊的紀錄數字越大
::內部模組：back,core,check,eof
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

echo [INFO]偵錯工具：紀錄時間 "%date% %time%"。>> %logfile%
echo [INFO]偵錯工具：記錄檔為%logfile%。>> %logfile%
if "%MultiLog%"=="" (
    echo [INFO]偵錯工具：多重記錄檔已關閉。>> %logfile%
    if exist %logfile% (del %logfile%)
) else (
    echo [INFO]偵錯工具：多重記錄檔已開啟。>> %logfile%
    if exist %logfile% (ren %logfile% log_%1%logcount%.txt)
)

echo [INFO]偵錯工具：傳入的指令為"%1 %2 %3 %4 %5 %6 %7 %8 %9">> %logfile%
if not "%fd%"=="" (
    echo [INFO]偵錯工具：詳細執行模式已開啟。>> %logfile%
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
if "%2"=="" (
    if "%local%"=="" (
    echo [INFO]執行模組：core的主模組。>> %logfile%
    set /p order=FU^>
    if "!order!"=="exit" (goto eof)
    goto check
    ) else (
    echo [INFO]執行：core的子模組。>> %logfile%
    set /p order=FU^>%local%^>
    if "!order!"=="back" (goto back)
    if "!order!"=="exit" (goto eof)
    goto %local%.run
    )
) else (
    echo [INFO]執行：檢查結束，直接執行功能。>> %logfile%
    goto %local%.run
)

:check
echo [INFO]檢查："%order%"。>> %logfile%
if "%order%"=="" (set msg=指令不存在。 & goto back)
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
    echo [INFO]檢查："%order%"存在。>> %logfile%
    if "%1"=="" (
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
echo [INFO]執行：timer模組。>> %logfile%
set local=timer
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
echo [INFO]執行：adb-pair模組。>> %logfile%
set local=adb-pair
set msg=以IP與Port進行配對。
goto core
:adb-pair.run
"%~dp0\adb\adb.exe" pair %order%
"%~dp0\adb\adb.exe" connect %order%
if "%2"=="" (goto %local%) else (goto eof)


:apush
:adb-push
echo [INFO]執行：adb-push模組。>> %logfile%
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
echo [INFO]執行：adb-pull模組。>> %logfile%
set local=adb-pull
set msg=-檔案會放置在%outdir%。^& echo -只支援在下載檔案夾中的檔案。
goto core
:adb-pull.run
echo 請稍後。
"%~dp0\adb\adb.exe"  pull /storage/emulated/0/Download/%order% %outdir%\
if "%2"=="" (goto %local%) else (goto eof)


:ashell
:adb-shell
echo [INFO]執行：adb-shell模組。>> %logfile%
mode con: cols=150 lines=50
set local=adb-shell
if not "%2"=="" ("%~dp0\adb\adb.exe" shell %2 & goto eof) else ("%~dp0\adb\adb.exe" shell)
if "%2"=="" (goto core) else (goto eof)


:dl
echo [INFO]執行：dl模組。>> %logfile%
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
echo [INFO]執行：counter模組。>> %logfile%
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
echo [INFO]執行：control模組。>> %logfile%
set local=control
goto core
:control.run
if "%order%"=="ctp" (
  control
  echo 控制台已啟動。
) else if "%order%"=="diskc" (
  cleanmgr /sageset:99
  cleanmgr /sagerun:99
  echo 進階磁碟清理已啟動。
) else if "%order%"=="spa" (
  start C:\Windows\System32\SystemPropertiesAdvanced.exe
  echo SystemPropertiesAdvanced launched.
) else if "%order%"=="po" (
  control powercfg.cpl
  echo 電源管理面板已啟動。
) else (
  echo 無效的指令。 )
if "%2"=="" (goto %local%) else (goto eof)


:self
echo [INFO]執行：self模組。> %logfile%
set local=self
set localmsg=Self mangement.
goto core
:self.run
if "%order%"=="dir" (echo 這個工具的根目錄。 & start explorer.exe /n,/e,%~dp0)
if "%order%"=="edit" (echo 用vsCode編輯自己。 & start "vsCode" code %~dp0\fran.cmd)
if "%2"=="" (goto %local%) else (goto eof)


:ping
echo [INFO]執行：ping模組。> %logfile%
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
echo [INFO]執行：RealESRGAN模組。> %logfile%
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
::指令集結尾:::::::::::::::::::

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

echo [INFO]批次檔執行結束。>> %logfile%
