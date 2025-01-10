@echo off
:: 소스 디렉터리 (타 디렉터리 구조)
set "SOURCE_DIR=C:\Path\To\SourceDirectory"

:: 대상 디렉토리 (모드 경로)
set "MOD_DIR=C:\Path\To\SteamLibrary\steamapps\workshop\content\32470\{ModID}"

:: 타 디렉터리에서 옮긴 XML 파일 구조 확인
echo Analyzing source directory structure...

for /r "%SOURCE_DIR%" %%F in (*.xml) do (
    set "REL_PATH=%%~pF"
    set "REL_PATH=%REL_PATH:%SOURCE_DIR%=%"
    set "MOD_FILE_PATH=%MOD_DIR%\%REL_PATH%"
    if exist "%MOD_FILE_PATH%" (
        del "%MOD_FILE_PATH%"
        echo Deleted: %MOD_FILE_PATH%
    )
)

:: _Origin 접두사가 붙은 파일 이름 복구
for /r "%MOD_DIR%" %%F in (*_Origin.xml) do (
    set "REL_PATH=%%~nxF"
    set "REL_PATH=%REL_PATH:_Origin=%.xml"
    set "TARGET_PATH=%MOD_DIR%\%REL_PATH%"
    move "%%F" "%TARGET_PATH%" >nul
    echo Restored: %%F to %TARGET_PATH%
)

if %errorlevel% equ 0 (
    echo All _Origin files successfully restored and moved!
) else (
    echo Failed to restore some files.
)

pause
