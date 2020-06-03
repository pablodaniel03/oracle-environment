@echo off
rem
rem ----------------------------------------------
rem Created by: Pablo Almaguer
rem Creation date: 2020/06/01
rem 
rem Fork or clone from source repo:
rem  https://bitbucket.org/pablodaniel03
rem ----------------------------------------------
rem
rem Usage: runEndecaService.bat start|stop
rem   Endeca<varsion>_Environment.bat needs to be sourced
rem   before running this script.
rem 

set args="%*"
:argloop
for /f "tokens=1*" %%a in (%args%) do (
  
  if "%%a"=="start" goto :startEndecaServices
  if "%%a"=="stop" goto :stopEndecaServices
  
  goto :usage
  set args="%%b"
)
if not [%args%]==[""] goto :argloop
goto :usage

:usage
  echo Usage:
  echo    script-name [start]^|[stop]
  echo.
goto :failed

:startEndecaServices
  echo.
  echo Starting Endeca Services
  echo --------------------------------------
  echo.
  echo  1. Platform Services
  call ""%ENDECA_ROOT%\tools\server\bin\setenv.bat"" > nul 2>&1
  start CMD /c ""%ENDECA_ROOT%\tools\server\bin\startup.bat""
  
  echo  2. Tools ^& Frameworks
  start CMD /c ""%ENDECA_TOOLS_ROOT%\server\bin\run.bat""

  echo  3. CAS Service 
  start CMD /c ""%CAS_ROOT%\bin\cas-service.bat""
goto :end


:stopEndecaServices
  echo.
  echo Stoping Endeca Services
  echo --------------------------------------
  echo.
  echo  1. Platform Services
  start CMD /c ""%ENDECA_ROOT%\tools\server\bin\shutdown.bat""
  
  echo  2. Tools ^& Frameworks
  start CMD /c ""%ENDECA_TOOLS_ROOT%\server\bin\stop.bat""

  echo  3. CAS Service 
  start CMD /c ""%CAS_ROOT%\bin\cas-service-shutdown.bat""
goto :end

:end
  if not %ERRORLEVEL%==0 goto :failed
  exit /b 0

:failed
  exit /b 1

