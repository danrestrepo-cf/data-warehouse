@ECHO OFF

REM set the KETTLE_HOME environment variable to the project directory so it knows where to find .kettle\repositories.xml
set KETTLE_HOME=%HOMEPATH%\Projects\data-warehouse\pentaho\src

REM swap the repositories.xml file with the one with valid spoon settings
echo Swapping repositories.xml with Windows version
copy %HOMEPATH%\Projects\data-warehouse\settings\repositories_spoon.xml %HOMEPATH%\Projects\data-warehouse\pentaho\src\.kettle\repositories.xml

REM start Spoon in a new process so we can replace the repositories.xml file sooner than waiting for the process to end
echo Starting Spoon.bat
call C:\pentaho\Spoon.bat

REM replacing the spoon repository file with the docker file after a delayf
echo Waiting 60 seconds...
TIMEOUT /T 60

echo Swapping repositories.xml with docker version
copy %HOMEPATH%\Projects\data-warehouse\settings\repositories_docker.xml %HOMEPATH%\Projects\data-warehouse\pentaho\src\.kettle\repositories.xml
