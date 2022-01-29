::DocEncode=Big5(cp950)
::參數格式:fran.cmd <function-name-to-call> <ArgumentForFunction>
@echo off
setlocal enabledelayedexpansion

:init
set ccd=%cd% & cd /d %~dp0
set ver=2.0
set outdir=%userprofile%\downloads
set logfile=%~dp0_log\log%func%.txt
set mclauncher="C:\Program Files (x86)\Minecraft Launcher\MinecraftLauncher.exe"
::將logfile設為nul來關閉紀錄功能
@REM where adb.exe 2> nul
@REM if errorlevel 1 (
@REM set path=%path%;%~dp0bin;^
@REM %~dp0bin\adb;^
@REM %~dp0bin\dl;^
@REM %~dp0bin\docto;^
@REM %~dp0bin\ffmpeg;^
@REM %~dp0bin\RealESRGAN;^
@REM %~dp0bin\trans;
@REM )

if exist private.cmd (
    set msg=- 自訂指令集已啟用。
)
echo [INFO]偵錯工具：多重記錄檔功能已被棄用。>> %logfile%
echo [INFO]偵錯工具：紀錄時間 "%date% %time%"。>> %logfile%
echo [INFO]偵錯工具：記錄檔為"%logfile%"。>> %logfile%
echo [INFO]偵錯工具：傳入的引數為"%1,%2,%3,%4,%5,%6,%7,%8,%9">> %logfile%
echo [INFO]偵錯工具：現有的變數如下>> %logfile%
set >> %logfile%

set func=%1& set order=%2 %3 %4 %5 %6 %7 %8 %9

::::::::::::::::::::::::::::::::::::::

:core
echo [INFO]執行：core模組。>> %logfile%
echo.
echo=  Fran Utils %ver% %msg% & set msg=

if "%func%"=="" (
    echo [INFO]執行模組：core的主模組。>> %logfile%
    start %windir%\System32\cmd.exe
    exit
) else (
    echo=  ^>%func% %order%
    echo.
    echo [INFO]執行：有參數傳入。>> %logfile%
    goto check
)

:check
echo [INFO]檢查：%func%>> %logfile%
if exist private.cmd (
    call private.cmd
)
findstr /x :%func% %~dpnx0 > nul
if %errorlevel%==0 (
    echo [INFO]檢查："%func%"存在。>> %logfile%
    goto %func%
) else (
    echo [INFO]檢查："%func%"不存在。>> %logfile%
    set msg="%func%"不存在於Fran的指令集中。
    set timeout=3
    goto eof
)

::功能集開頭::::::::::::::::::::::::::::::

:adb
:adb-dev
:adb-kill
set class=adb
echo [INFO]執行功能：%class%。>> %logfile%
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
set class=fastboot
echo [INFO]執行功能：%func%。>> %logfile%
if "%func%"=="%class%-dev" (
    bin\adb\fastboot.exe device
) else (
    bin\adb\fastboot.exe %order%
)
set timeout=-1& goto eof


:self
:self-dir
:self-edit
set class=self
echo [INFO]執行功能：%func%(編輯自體)。>> %logfile%
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
echo [INFO]執行功能：%class%。>> %logfile%
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
echo [INFO]執行指令：%class%。>> %logfile%
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
echo [INFO]執行指令：%class%。>> %logfile%
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
echo [INFO]執行指令：%class%。>> %logfile%
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


@REM :mega
@REM :meag-UL
@REM :mega-DL
@REM :mega-shell
@REM :mega-kill
@REM set class=mega
@REM set MegaCmdClinetExec="C:\Users\Administrator\AppData\class\MEGAcmd\MEGAclient.exe"
@REM if "%func%"=="%class%-UL" (
@REM     %MegaCmdClinetExec% put %order% /
@REM ) else if "%func%"=="%class%-DL" (
@REM     %MegaCmdClinetExec% get %order% %outdir%
@REM ) else if "%func%"=="%class%-shell" (
@REM     start "MegaCmdShell" %MegaCmdClinetExec:~0,-11%cmdShell.exe
@REM ) else if "%func%"=="%class%-kill" (
@REM     taskkill -f -im MEGAcmdServer.exe
@REM     timeout 3 > nul
@REM ) else (
@REM     set msg=操作不存在。
@REM )
@REM set timeout=10& goto eof


:flow
:flow-c
:flow-cpp
:flow-efi
:flow-py2
:flow-py3
::目前僅可編譯單一檔案(但寫在檔案裡的不在此限)
::switch dir before use
cd /d %~dp2
set class=flow
set arg=%3 %4 %5 %6 %7 %8 %9
::關於為什麼要用DelayedExpansion及配套的"!"，請見:
::https://stackoverflow.com/questions/9102422/windows-batch-set-inside-if-not-working/9102569\::
::主要是延遲解釋啦

::模板
::(else) if "%func%"=="%class%-語言名稱" (
::    set target=%~n2.原始碼副檔名    #原始碼檔案
::    (set target=%~nx2) #用於語言的源代碼有多種副檔名時
::    set command=gcc/clang/cl... #編譯指令
::    set execute=%~n2.二進位檔副檔名    #編譯後要執行的命令
::)

if "%func%"=="%class%-c" (
    set target=%~n2.c
    set execute=%~n2.exe
    set command=gcc !target! -o !execute! %arg%
) else if "%func%"=="%class%-cpp" (
    set target=%~nx2
    set execute=%~n2.exe
    set command=g++ !target! -o !execute! %arg%
) else if "%func%"=="%class%-efi" (
    set target=%~n2.c
    set execute=%~n2.efi
    set command=gcc^
        -Wall^
        -Wextra^
        -nostdinc^
        -nostdlib^
        -fno-builtin^
        -e main^
        -Wl,--subsystem,10^
        -o !execute! !target!
) else if "%func%"=="%class%-py3" (
        set target=%~n2.py
        set command=
        set execute=py -3 !target!
) else if "%func%"=="%class%-py2" (
        set target=%~n2.py
        set command=
        set execute=py -2 !target!
) else (
    echo [ERRS]失敗:指定的語言無效。& goto:eof )

::-------
:: 判斷是否需要編譯
if not "%command%"=="" (
    :: 需要則編譯原始碼
    set /p = [INFO]正在編譯....<nul
    %command%
) else (
    :: 不需要則直接執行手稿
    echo -^|執行%target%^|-
    %execute%
    echo -^|執行結束[!errorlevel!]^|-
    goto flow.end
)
::-------

if not "%command%"=="" (
    if %errorlevel%==0 (
        ::如果編譯成功
        echo ....編譯完成。
        echo.
        echo -^|執行%execute%^|-
        ::-------
        %execute%
        ::-------
        echo -^|執行結束[!errorlevel!]^|-
    ) else (
        ::如果編譯失敗
        echo 編譯失敗。
    )
)

:flow.end
set target=& set command=& set execute=
set timeoout=0& goto:eof


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

:help
echo Fran Utils %ver%
echo.
echo 用法：fran [功能] <指令>
echo.
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
echo flow
echo   flow-c
echo   flow-cpp
echo   flow-efi