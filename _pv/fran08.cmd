@echo off
setlocal EnableDelayedExpansion
::^用於以!包圍的變數
set airdir=D:\_AirOS
set edk2dir=%airdir%\edk2
set outdir=%userprofile%\downloads
set ccd=%cd%
set order= & set local= & set localmsg=
set ver=0.8
set eofmsg=Take care.

if exist fran (cd fran)
cd /d %~dp0%
if not "%1"=="" (goto %1)
:back
cd /d %~dp0%
if "%order%"=="exit" (goto eof)
set local=core
::::::::::::::::::::::::::::::::
:core
echo.
echo Fran Utils %ver% - %local%
echo -----------------------------
::下方指令清除輸出檔案
if exist msg (del msg)
set order=nonenul
if "%2"=="" (if not "%localmsg%"=="" (echo %localmsg%))
if "%2"=="" (set /p order=PlantationShell^>) else (set order=%2)
set localmsg=
if "%order%"=="nonenul" (
  if "%local%"=="help" (goto emptyallowed)
  ::在此加入允許空指令的地方
  set localmsg=Order something valid, please. & goto back )
:emptyallowed
::下面放通用一層的指令
if "%order%"=="back" (goto back)
if "%order%"=="exit" (goto back)
::---以下if內容問題所在---
if "%local%"=="core" (
findstr /x %order% francmdlist.txt > nul && goto %order%
::findstr需要/x引數才能準確且正常的運作
%order% & goto core
) else (
::下面放通用二層的指令
if not "%cd:~-3%"=="ran" (cd ..)
  ::上面這條的意思是偵測並決定是否返回上一層(core)
if "%order%"=="cd" (echo %cd% & goto %local%)
if "%local:~0,3%"=="adb" (cd adb & adb start-server)
if "%local:~0,8%"=="fastboot" (cd adb)
if "%local:~0,2%"=="dl" (cd dl)
if "%local:~0,5%"=="docto" (cd docto)
if "%local:~0,10%"=="RealESRGAN" (cd RealESRGAN)
goto %local%run)
::::::::::::::::::::::::::::::::
:help
set local=help
goto core
:helprun
echo=
type help.txt
echo=
pause > nul
if "%2"=="" (goto %local%) else (goto eof)

:adb
:aa
set local=adb
goto core
:adbrun
echo Starting adb...
adb start-server
adb "%order%"
if "%2"=="" (goto %local%) else (goto eof)

:aad
:adb-devices
cd adb
adb start-server
adb devices
if "%2"=="" (goto %local%) else (goto eof)



:fastboot
:af
set local=fastboot
if not "%2"=="" (fastboot %2 & goto eof)
goto core
:fastbootrun
fastboot "%order%"
if "%2"=="" (goto %local%) else (goto eof)



:afd
:fastboot-devices
set local=fastboot-devices
fastboot devices > msg
type msg & pause
if "%2"=="" (goto back) else (goto eof)



:aff
:fastboot-flash
set local=fastboot-flash
if not "%2"=="" (fastboot flash %2 & goto eof)
goto core
:fastboot-flashrun
fastboot flash "%order%"
if "%2"=="" (goto %local%) else (goto eof)



:affr
:fastboot-flash-recovery
set local=fastboot-flash-recovery
goto core
:fastboot-flash-recoveryrun
if "%order%"=="reboot" (fastboot reboot & goto affr)
fastboot flash recovery "%order%"
if "%2"=="" (goto affr) else (goto eof)



:aapair
:apair
:adb-pair
set local=adb-pair
set localmsg=-Pair device using ip and port.
goto core
:adb-pairrun
adb pair %order%
adb connect %order%
if "%2"=="" (goto %local%) else (goto eof)

:aapush
:apush
:adb-push
set local=adb-push
set localmsg=-Data will push to /sdcard/Download/.
::If you want use this in wireless, please pair first.
goto core
:adb-pushrun
echo Starting adb...
adb start-server
adb push "%order%" /sdcard/Download
if "%2"=="" (goto %local%) else (goto eof)



:aashell
:ashell
:adb-shell
cd adb
mode con: cols=150 lines=50
set local=adb-shell
if not "%2"=="" (adb shell %2 & goto eof) else (adb shell)
if "%2"=="" (goto %local%) else (goto eof)


:aapull
:apull
:adb-pull
set local=adb-pull
set localmsg=-File will be pull to %userprofile%\download\. ^& echo -Only support files at download folder.
goto core
:adb-pullrun
echo Please wait.
adb pull /storage/emulated/0/Download/%order% %outdir%\
if "%2"=="" (goto %local%) else (goto eof)


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
set eofmsg=-File will be place at %outdir%\ ^& echo= if progress is success.
if "%order:~0,3%"=="mp3" (ytdl -x --audio-format mp3 %order:~3% & move *.mp3 %outdir%\ & goto dlpassed)
if "%order:~0,3%"=="mp4" (ytdl --recode-video mp4 %order:~3% & move *.mp4 %outdir%\ & goto dlpassed)
if "%order:~0,7%"=="nosplit" (aria2c.exe --dir=%outdir% %order:~7% & goto dlpassed)
if "%order:~0,1%"=="u" (ytdl --update & goto dlpassed)
:::::::::::::::::::::::::::::::::::::::::::::::::
aria2c.exe -s 10 -x 16 --dir=%outdir% --conf-path=aria2.conf %order%
:dlpassed
pause
if "%2"=="" (goto %local%) else (goto eof)


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
if "%2"=="" (goto %local%) else (goto eof)


:ctp
:controlpanel
set local=controlpanel
goto core
:controlpanelrun
if "%order:~0,3%"=="ctp" (
  "%~dp0%\ctp.lnk"
  echo ControlPanel launched.
) else if "%order:~0,5%"=="diskc" (
  cleanmgr /sageset:99
  cleanmgr /sagerun:99
  echo AdvancedDiskCleaner launched.
) else if "%order:~0,3%"=="spa" (
  start C:\Windows\System32\SystemPropertiesAdvanced.exe
  echo SystemPropertiesAdvanced launched.
) else if "%order:~0,2%"=="po" (
  "%~dp0%po.lnk"
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
if "%2"=="" (goto po) else (goto eof)


:self
if not "%2"=="" (set order=%2)
set local=self
set localmsg=Self mangement.
goto core
:selfrun
if "%order%"=="dir" (echo Codes' home. & start explorer.exe /n,/e,%cd%)
if "%order%"=="edit" (echo Edit self using vsCode. & start "vsCode" code %~dp0%\fran.cmd)
if "%order%"=="edk2" (echo Edk2's home. & start explorer.exe /n,/e,%edk2dir%\)
if "%2"=="" (goto %local%) else (goto eof)



::::::::::::::::::::::::::::::::::::::::::
::build and --buildrun 用於解決build後會自動退出的問題
:air
set local=air
if not exist %airdir% (set localmsg=AirOS dev env not found. & goto back)
if not exist %edk2dir% (set localmsg=EDK2 not found. & goto back)
goto core
:airrun
if not "%2"=="" (set order=%2 %3)
::注意runall 跟 run 的順序

if "%order:~0,6%"=="runall" (
    start "Fran edk2 build unity" /max cmd /c %0 air --runallrun
    goto %local% )
if "%order:~0,11%"=="--runallrun" (
    title Fran edk2 build unity - [1/3] Building emulator
    cmd /c %0 air uefi --buildemurun
    title Fran edk2 build unity - [2/3] Building project
    cmd /c %0 air uefi --buildrun
    title Fran edk2 build unity - [3/3] Loading .efi file
    cmd /c %0 air uefi load
    title Fran edk2 build unity - Completed.
    echo Completed. Press any key to continue...
    pause > nul
    exit )

if "%order:~0,3%"=="run" (
    start "Fran edk2 build unity" /max cmd /c %0 air --runrun
    goto %local% )
if "%order:~0,8%"=="--runrun" (
    title Fran edk2 build unity - [1/2] Building project
    cmd /c %0 air uefi --buildrun
    title Fran edk2 build unity - [2/2] Loading .efi file
    cmd /c %0 air uefi load
    title Fran edk2 build unity - Completed.
    echo Completed. Press any key to continue...
    pause > nul
    exit )

if "%order:~0,3%"=="emu" (
    set BUILD=%edk2dir%\Build
    "c:\Program Files\qemu\qemu-system-x86_64.exe" -m 2048 -smp 1 -bios %build%\OvmfX64\DEBUG_VS2015\FV\OVMF.fd -global e1000.romfile="" -machine q35 -serial mon:stdio -hda fat:rw:%edk2dir%\_Emulator --net none
    if "%2"=="" (goto %local%) else (goto eof))

if "%order:~0,4%"=="uefi" (

    if "%order:~5%"=="build" (
        cmd /c %0 air uefi --buildrun
        goto %local% )
    if "%order:~5%"=="--buildrun" (
        cd /d %edk2dir%\
        mkdir _Emulator
        call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
        echo Doing edk2 build task...
        call edksetup.bat VS2015
        set NASM_PREFIX="C:\Program Files\NASM\"
        set WINSDK81_PREFIX="c:\Program Files (x86)\Windows Kits\8.1\bin\"
        build -a X64 -p OvmfPkg\OvmfPkgX64.dsc -t VS2015 -b DEBUG -m "%edk2dir%\_Emulator\source.inf" )

    if "%order:~5%"=="buildemu" (
        cmd /c %0 air uefi --buildemurun
        goto %local% )
    if "%order:~5%"=="--buildemurun" (
        cd /d %edk2dir%\
        mkdir _Emulator
        call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
        echo Doing edk2 build task...
        call edksetup.bat VS2015
        set NASM_PREFIX="C:\Program Files\NASM\"
        set WINSDK81_PREFIX="c:\Program Files (x86)\Windows Kits\8.1\bin\"
        build -a X64 -t VS2015 -p OvmfPkg\OvmfPkgX64.dsc -b DEBUG )

    if "%order:~5%"=="dir" (
        explorer.exe /n,/e,%edk2dir% & goto eof)

    if "%order:~5%"=="emu" (
        set BUILD=%edk2dir%\Build
        "c:\Program Files\qemu\qemu-system-x86_64.exe" -m 2048 -smp 1 -bios %build%\OvmfX64\DEBUG_VS2015\FV\OVMF.fd -global e1000.romfile="" -machine q35 -serial mon:stdio -hda fat:rw:%edk2dir%\_Emulator --net none
        if "%2"=="" (goto %local%) else (goto eof))

    if "%order:~5%"=="load" (
        del %edk2dir%\_Emulator\*.efi
        copy %edk2dir%\Build\OvmfX64\DEBUG_VS2015\X64\_Emulator\source\OUTPUT\*.efi %edk2dir%\_Emulator
        if "%2"=="" (goto %local%) else (goto eof))

    if "%order:~5%"=="e" (
        explorer.exe /n,/e/,%edk2dir%\_Emulator
        if "%2"=="" (goto %local%) else (goto eof) )

    if "%order:~5%"=="editdisk" (
        explorer.exe /n,/e/,%edk2dir%\_Emulator
        if "%2"=="" (goto %local%) else (goto eof))

    if "%order:~5%"=="clear" (
        cd /d %edk2dir%\_Emulator
        choice /m "Clear all?"
        if errorlevel 1 (del *.* & echo Cleared.)
        goto %local% )

    set localmsg=Invaild operate.
        if "%2"=="" (goto %local%) else (goto eof) )
::air uefi end

set localmsg=Invaild command.
if "%2"=="" (goto %local%) else (goto eof)
::::::::::::::::::::::::::::::::::::::::::



:docto
set local=docto
set localmsg=Docment covent, doc to to pdf.
goto core
:doctorun
echo Task is running...
docto -WD -F %order% -T wdFormatPDF -O %outdir%\
if "%2"=="" (goto %local%) else (goto eof)

:videoto
:vidto
ffmpeg -i "%2" -vn "%outdir%\%3"
if "%2"=="" (goto %local%) else (goto eof)

:ping
set local=ping
set localmsg=-Google server ip is 142.251.43.14
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
if "%2"=="" (goto %local%) else (goto eof)



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
set localmsg=-Here only can enter full command.
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

"realesrgan-ncnn-vulkan.exe" %order%

if errorlevel 0 (
  echo Compelected.
  echo=
  echo File will be placed at %outdir%
  echo=
  pause )

:RealESRGANend
set input=
if "%2"=="" (goto %local%) else (goto eof)




:eof
if not "%localmsg%"=="" (echo %localmsg%)
set eofmsg=
set localmsg=
echo.
if "%local:~0,3%"=="adb" (taskkill -f -im adb.exe)
if "%2"=="" (timeout 3 > nul) else (timeout 1 > nul)
@cd /d %ccd%