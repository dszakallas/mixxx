@echo off

REM set this to the folder where you build the dependencies
set WINLIB_PATH=D:\mixxx-buildserver32

REM The default language and corresponding LangID
SET DefaultLanguage=en-us
SET LangIds=1033

REM Development tool settings
SET WinSDKVersion=v7.0

echo *** Cleaning
if exist *.wixobj del *.wixobj
if exist *.wixpdb del *.wixpdb 2>NUL
if exist *.mst del *.mst 2>NUL
if exist subdirs\*.* del /Q subdirs\*.*

echo.
echo *** Building intermediate files

FOR %%d IN (controllers,fonts,imageformats,keyboard,plugins,skins,translations) DO (
  "%WIX%"\bin\heat.exe dir ..\..\dist32\%%d -nologo -sfrag -suid -ag -srd -cg %%dComp -dr %%dDir -out subdirs\%%d.wxs -sw5150 -var var.%%dVar  
  "%WIX%"\bin\candle.exe -nologo -dWINLIBPATH=%WINLIB_PATH% -dPlatform=x86 -d%%dVar=..\..\dist32\%%d -arch x86 -out subdirs\%%d.wixobj subdirs\%%d.wxs
)

SET promo=no

IF EXIST ..\..\dist32\promo (
  SET promo=yes
  "%WIX%"\bin\heat.exe dir ..\..\dist32\promo -nologo -sfrag -suid -ag -srd -cg promoComp -dr promoDir -out subdirs\promo.wxs -sw5150 -var var.promoVar  
  "%WIX%"\bin\candle.exe -nologo -dWINLIBPATH=%WINLIB_PATH% -dPlatform=x86 -dpromoVar=..\..\dist32\promo -arch x86 -out subdirs\promo.wixobj subdirs\promo.wxs
)

REM Harvest main DLL from install dir
"%WIX%"\bin\heat.exe dir ..\..\dist32 -nologo -sfrag -suid -ag -srd -cg mainDLLCompGroup -dr INSTALLDIR -out subdirs\mainDLL.wxs -sw5150 -var var.SourceDir -t only-dll.xslt
"%WIX%"\bin\candle.exe -nologo -dWINLIBPATH=%WINLIB_PATH% -dPlatform=x86 -dSourceDir=..\..\dist32 -arch x86 -out subdirs\mainDLL.wixobj subdirs\mainDLL.wxs

"%WIX%"\bin\candle.exe -nologo -dWINLIBPATH=%WINLIB_PATH% -dPlatform=x86 -arch x86 warningDlg.wxs
"%WIX%"\bin\candle.exe -nologo -dWINLIBPATH=%WINLIB_PATH% -dPlatform=x86 -dPromo=%promo% -arch x86 mixxx.wxs

echo.
echo *** Building package for default language %DefaultLanguage%
"%WIX%"\bin\light.exe -nologo -sw1076 -ext WixUIExtension -cultures:%DefaultLanguage% -loc Localization\mixxx_%DefaultLanguage%.wxl -out mixxx-32-multilingual.msi *.wixobj subdirs\*.wixobj

FOR %%G IN (Localization\*.wxl) DO (
  REM skip 19 chars (Localization\mixxx_), keep until end -4 char (.wxl)
  set _locfile=%%G
  set _locale=!_locfile:~19,-4!
  IF "!_locale!" NEQ "%DefaultLanguage%" (
    REM Look for LangID in the wxl file. Don't ask me to explain the magic of this line ;)
    for /f "delims=<> tokens=3" %%i in ('findstr "^[space]*<<String Id=.Language" Localization\mixxx_!_locale!.wxl') do set _LangID=%%i
    echo.
    echo *** Building package transform for locale !_locale! LangID !_LangID!
    "%WIX%"\bin\light.exe -nologo -sw1076 -ext WixUIExtension -cultures:!_locale! -loc %%G -out mixxx-32-!_locale!.msi *.wixobj subdirs\*.wixobj
    "%WIX%"\bin\torch.exe -nologo mixxx-32-multilingual.msi mixxx-32-!_locale!.msi -o !_locale!.mst
    cscript "%ProgramFiles%\Microsoft SDKs\Windows\%WinSDKVersion%\Samples\sysmgmt\msi\scripts\wisubstg.vbs" mixxx-32-multilingual.msi !_locale!.mst !_LangID!
    SET LangIDs=!LangIDs!,!_LangID!
    del /Q mixxx-32-!_locale!.msi
    del /Q !_locale!.mst
  )
)

echo.
echo *** Add all supported languages to MSI Package attribute
cscript "%ProgramFiles%\Microsoft SDKs\Windows\%WinSDKVersion%\Samples\sysmgmt\msi\scripts\WiLangId.vbs" mixxx-32-multilingual.msi Package %LangIDs%