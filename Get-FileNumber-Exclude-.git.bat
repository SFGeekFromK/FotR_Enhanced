@echo off
:: 코드 페이지를 UTF-8로 설정 (한글 출력 지원)
chcp 65001 >nul

:: 디렉터리를 지정합니다 (현재 디렉터리를 기본값으로 설정)
set "directory=%cd%"

:: 사용자 지정 디렉터리를 입력받습니다.
if not "%~1"=="" (
    set "directory=%~1"
)

:: 총 파일 갯수 계산 (하위 디렉터리 포함, .git 폴더 제외)
set "file_count=0"
for /f "delims=" %%A in ('dir /a-d /s /b "%directory%" 2^>nul ^| findstr /v /i "\\.git\\" ^| find /c /v ""') do (
    set "file_count=%%A"
)

:: 결과 출력
echo 디렉터리 "%directory%" 내의 파일 갯수 (.git 폴더 제외): %file_count%

:: 스크립트 종료
pause
