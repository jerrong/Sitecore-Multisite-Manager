SETLOCAL 

if "%DATABASE%" == "" set DATABASE=%1
if "%PASSWORD%" == "" set PASSWORD=%2
if "%PREFIX%" == ""   set PREFIX=%3
if "%TBS%" == ""      set TBS=%4

if "%DATABASE%" == "" set DATABASE=sitecore
if "%PASSWORD%" == "" set PASSWORD=manager
if "%TBS%" == ""      set TBS=sitecore
if "%PREFIX%" == ""   set PREFIX=sc

sqlplus system/%PASSWORD%@%DATABASE% @drop.sql %PREFIX%core
sqlplus system/%PASSWORD%@%DATABASE% @drop.sql %PREFIX%master
sqlplus system/%PASSWORD%@%DATABASE% @drop.sql %PREFIX%web

ENDLOCAL

