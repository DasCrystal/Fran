@echo off
set airdir=D:\_AirOS
set edk2dir=%airdir%\edk2
set ccd=%cd%
set order= & set local= & set localmsg=
set ver=0.7

if exist fran (cd fran)
cd /d %~dp0%
if not "%1"=="" (goto %1)
:back
cd /d %~dp0%
if "%order%"=="exit" (goto eof)
set local=core
set order=
::::::::::::::::::::::::::::::::
:core
echo.
echo Fran Utils %ver% - %local%
echo -----------------------------
if not "%localmsg%"=="" (echo %localmsg%)
if exist msg (del msg)
set localmsg=
set order=nonenul
if "%2"=="" (set /p order=PlantationShell^>) else (set order=%2)
if "%order%"=="nonenul" (set localmsg=Order something valid, please. & goto back)
::下面放通用一層的指令
if "%order%"=="back" (goto back)
if "%order%"=="exit" (if "%eofmsg%"=="" (set eofmsg=Take care, have a nice day. & goto back) else (goto back))
::---以下if內容問題所在---
if "%local%"=="core" (
findstr %order% francmdlist.txt > nul && goto %order%
%order% & goto core
) else (
::下面放通用二層的指令
if not "%cd:~-3%"=="ran" (cd ..)
  ::上面這條的意思是偵測並決定是否返回上一層(core)
if "%order%"=="cd" (echo %cd% & goto %local%)
if "%local:~0,3%"=="adb" (cd adb)
if "%local:~0,8%"=="fastboot" (cd adb)
if "%local:~0,2%"=="dl" (cd dl)
if "%local:~0,5%"=="docto" (cd docto)
goto %local%run)
::::::::::::::::::::::::::::::::
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
set local=adb-devices
adb start-server
adb devices
if "%1"=="" (goto back) else (goto eof)



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
set /p localmsg= < msg
goto back



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



:aapush
:apush
:adb-push
set local=adb-push
set localmsg=-Data will push to /sdcard/Download/.
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
if "%2"=="" (goto back) else (goto eof)


:aapull
:apull
:adb-pull
set local=adb-pull
set localmsg=-File will be pull to %userprofile%\download\. ^& echo -Only support files at download folder.
goto core
:adb-pullrun
adb pull /storage/emulated/0/Download/%order% %userprofile%\downloads\
if "%2"=="" (goto %local%) else (goto eof)


:dl
set local=dl
goto core
:dlrun
if not "%2"=="" (
if "%4"=="" (set order=%2 %3)
if "%5"=="" (set order=%2 %3=%4)
if "%6"=="" (set order=%2 %3=%4=%5)
)
echo Current target: %order%
set eofmsg=-File will be place at %userprofile%\downloads\ ^& echo= if progress is success.
if "%order:~0,3%"=="mp3" (ytdl -x --audio-format mp3 %order:~3% & move *.mp3 %userprofile%\downloads\ & goto dlpassed)
if "%order:~0,3%"=="mp4" (ytdl --recode-video mp4 %order:~3% & move *.mp4 %userprofile%\downloads\ & goto dlpassed)
if "%order:~0,7%"=="nosplit" (aria2c.exe --dir=%userprofile%\downloads %order:~7% & goto dlpassed)
if "%order:~0,1%"=="u" (ytdl --update & goto dlpassed)
:::::::::::::::::::::::::::::::::::::::::::::::::
aria2c.exe -s 10 -x 16 --dir=%userprofile%\downloads --conf-path=aria2.conf %order%
:dlpassed
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
if "%2"=="" (goto back) else (goto eof)



:spa
:envpath
start C:\Windows\System32\SystemPropertiesAdvanced.exe
if "%1"=="" (goto back) else (goto eof)



:ctp
:controlpanel
"%~dp0%\ctp.lnk"
if "%1"=="" (goto back) else (goto eof)



:po
:poweroption
:power-option
set local=power-option
goto core
:power-optionrun
::下面那行在某些模塊中極為重要
if not "%2"=="" (set order=%2 %3)
::上面那行
if "%order%"=="list" (powercfg /list & pause > nul)
if "%order%"=="panel" ("%~dp0%po.lnk")
::顯示極速模式:powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
::在下方加入其他的電源計畫
if "%order:~0,6%"=="switch" (
    if "%order:~7%"=="normal" (powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e & echo Switched to "normal".  & goto power-optionend)
    if "%order:~7%"=="extreme" (powercfg -setactive 763aa365-a15b-458b-b1f7-bb7b9e1f758b & echo Switched to "extreme".  & goto power-optionend)
    set localmsg=Ordered plan not exist. & goto power-optionend
)

if "%order:~0,3%"=="del" (
    powercfg /delete %order:~4%
)

set localmsg=Invaild command.
:power-optionend
if "%2"=="" (goto po) else (goto eof)


:self
if not "%2"=="" (set order=%2)
set local=self
set localmsg=Self mangement.
goto core
:selfrun
if "%order%"=="dir" (start explorer.exe /n,/e,%cd%)
if "%order%"=="edit" (start "vsCode" code %~dp0%\fran.cmd)
if "%order%"=="edk2" (start explorer.exe /n,/e,%edk2dir%\)
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
cd docto
set local=docto
set localmsg=Docment covent, doc to to pdf.
goto core
:doctorun
echo Task is running...
docto -WD -F %order% -T wdFormatPDF -O %userprofile%\downloads\
if "%2"=="" (goto back) else (goto eof)



:eof
if not "%localmsg%"=="" (echo %localmsg%)
if not "%eofmsg%"=="" (echo %eofmsg%)
set eofmsg=
echo.
if "%local:~0,3%"=="adb" (taskkill -f -im adb.exe)
timeout 1 > nul
@cd /d %ccd%