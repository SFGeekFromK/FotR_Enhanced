@echo off
:: 소스 디렉터리 (XML 파일이 있는 경로)
set "SOURCE_DIR=C:\Path\To\XMLFiles"

:: 대상 디렉터리 (모드 경로)
set "MOD_DIR=C:\Path\To\SteamLibrary\steamapps\workshop\content\32470\{ModID}"

:: 이동 작업 시작
echo Moving XML files from %SOURCE_DIR% to %MOD_DIR% while preserving directory structure...

:: 하위 디렉터리 포함하여 XML 파일 이동
for /r "%SOURCE_DIR%" %%F in (*.xml) do (
    set "REL_PATH=%%~pF"
    set "REL_PATH=%REL_PATH:%SOURCE_DIR%=%"
    set "TARGET_PATH=%MOD_DIR%\%REL_PATH%"
    
    :: 파일이 이미 존재하면 원본에 _Origin 추가
    if exist "%TARGET_PATH%" (
        set "TARGET_PATH=%TARGET_PATH:_Origin=%"
        set "TARGET_PATH=%TARGET_PATH%.xml"
    )
    
    if not exist "%TARGET_PATH%" (
        mkdir "%TARGET_PATH%"
    )
    move "%%F" "%TARGET_PATH%" >nul
    echo Moved: %%F to %TARGET_PATH%
)

if %errorlevel% equ 0 (
    echo All XML files successfully moved!
) else (
    echo An error occurred during the move process.
)

pause
