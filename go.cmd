@echo off

SET DIR= '.\scm\build\packages\psake.4.0.1.0\tools\'
REM %~dp0%

if '%1'=='/?' goto usage
if '%1'=='-?' goto usage
if '%1'=='?' goto usage
if '%1'=='/help' goto usage
if '%1'=='help' goto usage
if '%1'=='/tasks' goto tasks
if '%1'=='tasks' goto tasks
if '%1'=='-tasks' goto tasks
if '%1'=='ndepend' goto ndepend

IF [%1]==[] (
	set ARGS='default'
	set ENVIRONMENT=development
	goto :runpsake
)

IF [%2]==[] (
	set ARGS=%1
	set ENVIRONMENT=development
	goto :runpsake
)

set ARGS=%1
set ENVIRONMENT=%2
set PROPERTIES=""
IF [%3] == "" goto :runpsake

set PROPERTIES="target='%3'"

:runpsake
powershell -inputformat none -NoProfile -ExecutionPolicy unrestricted -Command "& "'.\scm\psake.ps1' %PSAKE_OPTS% 'default.ps1' %ARGS% '4.0' '%ENVIRONMENT%'" -properties @{%PROPERTIES%}
if %ERRORLEVEL% == 0 goto :eof
exit /B %ERRORLEVEL%
goto :eof

:usage
powershell -inputformat none -NoProfile -ExecutionPolicy unrestricted -Command "& '.\scm\packages\psake.4.0.1.0\tools\psake-help.ps1'"
goto :eof

:tasks
set PSAKE_OPTS=-docs
set ARGS=
goto :runpsake

:ndepend
rem This command runs a headless NDepend analisys on build agent DEVBAM9SY401, triggered by a nightly TeamCity plan.
rem The *.ndproj NDepend project specified below was generated specifically for that environment (by running VisualNDepend.exe on that machine) and it is not transferable.
rem To run NDepend on your local machine simply run .\external\ndepend\NDepend_3.9.0.5848\VisualNDepend.exe and point it to your VS sln file.
.\external\ndepend\NDepend_3.9.0.5848\NDepend.Console.exe "%~dp0NDependProject.BuildAgent.ndproj" /Silent /HideConsole /OutDir D:\NDependReports
:eof

