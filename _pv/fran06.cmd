@echo off
set edk2dir=D:\AirOS\edk2
set ccd=%cd%
cd /d %~dp0%
set order= & set local= & set localmsg=
set ver=0.6
if exist fran (cd fran)
if not "%1"=="" (set order=%2 & goto %1)
set local=core
goto core
:back
if not exist francmdlist (cd /d %~dp0%)
if "%local:~0,3%"=="air" (cd /d C:\_Addon\fran\)
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
if "%order%"=="back" (goto back)
if "%order%"=="exit" (if "%eofmsg%"=="" (set eofmsg=Take care, have a nice day. & goto back) else (goto back))
if "%local%"=="core" (
findstr %order% francmdlist > nul && goto %order%
%order% & goto core
) else (
if not "%cd:~-3%"=="ran" (cd ..)
if "%order%"=="cd" (echo %cd% & goto %local%)
if "%local:~0,3%"=="adb" (cd adb)
if "%local:~0,8%"=="fastboot" (cd adb)
if "%local:~0,2%"=="dl" (cd dl)
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
set local=fastboot-devices
fastboot devices > msg
set /p localmsg= < msg
goto back



:aff
set local=fastboot-flash
if not "%2"=="" (fastboot flash %2 & goto eof)
goto core
:fastboot-flashrun
fastboot flash "%order%"
if "%2"=="" (goto %local%) else (goto eof)



:affr
set local=fastboot-flash-recovery
if not "%2"=="" (fastboot flash recovery %2 & goto eof)
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
if "%4"=="" (set order=%2 %3 & goto dlruns)
if "%5"=="" (set order=%2 %3=%4 & goto dlruns)
if "%6"=="" (set order=%2 %3=%4=%5 & goto dlruns)
)
:dlruns::::::::::::::::::::::::::::::::::::::::::
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

:virtualboxresolution
:virtuslboxscreen
:boxscreen
::VBoxManage setextradata "Name" VBoxInternal2/EfiGraphicsResolution 1920x1080


:spa
:envpath
:envpaths
start C:\Windows\System32\SystemPropertiesAdvanced.exe
if "%1"=="" (goto back) else (goto eof)

:ctp
:panel
:controlpanel
"C:\_Addon\fran\ctp.lnk"
if "%1"=="" (goto back) else (goto eof)

:self
if not "%2"=="" (set order=%2)
set local=self
set localmsg=Self mangement.
goto core
:selfrun
if "%order%"=="dir" (start explorer.exe /n,/e,C:\_Addon\fran)
if "%order%"=="edit" (start notepad.exe %~dp0%\fran.cmd)
if "%order%"=="edk2" (start explorer.exe /n,/e,%edk2dir%\)
if "%2"=="" (goto back) else (goto eof)

::::::::::::::::::::::::::::::::::::::::::
:air
set local=air
goto core
:airrun
if not "%2"=="" (set order=%2 %3)
if "%order:~0,4%"=="uefi" (
    if "%order:~5%"=="build" (
    cd /d %edk2dir%\
    mkdir Build\OvmfX64\DEBUG_VS2015\FV\hda-contents\
    call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
    echo Doing edk2 build task...
    call edksetup.bat VS2015
    set NASM_PREFIX="C:\Program Files\NASM\"
    set WINSDK81_PREFIX="c:\Program Files (x86)\Windows Kits\8.1\bin\"
    build -a X64 -p OvmfPkg\OvmfPkgX64.dsc -t VS2015 -b DEBUG -m "%edk2dir%\_HelloWorld\helloworld.inf"
    goto eof)

    if "%order:~5%"=="dir" (
    explorer.exe /n,/e,%edk2dir% & goto eof)

    if "%order:~5%"=="emu" (
    set BUILD=%edk2dir%\Build
    "c:\Program Files\qemu\qemu-system-x86_64.exe" -m 1024 -smp 1 -bios %build%\OvmfX64\DEBUG_VS2015\FV\OVMF.fd -global e1000.romfile="" -machine q35 -serial mon:stdio -hda fat:rw:%build%\OvmfX64\DEBUG_VS2015\FV\hda-contents --net none
    if "%2"=="" (goto %local%) else (goto eof))

    if "%order:~5%"=="load" (
    del %edk2dir%\Build\OvmfX64\DEBUG_VS2015\FV\hda-contents\*.efi
    copy %edk2dir%\Build\OvmfX64\DEBUG_VS2015\X64\_HelloWorld\helloworld\OUTPUT\*.efi %edk2dir%\Build\OvmfX64\DEBUG_VS2015\FV\hda-contents
    if "%2"=="" (goto %local%) else (goto eof))
    
    if "%order:~5%"=="edit" (
    explorer.exe /n,/e/,%edk2dir%\_HelloWorld
    )
    if "%order:~5%"=="editdisk" (
    explorer.exe /n,/e/,%edk2dir%\Build\OvmfX64\DEBUG_VS2015\FV\hda-contents
    )
)
set localmsg=Invaild command.
if "%2"=="" (goto %local%) else (goto eof)
::::::::::::::::::::::::::::::::::::::::::



:docto
cd docto
if not "%2"=="" (set order=%2)
set local=docto
set localmsg=Docment covent, doc to to pdf.
goto core
:doctorun
echo Task is running...
docto -WD -F %order% -T wdFormatPDF -O %userprofile%\downloads\
if "%2"=="" (goto back) else (goto eof)



:eof
if not "%eofmsg%"=="" (echo %eofmsg%)
set eofmsg=
echo.
if "%local:~0,3%"=="adb" (taskkill -f -im adb.exe)
timeout 1 > nul
@cd /d %ccd%